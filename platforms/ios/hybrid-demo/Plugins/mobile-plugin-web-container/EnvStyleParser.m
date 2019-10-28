//
//  EnvStyleParser.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/23.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "EnvStyleParser.h"

@interface EnvStyleParser()

@property (nonatomic, strong) NSDictionary *customStyle;

@end

@implementation EnvStyleParser

+ (instancetype)sharedParser {
    static EnvStyleParser *_sharedParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedParser = [[EnvStyleParser alloc] init];
    });
    return _sharedParser;
}

//- (instancetype)init {
//    self = [super init];
//    if(self) {
//        self.customStyle = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self getStylePlist] ofType:@"plist"]];
//    }
//    return self;
//}
- (NSDictionary *)customStyle{
    if (self.plistName) {
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.plistName ofType:@"plist"]];
    }else{
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"plist"]];
    }
}

- (NSString *)fontName {
    if(self.customStyle) {
        NSString *fontName = [self.customStyle objectForKey:kFontName];
        if(fontName) {
            return fontName;
        }
    }
    return FontName;
}

- (NSString *)webViewBackgroundColor {
    if(self.customStyle) {
        NSString *webViewbgColor = [self.customStyle objectForKey:kWebViewBackgroundColor];
        if(webViewbgColor) {
            return webViewbgColor;
        }
    }
    return WebViewBackgroundColor;
}

- (NSArray<NSString *> *)navigationBarBackgroundColors {
    NSArray<NSString *> *colors = [self styleFor:kBackgroundColors ofComponent:kNavigationBarStyle];
    if(colors) {
        return colors;
    }
    return [NSArray arrayWithObject:NaviBackgroundColor];
}

- (NSInteger)navigationBarGradient {
    NSNumber *gradient = [self styleFor:kGradient ofComponent:kNavigationBarStyle];
    if(gradient) {
        return gradient.integerValue;
    }
    return NaviGradient;
}

- (CGFloat)navigationBarTitleSize {
    NSNumber *size = [self styleFor:kTitleSize ofComponent:kNavigationBarStyle];
    if(size) {
        return size.floatValue;
    }
    return NaviTitleSize;
}

- (NSString *)navigationBarTitleColor {
    NSString *color = [self styleFor:kTitleColor ofComponent:kNavigationBarStyle];
    if(color) {
        return color;
    }
    return NaviTitleColor;
}

- (CGFloat)navigationBarIconSize {
    NSNumber *size = [self styleFor:kIconSize ofComponent:kNavigationBarStyle];
    if(size) {
        return size.floatValue;
    }
    return NaviIconSize;
}

- (NSString *)navigationBarIconColor {
    NSString *color = [self styleFor:kIconColor ofComponent:kNavigationBarStyle];
    if(color) {
        return color;
    }
    return NaviIconColor;
}

- (NSString *)tabBarBackgroundColor {
    NSString *bgColor = [self styleFor:kBackgroundColor ofComponent:kTabBarStyle];
    if(bgColor) {
        return bgColor;
    }
    return TabBarBackgroundColor;
}

- (NSString *)tabBarItemColor {
    NSString *itemColor = [self styleFor:kItemColor ofComponent:kTabBarStyle];
    if(itemColor) {
        return itemColor;
    }
    return TabColor;
}

- (NSString *)tabBarItemSelectedColor {
    NSString *selectedColor = [self styleFor:kItemSelectedColor ofComponent:kTabBarStyle];
    if(selectedColor) {
        return selectedColor;
    }
    return TabSelectedColor;
}

- (CGFloat)tabBarItemImageSize {
    NSNumber *iconSize = [self styleFor:kIconSize ofComponent:kTabBarStyle];
    if(iconSize){
        return iconSize.floatValue;
    }
    return TabIconSize;
}

- (CGFloat)tabBarItemTitleSize {
    NSNumber *titleSize = [self styleFor:kTitleSize ofComponent:kTabBarStyle];
    if(titleSize){
        return titleSize.floatValue;
    }
    return TabTitleSize;
}

- (id)styleFor:(NSString *)item ofComponent:(NSString *)component{
    if(self.customStyle && [self.customStyle objectForKey:component]) {
        return [[self.customStyle objectForKey:component] objectForKey:item];
    }
    return nil;
}

@end
