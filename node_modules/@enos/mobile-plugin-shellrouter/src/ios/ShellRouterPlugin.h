#import <Cordova/CDVPlugin.h>

@interface ShellRouterPlugin : CDVPlugin
- (void)replaceState:(CDVInvokedUrlCommand*)command;
- (void)pushState:(CDVInvokedUrlCommand*)command;
- (void)goBack:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)action:(CDVInvokedUrlCommand*)command;
@end