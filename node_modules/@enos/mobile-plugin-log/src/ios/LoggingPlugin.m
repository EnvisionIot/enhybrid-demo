//
//  LoggingPlugin.m
//  Challenger
//
//  Created by yuxin.zhang on 16/3/21.
//
//

#import "LoggingPlugin.h"

@implementation LoggingPlugin

- (void)log:(CDVInvokedUrlCommand*)command
{
    NSString* logStr = [command argumentAtIndex:0];
    EnvLog(@"%@", logStr);
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
