#!/usr/bin/env node
"use strict";

const fs = require("fs");

let WebSocketImpl = globalThis.WebSocket;
if (!WebSocketImpl) {
  try {
    WebSocketImpl = require("ws");
  } catch (err) {
    console.error(JSON.stringify({
      ok: false,
      error: "WebSocket unavailable: neither global WebSocket nor 'ws' package found",
      details: String(err && err.message ? err.message : err)
    }));
    process.exit(1);
  }
}

const action = process.argv[2] || "upsert";
const filePath = process.argv[3] || "/config/dashboards/smart_voltronic.json";

const token = process.env.SUPERVISOR_TOKEN;
const wsUrl = "ws://supervisor/core/websocket";

if (!token) {
  console.error(JSON.stringify({ ok: false, error: "Supervisor token missing" }));
  process.exit(1);
}

let input = null;

if (action !== "delete") {
  if (!fs.existsSync(filePath)) {
    console.error(JSON.stringify({ ok: false, error: `Dashboard file not found: ${filePath}` }));
    process.exit(1);
  }

  try {
    input = JSON.parse(fs.readFileSync(filePath, "utf8"));
  } catch (e) {
    console.error(JSON.stringify({ ok: false, error: `Invalid dashboard JSON in file: ${filePath}` }));
    process.exit(1);
  }
}

const dashboardMeta = input?.dashboard_meta || {};
const dashboardConfig = input?.config || {};
const urlPath = dashboardMeta.url_path || "smart-voltronic";
const title = dashboardMeta.title || "Smart Voltronic";
const icon = dashboardMeta.icon || "mdi:solar-power";
const showInSidebar = dashboardMeta.show_in_sidebar !== false;
const requireAdmin = !!dashboardMeta.require_admin;

const ws = new WebSocketImpl(wsUrl);
let nextId = 1;
const pending = new Map();
let finished = false;

function finishOk(extra = {}) {
  if (finished) return;
  finished = true;
  console.log(JSON.stringify({
    ok: true,
    action,
    dashboard: urlPath,
    ...extra
  }));
  try { ws.close(); } catch (_) {}
  process.exit(0);
}

function finishErr(error) {
  if (finished) return;
  finished = true;
  console.error(JSON.stringify({
    ok: false,
    action,
    dashboard: urlPath,
    error: String(error || "Unknown error")
  }));
  try { ws.close(); } catch (_) {}
  process.exit(1);
}

function sendJson(payload) {
  try {
    ws.send(JSON.stringify(payload));
  } catch (err) {
    throw new Error(String(err?.message || err || "WebSocket send failed"));
  }
}

function call(type, payload = {}) {
  return new Promise((resolve, reject) => {
    const id = nextId++;
    pending.set(id, { resolve, reject });

    try {
      sendJson({ id, type, ...payload });
    } catch (err) {
      pending.delete(id);
      reject(err);
    }
  });
}

function isAlreadyExistsError(err) {
  const msg = String(err?.message || err || "").toLowerCase();
  return (
    msg.includes("exists") ||
    msg.includes("already") ||
    msg.includes("configured")
  );
}

function isDashboardMissingError(err) {
  const msg = String(err?.message || err || "").toLowerCase();
  return (
    msg.includes("not found") ||
    msg.includes("unknown") ||
    msg.includes("does not exist") ||
    msg.includes("no config") ||
    msg.includes("not configured")
  );
}

async function createOrUpdateDashboard() {
  let createdDashboard = false;

  try {
    await call("lovelace/dashboards/create", {
      url_path: urlPath,
      title,
      icon,
      show_in_sidebar: showInSidebar,
      require_admin: requireAdmin,
      mode: "storage"
    });
    createdDashboard = true;
  } catch (err) {
    if (!isAlreadyExistsError(err)) {
      throw err;
    }
  }

  await call("lovelace/config/save", {
    url_path: urlPath,
    config: dashboardConfig
  });

  return {
    created_dashboard: createdDashboard,
    saved: true,
    file: filePath,
    title,
    icon
  };
}

async function deleteDashboard() {
  try {
    await call("lovelace/config/delete", {
      url_path: urlPath
    });

    return {
      deleted: true,
      file: filePath
    };
  } catch (err) {
    if (isDashboardMissingError(err)) {
      return {
        deleted: false,
        already_missing: true,
        file: filePath
      };
    }

    throw err;
  }
}

function getEventData(event) {
  if (typeof event === "string") return event;
  if (Buffer.isBuffer(event)) return event.toString();
  if (event && typeof event.data !== "undefined") {
    if (Buffer.isBuffer(event.data)) return event.data.toString();
    return String(event.data);
  }
  return String(event || "");
}

function handleMessage(raw) {
  let msg;
  try {
    msg = JSON.parse(getEventData(raw));
  } catch (e) {
    finishErr("Invalid websocket message");
    return;
  }

  if (msg.type === "auth_required") {
    try {
      sendJson({
        type: "auth",
        access_token: token
      });
    } catch (err) {
      finishErr(err?.message || err);
    }
    return;
  }

  if (msg.type === "auth_invalid") {
    finishErr("Authentication failed");
    return;
  }

  if (msg.type === "auth_ok") {
    (async () => {
      try {
        let result;

        if (action === "delete") {
          result = await deleteDashboard();
        } else {
          result = await createOrUpdateDashboard();
        }

        finishOk(result);
      } catch (err) {
        finishErr(err?.message || err);
      }
    })();
    return;
  }

  if (Object.prototype.hasOwnProperty.call(msg, "id")) {
    const waiter = pending.get(msg.id);
    if (!waiter) return;

    pending.delete(msg.id);

    if (msg.success === false) {
      waiter.reject(new Error(msg.error?.message || "Home Assistant error"));
    } else {
      waiter.resolve(msg.result);
    }
  }
}

if (typeof ws.on === "function") {
  ws.on("error", (err) => {
    finishErr(err?.message || "WebSocket error");
  });

  ws.on("message", (data) => {
    handleMessage(data);
  });

  ws.on("close", () => {
    if (!finished) {
      finishErr("WebSocket closed unexpectedly");
    }
  });
} else {
  ws.onerror = (event) => {
    finishErr(event?.message || "WebSocket error");
  };

  ws.onmessage = (event) => {
    handleMessage(event);
  };

  ws.onclose = () => {
    if (!finished) {
      finishErr("WebSocket closed unexpectedly");
    }
  };
}
