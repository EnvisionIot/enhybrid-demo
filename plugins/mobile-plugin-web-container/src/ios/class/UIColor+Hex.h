//
//  UIColor+Hex.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/12.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor*) colorWithCSS: (NSString*) css;
+ (UIColor*) colorWithHex: (NSUInteger) hex;

- (uint)hex;
- (NSString*)hexString;
- (NSString*)cssString;

@end
