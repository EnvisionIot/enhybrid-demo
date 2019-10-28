# LoggingPlugin
提供了打印日志的功能

# Installation

```bash
cordova plugin add http://gitlab.envisioncn.com/map-framework/envision-plugin-log.git --save
```
# Methods

```bash
window.plugins.LoggingPlugin.log(message)
```

# Supported Platforms

```bash
ios
```

# Quick Example

```bash
document.addEventListener('deviceready', () => {
      if (window.plugins.LoggingPlugin) {
        window.plugins.LoggingPlugin.log( ()=>{
          resolve();
        }, ()=>{
          reject();
        }, message);
      }else {
        resolve();
      }
    });
```  


