cordova.define("mobile-plugin-skin.SwitchSkinPlugin", function(require, exports, module) {

  var SwitchSkinPlugin = function () {
  };

  SwitchSkinPlugin.prototype.switchSkin = function (succ, fail, skin) {
    cordova.exec(succ, fail, 'SwitchSkinPlugin', 'switchSkin', [skin]);
  };

  if (!window.plugins) {
      window.plugins = {};
  }

  var instance = new SwitchSkinPlugin();
  if (!window.plugins.SwitchSkinPlugin) {
      window.plugins.SwitchSkinPlugin = instance;
  }
  module.exports = instance;


});
