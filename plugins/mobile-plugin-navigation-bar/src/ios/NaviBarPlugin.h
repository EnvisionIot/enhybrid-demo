#import <Cordova/CDVPlugin.h>

@interface NaviBarPlugin : CDVPlugin
- (void)setTitle:(CDVInvokedUrlCommand*)command;
- (void)setLeftIcon:(CDVInvokedUrlCommand*)command;
- (void)setRightIcon:(CDVInvokedUrlCommand*)command;
- (void)showLeftBadge:(CDVInvokedUrlCommand *)command;
- (void)showRightBadge:(CDVInvokedUrlCommand *)command;
- (void)hideLeftBadge:(CDVInvokedUrlCommand *)command;
- (void)hideRightBadge:(CDVInvokedUrlCommand *)command;
- (void)enableNaviBar:(CDVInvokedUrlCommand *)command;
- (void)disableNaviBar:(CDVInvokedUrlCommand *)command;
- (void)showNaviBar:(CDVInvokedUrlCommand *)command;
- (void)hideNaviBar:(CDVInvokedUrlCommand *)command;
@end
