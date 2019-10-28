
---
# mobile-plugin-shellrouter
---
提供混合应用的界面跳转，替换和回退的功能


这个插件是定义在`window.plugins`下的`window.plugins.ShellRouterPlugin`中，提供API来进行网页界面和Native界面间的跳转，替换，回退等功能。

尽管这个插件对象被添加到了window.plugins的下面，我们只能够在`deviceready`之后调用该插件。

```js
export default function push(path) {
  document.addEventListener('deviceready', () => {
      if (window.plugins && window.plugins.ShellRouterPlugin && path) {
        window.plugins.ShellRouterPlugin.pushState(null, null, path);
      }
    });
}

```

## Supported Platforms

```
iOS,Android
```

## Installation

    cordova plugin add http://gitlab.envisioncn.com/map-framework/envision-plugin-shareddata.git --save

<a name="module_ShellRouterPlugin"></a>

## ShellRouterPlugin

- [# mobile-plugin-shellrouter](#mobile-plugin-shellrouter)
- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
- [ShellRouterPlugin](#shellrouterplugin)
  - [ShellRouterPlugin ⏏](#shellrouterplugin-%E2%8F%8F)
    - [window.plugins.ShellRouterPlugin.pushState(succ, fail, path)](#windowpluginsshellrouterpluginpushstatesucc-fail-path)
    - [window.plugins.ShellRouterPlugin.replaceState(succ, fail, path)](#windowpluginsshellrouterpluginreplacestatesucc-fail-path)
    - [window.plugins.ShellRouterPlugin.goBack(succ, fail)](#windowpluginsshellrouterplugingobacksucc-fail)

<a name="exp_module_ShellRouterPlugin--ShellRouterPlugin"></a>

### ShellRouterPlugin ⏏
**Kind**: Exported class  
<a name="module_ShellRouterPlugin--ShellRouterPlugin+pushState"></a>

#### window.plugins.ShellRouterPlugin.pushState(succ, fail, path)
混合应用的界面跳转功能，可以进行网页和Native界面任意跳转

**Kind**: instance method of [<code>ShellRouterPlugin</code>](#exp_module_ShellRouterPlugin--ShellRouterPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| path | <code>String</code> | path是你将跳转到的页面的路由，例如：'/login' |

**Example**  
usage: 传入path，可以从当前界面跳转到路由为path的界面

```js
  document.addEventListener('deviceready', () => {
       if (window.plugins && window.plugins.ShellRouterPlugin && path) {
         window.plugins.ShellRouterPlugin.pushState(null, null, path);
       }
     });
```
<a name="module_ShellRouterPlugin--ShellRouterPlugin+replaceState"></a>

#### window.plugins.ShellRouterPlugin.replaceState(succ, fail, path)
混合应用界面换功能，可以替换网页界面和Native界面

**Kind**: instance method of [<code>ShellRouterPlugin</code>](#exp_module_ShellRouterPlugin--ShellRouterPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| path | <code>String</code> | path是你将替换的页面的路由，例如：'/login' |

**Example**  
usage:

```js
 document.addEventListener('deviceready', () => {
      if (window.plugins && window.plugins.ShellRouterPlugin && path) {
        window.plugins.ShellRouterPlugin.replaceState(null, null, path);
      }
    });

```
<a name="module_ShellRouterPlugin--ShellRouterPlugin+goBack"></a>

#### window.plugins.ShellRouterPlugin.goBack(succ, fail)
混合应用的回退功能

**Kind**: instance method of [<code>ShellRouterPlugin</code>](#exp_module_ShellRouterPlugin--ShellRouterPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |

**Example**  
usage:

```js
document.addEventListener('deviceready', () => {
    if (window.plugins && window.plugins.ShellRouterPlugin) {
        window.plugins.ShellRouterPlugin.goBack(null, null);
    }
   });
```

