
---
# mobile-plugin-navigation-bar
---
提供了对Native导航栏设置title，左右两侧图标和角标的方法

这个插件是定义在`window.plugins`下的`mobile-plugin-navigation-bar `中，提供API来进行多个webview之间共享的内存变量的操作。

尽管这个插件对象被添加到了window.plugins的下面，我们只能够在`deviceready`之后调用该插件。

```js
//将初始状态state传递给native
 export function enableNativeNaviBar() {
   return new Promise((resolve, reject) => {
     document.addEventListener('deviceready', () => {
       if (window.plugins && window.plugins.NaviBarPlugin) {
         window.plugins.NaviBarPlugin.enableNaviBar(() => {
           resolve();
         }, () => {
           reject();
         });
       }
     });
   });
 }
```


## Installation

    cordova plugin add @enos/mobile-plugin-navigation-bar --save

<a name="module_NaviBarPlugin"></a>

## NaviBarPlugin

- [# mobile-plugin-navigation-bar](#mobile-plugin-navigation-bar)
- [Installation](#installation)
- [NaviBarPlugin](#navibarplugin)
  - [NaviBarPlugin ⏏](#navibarplugin-%E2%8F%8F)
    - [window.plugins.NaviBarPlugin.enableNaviBar(succ, fail)](#windowpluginsnavibarpluginenablenavibarsucc-fail)
    - [window.plugins.NaviBarPlugin.disableNaviBar(succ, fail)](#windowpluginsnavibarplugindisablenavibarsucc-fail)
    - [window.plugins.NaviBarPlugin.setNativeTitle(succ, fail, title)](#windowpluginsnavibarpluginsetnativetitlesucc-fail-title)
    - [window.plugins.NaviBarPlugin.setNativeLeftIcon(succ, fail, icon)](#windowpluginsnavibarpluginsetnativelefticonsucc-fail-icon)
    - [window.plugins.NaviBarPlugin.setNativeRightIcon(succ, fail, icon)](#windowpluginsnavibarpluginsetnativerighticonsucc-fail-icon)
    - [window.plugins.NaviBarPlugin.showLeftBadge(succ, fail, num)](#windowpluginsnavibarpluginshowleftbadgesucc-fail-num)
    - [window.plugins.NaviBarPlugin.showRightBadge(succ, fail, num)](#windowpluginsnavibarpluginshowrightbadgesucc-fail-num)
    - [window.plugins.NaviBarPlugin.hideNativeLeftBadge(succ, fail)](#windowpluginsnavibarpluginhidenativeleftbadgesucc-fail)
    - [window.plugins.NaviBarPlugin.hideRightBadge(succ, fail)](#windowpluginsnavibarpluginhiderightbadgesucc-fail)

<a name="exp_module_NaviBarPlugin--NaviBarPlugin"></a>

### NaviBarPlugin ⏏
**Kind**: Exported class  
<a name="module_NaviBarPlugin--NaviBarPlugin+enableNaviBar"></a>

#### window.plugins.NaviBarPlugin.enableNaviBar(succ, fail)
启用Native导航栏

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |

**Example**  
usage: 启用native导航栏

```js
  //将初始状态state传递给native
  export function enableNativeNaviBar() {
    return new Promise((resolve, reject) => {
      document.addEventListener('deviceready', () => {
        if (window.plugins && window.plugins.NaviBarPlugin) {
          window.plugins.NaviBarPlugin.enableNaviBar(() => {
            resolve();
          }, () => {
            reject();
          });
        }
      });
    });
  }
```
<a name="module_NaviBarPlugin--NaviBarPlugin+disableNaviBar"></a>

#### window.plugins.NaviBarPlugin.disableNaviBar(succ, fail)
禁用native导航栏

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |

**Example**  
usage:禁用native导航栏

```js
 export function disableNativeNaviBar() {
  return new Promise((resolve, reject) => {
    document.addEventListener('deviceready', () => {
      if (window.plugins && window.plugins.NaviBarPlugin) {
        window.plugins.NaviBarPlugin.disableNaviBar(() => {
          resolve();
        }, () => {
          reject();
        });
      }
    });
  });
}
```
<a name="module_NaviBarPlugin--NaviBarPlugin+setNativeTitle"></a>

#### window.plugins.NaviBarPlugin.setNativeTitle(succ, fail, title)
设置native导航栏的title

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| title | <code>String</code> | 用来设置native导航栏的title |

**Example**  
usage: 通过传入title ，来设置native导航栏的title

```js
export function setNativeTitle(title) {
  return new Promise((resolve, reject) => {
    document.addEventListener('deviceready', () => {
      if (window.plugins && window.plugins.NaviBarPlugin) {
        window.plugins.NaviBarPlugin.setTitle(() => {
          resolve();
        }, () => {
          reject();
        }, title);
      }
    });
  });
}
```
<a name="module_NaviBarPlugin--NaviBarPlugin+setNativeLeftIcon"></a>

#### window.plugins.NaviBarPlugin.setNativeLeftIcon(succ, fail, icon)
设置native导航栏左侧的图标

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| icon | <code>String</code> | 设置native导航栏左侧的图标 |

**Example**  
usage: 传入icon，用来设置native左侧导航栏的图标,传入的string必须在更新 Native 中 iconfont.ttf，否则无法无法显示
对应图片

```js
 export function setNativeLeftIcon(icon) {
    return new Promise((resolve, reject) => {
      document.addEventListener('deviceready', () => {
        if (window.plugins && window.plugins.NaviBarPlugin) {
          window.plugins.NaviBarPlugin.setLeftIcon(() => {
            resolve();
          }, () => {
            reject();
          }, icon);
        }
      });
    });
  }
```
<a name="module_NaviBarPlugin--NaviBarPlugin+setNativeRightIcon"></a>

#### window.plugins.NaviBarPlugin.setNativeRightIcon(succ, fail, icon)
设置native导航栏右侧的图标

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| icon | <code>String</code> | 设置native导航栏右侧的图标 |

**Example**  
usage: 传入icon，用来设置native左侧导航栏的图标,传入的string必须在更新 Native 中 iconfont.ttf，否则无法无法显示
对应图片

```js
  export function setNativeRightIcon(icon) {
    return new Promise((resolve, reject) => {
      document.addEventListener('deviceready', () => {
        if (window.plugins && window.plugins.NaviBarPlugin) {
          window.plugins.NaviBarPlugin.setRightIcon(() => {
            resolve();
          }, () => {
            reject();
          }, icon);
        }
      });
    });
  }
```
<a name="module_NaviBarPlugin--NaviBarPlugin+showLeftBadge"></a>

#### window.plugins.NaviBarPlugin.showLeftBadge(succ, fail, num)
设置原生导航栏左侧图标的角标

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| num | <code>String</code> | 传入null，则只显示红点，传入字符串，显示字符串 |

**Example**  
usage: 设置左侧图标的角标

```js
   export function showNativeLeftBadge(num) {
    return new Promise((resolve, reject) => {
      document.addEventListener('deviceready', () => {
        if (window.plugins && window.plugins.NaviBarPlugin) {
          window.plugins.NaviBarPlugin.showLeftBadge(() => {
            resolve();
          }, () => {
            reject();
          }, num);
        }
      });
    });
  }
```
<a name="module_NaviBarPlugin--NaviBarPlugin+showRightBadge"></a>

#### window.plugins.NaviBarPlugin.showRightBadge(succ, fail, num)
设置原生导航栏右侧图标的角标

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| num | <code>String</code> | 传入null，则只显示红点，传入字符串，显示字符串 |

**Example**  
usage: 设置右侧图标的角标

```js
    export function showNativeRightBadge(num) {
      return new Promise((resolve, reject) => {
        document.addEventListener('deviceready', () => {
          if (window.plugins && window.plugins.NaviBarPlugin) {
            window.plugins.NaviBarPlugin.showRightBadge(() => {
              resolve();
            }, () => {
              reject();
            }, num);
          }
        });
      });
    }
```
<a name="module_NaviBarPlugin--NaviBarPlugin+hideNativeLeftBadge"></a>

#### window.plugins.NaviBarPlugin.hideNativeLeftBadge(succ, fail)
隐藏Native导航栏左侧的图标

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |

**Example**  
usage: 隐藏导航栏左侧图标的角标

```js
    export function hideNativeLeftBadge() {
      return new Promise((resolve, reject) => {
        document.addEventListener('deviceready', () => {
          if (window.plugins && window.plugins.NaviBarPlugin) {
            window.plugins.NaviBarPlugin.hideLeftBadge(() => {
              resolve();
            }, () => {
              reject();
            });
          }
        });
      });
    }
```
<a name="module_NaviBarPlugin--NaviBarPlugin+hideRightBadge"></a>

#### window.plugins.NaviBarPlugin.hideRightBadge(succ, fail)
隐藏Native导航栏右侧的图标

**Kind**: instance method of [<code>NaviBarPlugin</code>](#exp_module_NaviBarPlugin--NaviBarPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |

**Example**  
usage: 隐藏导航栏右侧图标的角标

```js
     export function hideNativeRightBadge() {
       return new Promise((resolve, reject) => {
         document.addEventListener('deviceready', () => {
           if (window.plugins && window.plugins.NaviBarPlugin) {
             window.plugins.NaviBarPlugin.hideRightBadge(() => {
               resolve();
             }, () => {
               reject();
             });
           }
         });
       });
     }
```

