//
//  EnvHybridConstants.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/12.
//  Copyright © 2017年 envision. All rights reserved.
//

#ifndef EnvHybridConstants_h
#define EnvHybridConstants_h

#define NATIVE_CALLBACK_EVENT             "native.nativecb"   //char * 类型
#define ROUTE_FILE_NAME                   @"config.json"
#define LIBRARY_PATH                       @"Library/"
#define BUNDLE_SRC_PATH                   @"webapp"
#define BUNDLES_BASE_PATH                 [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Bundles"]
#define BUNDLES_TEMP                       @"bundleTemp"
#define BUNDLES_PATH_NAME                  @"bundles"

#define kUpdateServer           @"EnvUpgradeServer"
#define kAppKey                 @"EnvAppKey"
#define UpdateUrl               @"/applications/v2/check_bundle_version"

#define BUNDLE_ADD              @"add"
#define BUNDLE_UPDATE              @"update"
#define BUNDLE_REMOVE              @"remove"


#define kPreviousVersion        @"kPreviousVersion"
#define kCurrentVersion         @"kCurrentVersion"

// 禁用、启用原生点击事件
#define kEventDisableNativeInteraction              @"kEventDisableNativeInteraction"
#define kEventEnableNativeInteraction               @"kEventEnableNativeInteraction"

#define kEventShowTabBadge                          @"kEventShowTabBadge"
#define kEventHideTabBadge                          @"kEventHideTabBadge"

/* router key names */
#define kExtraParams           @"extraParams"
#define kVersion               @"version"
#define kRemoteServer          @"remote_server"
#define kRoutes                @"routes"
#define kName                  @"name"
#define kURL                   @"url"
#define kREALURL               @"real-url"
#define kShowNavi              @"show_navi"
#define kLeftIcon              @"left_icon"
#define kRightIcon             @"right_icon"
#define kTitle                 @"title"
#define kTabTitle              @"tab_title"
#define kTabIcon               @"tab_icon"
#define kChildren              @"children"
#define kClsContainer          @"cls_container"


/* webview event type */
#define OnNaviAppear           @"onNaviAppear"
#define OnNaviDisappear        @"onNaviDisappear"
#define OnNaviTop              @"onNaviTop"
#define OnNaviLeft             @"onNaviLeft"
#define OnNaviRight            @"onNaviRight"

#endif /* EnvHybridConstants_h */


#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"\n[File:%s]\n" "[Function:%s]\n" "[Line:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif
