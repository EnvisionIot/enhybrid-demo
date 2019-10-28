//
//  EnvWebViewController.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/12.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Cordova/CDVViewController.h>
#import "EnvWebViewControllerProtocol.h"

@interface EnvWebViewController : CDVViewController<EnvWebViewControllerProtocol>
@property (nonatomic, strong) NSDictionary *pageParams;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *plistName;


- (void)setAppearance;
- (void)setNavigationBarBg;
- (void)setTitle;
- (void)setNavigationBarLeftButton;
- (void)setNavigationBarRightButton;
- (void)setTabBarItem;
- (void)postEventToJs:(NSString * )type data:(NSDictionary *)data;
@end
