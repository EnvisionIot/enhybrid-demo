cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "mobile-plugin-log.LoggingPlugin",
      "file": "plugins/mobile-plugin-log/www/LoggingPlugin.js",
      "pluginId": "mobile-plugin-log",
      "clobbers": [
        "window.plugins.LoggingPlugin"
      ]
    },
    {
      "id": "mobile-plugin-navigation-bar.NaviBarPlugin",
      "file": "plugins/mobile-plugin-navigation-bar/www/NaviBarPlugin.js",
      "pluginId": "mobile-plugin-navigation-bar",
      "clobbers": [
        "window.plugins.NaviBarPlugin"
      ]
    },
    {
      "id": "mobile-plugin-shared-data.SharedDataPlugin",
      "file": "plugins/mobile-plugin-shared-data/www/SharedDataPlugin.js",
      "pluginId": "mobile-plugin-shared-data",
      "clobbers": [
        "window.plugins.SharedDataPlugin"
      ]
    },
    {
      "id": "mobile-plugin-shellrouter.ShellRouterPlugin",
      "file": "plugins/mobile-plugin-shellrouter/www/ShellRouterPlugin.js",
      "pluginId": "mobile-plugin-shellrouter",
      "clobbers": [
        "window.plugins.ShellRouterPlugin"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-whitelist": "1.3.3",
    "mobile-plugin-envcontext": "0.0.4",
    "mobile-plugin-hybrid-init": "0.0.10",
    "mobile-plugin-hybrid-lib": "0.0.4",
    "mobile-plugin-log": "0.0.4",
    "mobile-plugin-navigation-bar": "0.0.5",
    "mobile-plugin-project-init": "1.0.0",
    "mobile-plugin-shared-data": "0.0.7",
    "mobile-plugin-shellrouter": "0.0.6",
    "mobile-plugin-web-container": "0.0.33"
  };
});