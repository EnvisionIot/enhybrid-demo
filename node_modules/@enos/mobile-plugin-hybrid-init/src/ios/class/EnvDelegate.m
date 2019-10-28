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

#import "EnvDelegate.h"
#import "EnvRouter.h"
#import "EnvWindow.h"

// IMPORT START
// IMPORT END

@implementation EnvDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.window = [[EnvWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav setNavigationBarHidden:YES];
    [self setNav:nav];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    [[EnvRouter sharedRouter] setNavigationController:nav];
    [self setNativeRoutes];
    
    // 当设置了RootUrl时，APP会加载服务器端的页面，而不是本地的页面，主要用于远程调试
    // [[EnvRouter sharedRouter] setRootUrl:@"http://172.16.53.121:3000"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EnvRouter sharedRouter] setUpRoutes:^(BOOL success) {
            if(success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"home= route-%@", [self openRoute]);
                    [[EnvRouter sharedRouter] open:[self openRoute]];
                });
            } else {
                NSLog(@"@@@解析路由失败，程序终止！");
            }
        }];
    });

    // APPLICATION START
    // APPLICATION END
    return YES;
}

//配置自定义viewcontroller的router
- (NSString*)openRoute
{
    return @"要打开页面路由";
}

//配置自定义viewcontroller的router
- (void)setNativeRoutes
{
    
}
//配置原生navigationcontroller样式
-(void)setNav:(UINavigationController *)nav{
    
}

@end
