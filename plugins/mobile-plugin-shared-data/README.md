
---
#mobile-plugin-shared-data
---
提供了多个webview之间共享的内存变量的操作方法，包括存储、获取、删除数据的方法

这个插件是定义在`window.plugins`下的`mobile-plugin-shared-data`中，提供API来进行多个webview之间共享的内存变量的操作。

尽管这个插件对象被添加到了window.plugins的下面，我们只能够在`deviceready`之后调用该插件。

```js
//将初始状态state传递给native
document.addEventListener('deviceready', () => {
      if(window.plugins && window.plugins.SharedDataPlugin){
        window.plugins.SharedDataPlugin.isInitialized( bInit =>{
          console.log('@@@@@@ bInit ' + bInit);
          if(!bInit){
            window.plugins.SharedDataPlugin.initialize(() => {
              resolve();
            }, () => { reject();}, state);
          }else{
            reject();
          }
        }, null);
      }else{
        reject();
      }
});
```


## Installation

    cordova plugin add http://git.envisioncn.com/FE/mobile-plugin-shareddata.git --save

<a name="module_SharedDataPlugin"></a>

## SharedDataPlugin

- [#mobile-plugin-shared-data](#mobile-plugin-shared-data)
- [Installation](#installation)
- [SharedDataPlugin](#shareddataplugin)
  - [SharedDataPlugin ⏏](#shareddataplugin-%E2%8F%8F)
    - [window.plugins.SharedDataPlugin.initialize(succ, fail, state) ⇒ <code>Promise</code>](#windowpluginsshareddataplugininitializesucc-fail-state-%E2%87%92-codepromisecode)
    - [window.plugins.SharedDataPlugin.setItem(succ, fail, key, value) ⇒ <code>Promise</code>](#windowpluginsshareddatapluginsetitemsucc-fail-key-value-%E2%87%92-codepromisecode)
    - [window.plugins.SharedDataPlugin.getItem(succ, fail, key) ⇒ <code>Promise</code>](#windowpluginsshareddataplugingetitemsucc-fail-key-%E2%87%92-codepromisecode)
    - [window.plugins.SharedDataPlugin.removeItem(succ, fail, key) ⇒ <code>Promise</code>](#windowpluginsshareddatapluginremoveitemsucc-fail-key-%E2%87%92-codepromisecode)

<a name="exp_module_SharedDataPlugin--SharedDataPlugin"></a>

### SharedDataPlugin ⏏
**Kind**: Exported class  
<a name="module_SharedDataPlugin--SharedDataPlugin+initialize"></a>

#### window.plugins.SharedDataPlugin.initialize(succ, fail, state) ⇒ <code>Promise</code>
初始化多个Webview共享的内存变量

**Kind**: instance method of [<code>SharedDataPlugin</code>](#exp_module_SharedDataPlugin--SharedDataPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| state | <code>Object</code> | 多个webview之间共享的数据对象的初始化 |

**Example**  
usage: 在应用开启后，进行共享内存变量的初始化

```js
  //将初始状态state传递给native
  document.addEventListener('deviceready', () => {
        if(window.plugins && window.plugins.SharedDataPlugin){
          window.plugins.SharedDataPlugin.isInitialized( bInit =>{
            if(!bInit){
              window.plugins.SharedDataPlugin.initialize(() => {
                resolve();
              }, () => { reject();}, state);
            }else{
              reject();
            }
          }, null);
        }else{
          reject();
        }
  });
```
<a name="module_SharedDataPlugin--SharedDataPlugin+setItem"></a>

#### window.plugins.SharedDataPlugin.setItem(succ, fail, key, value) ⇒ <code>Promise</code>
混合应用界面换功能，可以替换网页界面和Native界面

**Kind**: instance method of [<code>SharedDataPlugin</code>](#exp_module_SharedDataPlugin--SharedDataPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| key | <code>String</code> | 需要在多个webview之间共享的数据的key |
| value | <code>String</code> | 需要在多个webview之间共享的数据的value |

**Example**  
usage:将数据以key-value的形式存储到多个webiview界面的共享内存中

```js
 document.addEventListener('deviceready', () => {
      if (window.plugins && window.plugins.SharedDataPlugin) {
        window.plugins.SharedDataPlugin.setItem(() => {
          resolve();
        }, () => { reject(); }, key, value);
      } else {
        reject();
      }
 });

```
<a name="module_SharedDataPlugin--SharedDataPlugin+getItem"></a>

#### window.plugins.SharedDataPlugin.getItem(succ, fail, key) ⇒ <code>Promise</code>
混合应用的回退功能

**Kind**: instance method of [<code>SharedDataPlugin</code>](#exp_module_SharedDataPlugin--SharedDataPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| key | <code>String</code> | 需要得到的数据的key |

**Example**  
usage:通过key，来从共享内存中获取数据，获取到的数据可以在Promise.then方法中进行处理。

```js
document.addEventListener('deviceready', () => {
      if(window.plugins && window.plugins.SharedDataPlugin){
        window.plugins.SharedDataPlugin.getItem((value)=>{
          resolve(value);
        }, () => { reject(); }, key);
      }else{
        reject();
      }
});
```
<a name="module_SharedDataPlugin--SharedDataPlugin+removeItem"></a>

#### window.plugins.SharedDataPlugin.removeItem(succ, fail, key) ⇒ <code>Promise</code>
混合应用的回退功能

**Kind**: instance method of [<code>SharedDataPlugin</code>](#exp_module_SharedDataPlugin--SharedDataPlugin)  

| Param | Type | Description |
| --- | --- | --- |
| succ | <code>function</code> | 调用成功的回调,如果不需要回调则传null |
| fail | <code>function</code> | 调用失败的回调,如果不需要回调则传null |
| key | <code>String</code> | 需要移除的数据的key |

**Example**  
usage:通过key，来从共享内存中删除数据。

```js
ddocument.addEventListener('deviceready', () => {
      if(window.plugins && window.plugins.SharedDataPlugin){
        window.plugins.SharedDataPlugin.removeItem(()=>{
          resolve();
        }, null, key);
      }else{
        reject();
      }
});
```

