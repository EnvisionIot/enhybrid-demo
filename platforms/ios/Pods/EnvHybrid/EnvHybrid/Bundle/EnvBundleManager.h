//
//  BundleManager.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/27.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvBundleManager : NSObject

+ (void)copyFromResources:(void (^)(BOOL))complete;
+ (BOOL)isFirstLaunchOrNativeUpdate;
+ (void)checkUpdate:(void (^)(BOOL))complete pkgUpdateCallback:(void (^)(NSDictionary *))pkgUpdateCallback;

@end
