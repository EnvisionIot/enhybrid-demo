//
//  NSDictionary+EnvHybrid.h
//  Mydemo
//
//  Created by zhenghuiyu on 2019/4/19.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (EnvHybrid)

- (id)objectForKeyIgnoreCase:(NSString*)key;

/**
 * 将JSON字典序列化成字符串
 */
- (NSString*) convertToUTF8String;

@end
