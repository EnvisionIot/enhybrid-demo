/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */
#import "AppDelegate.h"
#import <EnvHybrid/EnvRouter.h>
#import "LoginViewController.h"
#import "PublicDefine.h"
#import "EnvWindow.h"
#import "EnvAppData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    UINavigationController *nv = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    nv.view.backgroundColor = [UIColor whiteColor];
    return YES;
}

//配置要打开页面路由
- (NSString*)openRoute
{
    return @"/login";
}

//配置自定义viewcontroller的router
- (void)setNativeRoutes
{
    [super setNativeRoutes];
    [[EnvRouter sharedRouter] map:@"/login" toController:[LoginViewController class]];
}

//配置原生navigationcontroller样式
-(void)setNav:(UINavigationController *)nav{
    
}

-(void)showWindowHome {
    UINavigationController *nv = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *vcs = nv.childViewControllers;
    for (UIViewController *vc in vcs) {
        [vc removeFromParentViewController];
    };
    [self setNav:nv];
    [[EnvRouter sharedRouter] setNavigationController:nv];
    [self setNativeRoutes];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EnvRouter sharedRouter] setUpRoutes:^(BOOL success) {
            if(success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[EnvRouter sharedRouter] open:@"/login"];
                });
            } else {
                NSLog(@"@@@解析路由失败，程序终止！");
            }
        }];
    });
}
@end
