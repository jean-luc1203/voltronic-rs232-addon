module.exports = {
  uiPort: 1892,
  userDir: "/data",
  flowFile: "/data/flows.json",

  // false = Node-RED lit flows_cred.json en JSON clair
  credentialSecret: false,

  adminAuth: {
    type: "credentials",
    users: [{
      username: "pi",
      password: "$2a$12$fTPLydFlFsX7N6x8zqbnke7eIGdXDHWp4uzzqSdpOJClmFDEw1Ifu",
      permissions: "*"
    }]
  },

  nodesDir: ["/opt/node_modules"],

  functionGlobalContext: {
    crypto: require("crypto"),
    fs: require("fs"),
    path: require("path")
  },

  contextStorage: {
    default: {
      module: "memory"
    },
    persistent: {
      module: "localfilesystem"
    }
  },

  editorTheme: {
    projects: { enabled: false }
  },

  logging: {
    console: {
      level: "warn",
      metrics: false,
      audit: false
    }
  }
};
