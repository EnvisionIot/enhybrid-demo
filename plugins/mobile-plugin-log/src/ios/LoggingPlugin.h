//
//  LoggingPlugin.h
//  Challenger
//
//  Created by yuxin.zhang on 16/3/21.
//
//

#import <Cordova/CDVPlugin.h>

@interface LoggingPlugin : CDVPlugin

#define EnvLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

/**
 *  打印方法
 *
 *  @param command js传递参数
 */
- (void)log:(CDVInvokedUrlCommand*)command;
@end
