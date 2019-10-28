cordova.define("mobile-plugin-fingerprint.FingerprintPlugin", function(require, exports, module) {

  var FingerprintPlugin = function () {
  };

  FingerprintPlugin.prototype.isAvailable = function (succ, fail, value) {
    cordova.exec(succ, fail, 'FingerprintPlugin', 'isAvailable', [value]);
  };
  
  FingerprintPlugin.prototype.authenticate = function (succ, fail, value) {
    cordova.exec(succ, fail, 'FingerprintPlugin', 'authenticate', [value]);
  };

  if (!window.plugins) {
      window.plugins = {};
  }

  var instance = new FingerprintPlugin();
  if (!window.plugins.FingerprintPlugin) {
      window.plugins.FingerprintPlugin = instance;
  }
  module.exports = instance;


});
