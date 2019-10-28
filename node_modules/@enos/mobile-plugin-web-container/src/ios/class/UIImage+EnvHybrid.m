//
//  UIImage+EnvHybrid.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/15.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "UIImage+EnvHybrid.h"
#import "EnvIconFont.h"

@implementation UIImage (EnvHybrid)

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithIconFont:(NSString *)character imageSize:(CGSize)size fontSize:(int)fontSize
                         color:(UIColor *)color {
    NSString * fontName = [[EnvIconFont sharedIconFont] iconFontName];
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSAssert(font != nil, @"Font not found!");
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.text = character;
    if(color){
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    return retImage;
}

@end
