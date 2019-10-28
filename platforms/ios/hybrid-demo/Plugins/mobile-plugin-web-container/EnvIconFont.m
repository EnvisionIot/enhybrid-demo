//
//  EnvIconFont.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/20.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "EnvIconFont.h"

@implementation EnvIconFont

+ (void)registerFontWithURL:(NSURL *)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    [UIFont familyNames];
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}

+ (instancetype)sharedIconFont {
    static EnvIconFont *_sharedIcon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedIcon = [[EnvIconFont alloc] init];
    });
    return _sharedIcon;
}

- (NSString *)iconFontName {
    NSString * fontName = nil;
    NSArray * appFonts = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIAppFonts"];
    if(appFonts && [appFonts count] > 0) {
        fontName = [appFonts[0] stringByDeletingPathExtension];
    }
    //  没有配置UIAppFonts不需要使APP中断
    // if(fontName == nil || fontName.length == 0 ){
    //     @throw [NSException exceptionWithName:@"AppFontsNotFoundException"
    //                                   reason:@"info.plist 没有设置 UIAppFonts"
    //                                 userInfo:nil];
    // }
    return fontName;
}
@end
