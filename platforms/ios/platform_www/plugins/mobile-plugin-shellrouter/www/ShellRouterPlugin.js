cordova.define("mobile-plugin-shellrouter.ShellRouterPlugin", function(require, exports, module) {

  var ShellRouterPlugin = function () {
  };

  ShellRouterPlugin.prototype.pushState = function (succ, fail, path) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'pushState', [path]);
  };
  
  ShellRouterPlugin.prototype.replaceState = function (succ, fail, path) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'replaceState', [path]);
  };

  ShellRouterPlugin.prototype.goBack = function (succ, fail) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'goBack', []);
  };

  ShellRouterPlugin.prototype.logout = function (succ, fail) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'logout', []);
  };

  ShellRouterPlugin.prototype.action = function (succ, fail, datas) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'action', datas ? datas : []);
  };

  if (!window.plugins) {
      window.plugins = {};
  }

  var instance = new ShellRouterPlugin();
  if (!window.plugins.ShellRouterPlugin) {
      window.plugins.ShellRouterPlugin = instance;
  }
  module.exports = instance;


});
