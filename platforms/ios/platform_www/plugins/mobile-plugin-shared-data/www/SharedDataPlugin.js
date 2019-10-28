cordova.define("mobile-plugin-shared-data.SharedDataPlugin", function(require, exports, module) {

  var SharedDataPlugin = function () {
  };

  SharedDataPlugin.prototype.isInitialized = function (succ, fail) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'isInitialized', []);
  };
  
  SharedDataPlugin.prototype.initialize = function (succ, fail, data) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'initialize', [data]);
  };
  
  SharedDataPlugin.prototype.getItem = function (succ, fail, key) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'getItem', [key]);
  };

  SharedDataPlugin.prototype.setItem = function (succ, fail, key, value) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'setItem', [key, value]);
  };

  SharedDataPlugin.prototype.removeItem = function (succ, fail, key) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'removeItem', [key]);
  };

  SharedDataPlugin.prototype.getPersistentItem = function (succ, fail, key) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'getPersistentItem', [key]);
  };

  SharedDataPlugin.prototype.savePersistentItem = function (succ, fail, key, value) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'savePersistentItem', [key, value]);
  };

  SharedDataPlugin.prototype.removePersistentItem = function (succ, fail, key) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'removePersistentItem', [key]);
  };

  SharedDataPlugin.prototype.getNamespaceItem = function (succ, fail, namespace, key) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'getNamespaceItem', [namespace, key]);
  };

  SharedDataPlugin.prototype.saveNamespaceItem = function (succ, fail, namespace, key, value) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'saveNamespaceItem', [namespace, key, value]);
  };

  SharedDataPlugin.prototype.removeNamespaceItem = function (succ, fail, namespace, key) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'removeNamespaceItem', [namespace, key]);
  };

  SharedDataPlugin.prototype.removeNamespaceAllItem = function (succ, fail, namespace) {
      cordova.exec(succ, fail, 'SharedDataPlugin', 'removeNamespaceAllItem', [namespace]);
  };
  if (!window.plugins) {
      window.plugins = {};
  }

  var instance = new SharedDataPlugin();
  if (!window.plugins.SharedDataPlugin) {
      window.plugins.SharedDataPlugin = instance;
  }

  module.exports = instance;


});
