//
//  EnvIconFont.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/20.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvIconFont : NSObject

+ (void)registerFontWithURL:(NSURL *)url;
+ (instancetype)sharedIconFont;
- (NSString *)iconFontName;
@end
