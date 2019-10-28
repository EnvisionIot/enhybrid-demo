//
//  EnvContainerFactory.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/22.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "EnvContainerFactory.h"

@interface EnvContainerFactory ()

@end

@implementation EnvContainerFactory

+ (Class)defaultContainerClass {
    NSString *defaultContainer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"EnvDefaultContainer"];
    if(defaultContainer && NSClassFromString(defaultContainer)) {
        return NSClassFromString(defaultContainer);
    }
    return nil;
}

+ (Class)containerClassForName:(NSString *)className {
    Class viewControllerClass = NSClassFromString(className);
    if(viewControllerClass) {
        return viewControllerClass;
    } else {
        return nil;
    }
}

@end
