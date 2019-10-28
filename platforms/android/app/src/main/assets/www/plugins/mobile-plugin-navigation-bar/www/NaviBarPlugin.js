cordova.define("mobile-plugin-navigation-bar.NaviBarPlugin", function(require, exports, module) {

  var NaviBarPlugin = function () {
  };

  NaviBarPlugin.prototype.setTitle = function (succ, fail, title) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'setTitle', [title]);
  };
  
  NaviBarPlugin.prototype.setLeftIcon = function (succ, fail, icon) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'setLeftIcon', [icon]);
  };

  NaviBarPlugin.prototype.setRightIcon = function (succ, fail, icon) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'setRightIcon', [icon]);
  };

  NaviBarPlugin.prototype.showLeftBadge = function (succ, fail, num) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'showLeftBadge', [num]);
  };

  NaviBarPlugin.prototype.showRightBadge = function (succ, fail, num) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'showRightBadge', [num]);
  };

  NaviBarPlugin.prototype.hideLeftBadge = function (succ, fail) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'hideLeftBadge', []);
  };

  NaviBarPlugin.prototype.hideRightBadge = function (succ, fail) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'hideRightBadge', []);
  };

  NaviBarPlugin.prototype.enableNaviBar = function (succ, fail) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'enableNaviBar', []);
  };

  NaviBarPlugin.prototype.disableNaviBar = function (succ, fail) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'disableNaviBar', []);
  };

  NaviBarPlugin.prototype.showNaviBar = function (succ, fail) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'showNaviBar', []);
  };

  NaviBarPlugin.prototype.hideNaviBar = function (succ, fail) {
    cordova.exec(succ, fail, 'NaviBarPlugin', 'hideNaviBar', []);
  };

  if (!window.plugins) {
      window.plugins = {};
  }

  var instance = new NaviBarPlugin();
  if (!window.plugins.NaviBarPlugin) {
      window.plugins.NaviBarPlugin = instance;
  }
  module.exports = instance;


});
