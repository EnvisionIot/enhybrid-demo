# Envhybrid Demo

本demo是基于EnvHybrid移动应用开发的程序，集成了EnOS Application Portal登录功能，展示了基本的页面跳转和数据持久化功能。通过EnvHybrid，你可以使用包括JavaScript，CSS，HTML 在内的主流前端技术开发移动应用。 

EnvHybrid内部封装了原生开发系统与JavaScript的交互功能及路由的解析、跳转功能。你可以使用EnvHybrid提供的API进行开发。EnvHybrid提供的原生导航栏提高了用户使用体验。同时EnvHybrid支持打开本地的和线上的H5页面，不依赖于特定的前端技术及代码语言。


## 系统要求

Envhybrid适用于iOS及Android操作系统：

- iOS: Xcode10.0或以上版本

- Android: Android Studio (Gradle Plugin Version: 3.2.0, Gradle Version: 4.6) 


## 开始前准备

将该demo项目克隆或下载至本地。

## Step 1: 运行demo

- iOS：使用Xcode运行以下程序： 
  ```
  {root-directory}/platforms/ios/hybrid-demo.xcworkspace
  ```

- Android：使用Android Studio运行以下程序：
  ```
  {root-directory}/platforms/android` 
  ```

其中`root-directory`为该demo项目在本地的根目录。



## Step 2: 嵌入web端代码

1. 将web源码放入项目中。

   将需嵌入的web源代码，放在 `{root-directory}/webapp/{module-name}` 目录下。根据模块名命名文件夹，例如：`envhybrid-demo` 中的 `/webapp/demo`。


   >注意：为了确保插件能够正常使用，必须在H5模块中各个页面的html文件中导入envcontext.js文件和cordova.js文件，示例代码如下：

   ```html
   <html>
   ...
   <body>
   ...
   <script type="text/javascript" src="envcontext.js"></script>
   <script type="text/javascript" src="cordova.js"></script> 
    </body> 
   </html>



2. 将构建完成的资源文件，放入项目中。

   web代码构建完成后，要放在操作系统相对应的目录下(你可以在web端直接用脚本拷贝到对应的目录下)：

   - iOS：`{root-directory}/platforms/ios/webapp/{module-name}`
   
   - Android：`{root-directory}/platforms/android/app/src/main/assets/webapp/{module-name}`

   例如：`envhybrid-demo` 中的 `/platforms/ios/webapp/demo`。

   >注意：一个模块文件包含bundles文件夹和config.json文件，其中bundles内为构建完成后所有的资源文件，config.json为模块的router配置文件，用于页面间跳转，具体的配置方式可参考demo项目。


3. 配置登录后的显示页面。
   
   - iOS：`{root-directory}/platforms/ios/hybrid-demo/Classes/utils/Strs.h`

      ```
      #define HOME_ROUTE @"/demo/index.html"
      ```

   - Android：`{root-directory}/platforms/android/app/src/main/java/com/envision/demo/MyApplication.java`

      ```
      public static String HOME_ROUTE = "/demo/index.html"
      ```

    其中`/demo/index.html`是一个实例，你可以替换成你的登录页路径。


4. 如果曾在该本地终端安装并运行过本项目，卸载旧的安装包并重新运行项目。

5. 调试页面。
  
   在`config.json`中配置`remote_server`，即读取的线上的web地址。

   - iOS：可借助于Safari的开发者模式进行调试
   
   - Android：可借助于Chrome开发者模式进行调试


## Demo功能介绍

以下为该demo功能的详细介绍。

### 集成Application Portal登录功能

使用Application Portal账户体系，从移动端进行登录的操作。Application Portal是EnOS提供的一个应用使能工具，帮助统一应用的交互体验与账号权限体系。有关Application Portal的更多信息，参见

<!--Zoe：跟Jimmy确认链接-->


### 页面跳转

移动混合应用中的页面跳转是通过由一个“内嵌浏览器(WebView)的原生页容器”来加载web页面实现的。所以Web页面之间的跳转有以下两种情况：

- 浏览器(WebView)中的web页面之间的跳转：即普通浏览器中web页面的跳转方式。示例代码如下：

  ```
  window.location.href = 'a.html';
  ```

- 跳转到另一个原生容器所加载的web页面：即打开一个新的原生容器页面，其中包含新的浏览器(WebView)来加载需要跳转的web页面并且会同步相关数据到新的浏览器中。此时需要使用nativeHistory.js。它提供了以这种方式跳转web页面的功能。示例代码如下：
  ```
  import { nativeHistory } from '@enos/envhybrid-utils';
  nativeHistory.push('/demo/a.html');
  ```

如果H5代码需要兼容移动混合应用和桌面Web应用，可参考代码如下：

```
import { device, nativeHistory } from '@enosenvhybrid-utils';
if (device.isMobile) {
   nativeHistory.push('demoa.html');
  } else {
    window.location.href = 'a.html';
  }
```


### 数据持久化
`sharedDataApi.js`提供持久化数据储存的功能，可以把数据持久化保存到原生层，同时也可以从原生层取出数据到H5层。方法如下： 

|     方法         |       描述     |
|------------------|----------------|
| saveShellPersistentData | 以键值方式将数据持久化存储到Native层 |
| getShellPersistentData | 从Native层持久化存储中获取数据键值 |
| removeShellPersistentData | 删除Native层持久化存储中的数据键值 |


### 基础 plugin

该demo包含以下基础 plugin，有关EnvHybrid包含的所有基础 plugin，参见

<!--Zoe：增加链接到文档中心-->

|             plugin 名称         |       描述     |
|---------------------------|----------------|
| mobile-plugin-shellrouter | 提供混合应用的界面跳转，替换和回退的功能 |
| mobile-plugin-shared-data | 提供了多个webview之间共享的内存变量的操作方法，包括存储、获取、删除数据的方法 |
| mobile-plugin-envcontext | 提供了内容注入的功能，方便web端获取如serverAddress等全局变量 |
| mobile-plugin-web-container | 基类webview，提供了加载web页面的容器 |


### 可扩展功能

除上述plugin外，EnvHybrid还提供了支持特定功能的plugin，这些插件会陆续开放使用。

|             plugin           |       描述     |
|---------------------------|----------------|
| mobile-plugin-tabbar | 支持页面是tab的自定义容器 |
| mobile-plugin-language | 为移动端混合框架提供应用内语言切换功能 |
| mobile-plugin-skin | 提供全局切换App样式主题的功能 |
| mobile-plugin-fingerprint | 提供指纹识别功能 |









