//
//  EnvVersionUtils.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/28.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "EnvVersionUtils.h"
#import "EnvHybridConstants.h"

@implementation EnvVersionUtils

+ (NSString *)currentVersion {
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion];
    if(!currentVersion) {
        currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString" ];
    }
    return currentVersion;
}

+ (void)setCurrentVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kCurrentVersion];
}

@end
