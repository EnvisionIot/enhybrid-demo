import { device } from '@enos/envhybrid-utils';

function getUrlBase() {
  // 为了在cordova.js载入之前获得从native传过来的服务器地址，采用EnvContextPlugin 截获 html
  // 中发送到http://___/envcontext.js的请求，并返回执行一段js, 写入window.navigator.serverAddress
  // 注意EnvContextPlugin在config.xml中需要配置onload=true的参数，这样不用等到cordova.js调用相应的javascript
  // 函数，就可以初始化plugin
  const serverAddress = window.navigator.serverAddress;
  if (!serverAddress && device.isShell) {
    throw new Error('window.navigator.serverAddress 没有赋值！');
  }
  // 当从cordova app内，以file:// 协议启动的时候，直接连服务器后台，否则通过本地服务器做反向代理
  const urlBase = device.isShell ? serverAddress : `http://${location.host}`;
  return urlBase;
}

export default {
  getDataList: () => `${getUrlBase()}/mockdata/data/list`
};
