//
//  UIImage+EnvHybrid.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/15.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EnvHybrid)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithIconFont:(NSString *)character imageSize:(CGSize)size fontSize:(int) fontSize
                         color:(UIColor *) color;

@end
