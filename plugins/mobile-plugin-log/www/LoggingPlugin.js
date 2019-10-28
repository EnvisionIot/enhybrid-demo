var LoggingPlugin = function () {
};

LoggingPlugin.prototype.log = function (succ, fail, message) {
  console.log('@@@@@@ ',message);
  cordova.exec(succ, fail, 'LoggingPlugin', 'log', [message]);
};


if (!window.plugins) {
    window.plugins = {};
}

var instance = new LoggingPlugin();
if (!window.plugins.LoggingPlugin) {
    window.plugins.LoggingPlugin = instance;
}
module.exports = instance;