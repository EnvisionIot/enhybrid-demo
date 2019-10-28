//
//  EnvVersionUtils.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/28.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvVersionUtils : NSObject

+ (NSString *)currentVersion;
+ (void)setCurrentVersion:(NSString *)version;

@end
