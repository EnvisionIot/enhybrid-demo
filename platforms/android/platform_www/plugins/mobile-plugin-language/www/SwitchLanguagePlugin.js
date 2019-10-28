cordova.define("mobile-plugin-language.SwitchLanguagePlugin", function(require, exports, module) {

  var SwitchLanguagePlugin = function () {
  };

  SwitchLanguagePlugin.prototype.switchLanguage = function (succ, fail, language) {
    cordova.exec(succ, fail, 'SwitchLanguagePlugin', 'switchLanguage', [language]);
  };

  if (!window.plugins) {
      window.plugins = {};
  }

  var instance = new SwitchLanguagePlugin();
  if (!window.plugins.SwitchLanguagePlugin) {
      window.plugins.SwitchLanguagePlugin = instance;
  }
  module.exports = instance;


});
