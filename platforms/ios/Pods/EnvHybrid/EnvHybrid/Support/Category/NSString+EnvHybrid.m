//
//  NSString+EnvHybrid.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/13.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "NSString+EnvHybrid.h"

@implementation NSString (EnvHybrid)

-(BOOL)stringIsValid
{
    BOOL isVaild = false;
    if ([self isEqual:[NSNull null]]) {
        return false;
    }
    if (self != nil && ![self isEqualToString:@""] && ![self isEqualToString:@"(null)"]) {
        isVaild = YES;
    }
    
    return isVaild;
}

//判断是否为整形：
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

@end
