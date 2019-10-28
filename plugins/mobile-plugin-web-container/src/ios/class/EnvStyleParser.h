//
//  EnvStyleManager.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/23.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

/* custom style key names */
#define kWebViewBackgroundColor         @"WebViewBackgroundColor"
#define kFontName                       @"FontName"
#define kNavigationBarStyle             @"NavigationBarStyle"
#define kTabBarStyle                    @"TabBarStyle"
#define kBackgroundColors               @"BackgroundColors"
#define kGradient                       @"Gradient"
#define kTitleSize                      @"TitleSize"
#define kTitleColor                     @"TitleColor"
#define kIconSize                       @"IconSize"
#define kIconColor                      @"IconColor"
#define kBackgroundColor                @"BackgroundColor"
#define kItemColor                      @"ItemColor"
#define kItemSelectedColor              @"ItemSelectedColor"


#define WebViewBackgroundColor          @"#FFFFFF"
#define FontName                        @"Helvetica"
#define NaviBackgroundColor             @"#F3F3F3"
#define NaviGradient                    0            // 0: 左右渐变 1：上下渐变
#define NaviTitleSize                   18.0
#define NaviTitleColor                  @"#000000"
#define NaviIconSize                    18.0
#define NaviIconColor                   @"#000000"
#define TabBarBackgroundColor           @"#F3F3F3"
#define TabColor                        @"#A9A9A9"
#define TabSelectedColor                @"#3333FF"
#define TabIconSize                     20.0
#define TabTitleSize                    12.0

@interface EnvStyleParser : NSObject

@property (nonatomic, strong) NSString *plistName;


+ (instancetype)sharedParser;

- (NSString *)fontName;
- (NSString *)webViewBackgroundColor;

- (NSArray<NSString *> *)navigationBarBackgroundColors;
- (NSInteger)navigationBarGradient;
- (CGFloat)navigationBarTitleSize;
- (NSString *)navigationBarTitleColor;
- (CGFloat)navigationBarIconSize;
- (NSString *)navigationBarIconColor;

- (NSString *)tabBarBackgroundColor;
- (NSString *)tabBarItemColor;
- (NSString *)tabBarItemSelectedColor;
- (CGFloat)tabBarItemImageSize;
- (CGFloat)tabBarItemTitleSize;


@end
