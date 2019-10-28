//
//  EnvContainerFactory.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/22.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvContainerFactory : NSObject

+ (Class)defaultContainerClass;

+ (Class)containerClassForName:(NSString *)className;

@end
