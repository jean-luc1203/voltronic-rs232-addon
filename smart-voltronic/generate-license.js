const crypto = require("crypto");

const LICENSE_SECRET = "SVP_2026_9f7c2e51b4d84f38a1e9c7b6d5e4f301_ULTRA_LONG_SECRET";

function normStr(v) {
  return (v ?? "").toString().trim();
}

function signPayload(payload) {
  return crypto
    .createHmac("sha256", LICENSE_SECRET)
    .update(payload, "utf8")
    .digest("hex");
}

function generatePremiumKey(installId) {
  const cleanInstallId = normStr(installId);

  if (!cleanInstallId) {
    throw new Error("install_id is required");
  }

  const prefix = "SVP";
  const tier = "premium";
  const payload = `${prefix}|${tier}|${cleanInstallId}`;
  const signature = signPayload(payload);

  return `${payload}|${signature}`;
}

const installId = normStr(process.argv[2]);

if (!installId) {
  console.error("Usage: node generate-license.js <install_id>");
  process.exit(1);
}

try {
  const key = generatePremiumKey(installId);

  console.log("");
  console.log("Install ID:");
  console.log(installId);
  console.log("");
  console.log("Premium key:");
  console.log(key);
  console.log("");
} catch (err) {
  console.error("Error:", err.message);
  process.exit(1);
}
