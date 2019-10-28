#import <Cordova/CDVPluginResult.h>
#import <EnvHybrid/EnvHybridConstants.h>
#import "UINavigationController+EnvHybrid.h"
#import "NaviBarPlugin.h"

@implementation NaviBarPlugin
- (void)setTitle:(CDVInvokedUrlCommand*)command {
    NSString *title = [command argumentAtIndex:0];

    if(title && self.viewController.navigationController && self.viewController.navigationController.visibleViewController){
        SEL onNaviTopSel = NSSelectorFromString(@"onNaviTop:");
        if([self.viewController respondsToSelector:onNaviTopSel]){
            [self.viewController.navigationController ex_setTitle:NSLocalizedString(title, title) withAction:onNaviTopSel target:self.viewController];
        }else{
            [self.viewController.navigationController ex_setTitle:NSLocalizedString(title, title) withAction:nil target:nil];
        }
    }else {
        [self.viewController.navigationController ex_setTitle:NSLocalizedString(title, title) withAction:nil target:nil];
    }

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setLeftIcon:(CDVInvokedUrlCommand *)command {
    NSString *icon = [command argumentAtIndex:0];
    if(icon && self.viewController.navigationController && self.viewController.navigationController.visibleViewController){
        SEL onNaviLeftSel = NSSelectorFromString(@"onNaviLeft:");
        if([self.viewController respondsToSelector:onNaviLeftSel]){
            [self.viewController.navigationController ex_setNaviBarLeftButton:icon withAction:onNaviLeftSel target:self.viewController];
        }else{
            [self.viewController.navigationController ex_setNaviBarLeftButton:icon withAction:nil target:nil];
        }
    }else {
        [self.viewController.navigationController ex_setNaviBarLeftButton:icon withAction:nil target:nil];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setRightIcon:(CDVInvokedUrlCommand*)command {
    NSString *icon = [command argumentAtIndex:0];
    if(icon && self.viewController.navigationController && self.viewController.navigationController.visibleViewController){
        SEL onNaviRightSel = NSSelectorFromString(@"onNaviRight:");
        if([self.viewController respondsToSelector:onNaviRightSel]){
            [self.viewController.navigationController ex_setNaviBarRightButton:icon withAction:onNaviRightSel target:self.viewController];
        }else{
            [self.viewController.navigationController ex_setNaviBarRightButton:icon withAction:nil target:nil];
        }
    }else {
        [self.viewController.navigationController ex_setNaviBarRightButton:icon withAction:nil target:nil];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showLeftBadge:(CDVInvokedUrlCommand *)command
{
    NSString *num = [[command argumentAtIndex:0] description];
    if(num && self.viewController.navigationController && self.viewController.navigationController.visibleViewController) {
        if(num && ![num isEqualToString:@"0"]) {
            [self.viewController.navigationController ex_showBadgeNum:num inPosition:0];
        }else {
            [self.viewController.navigationController ex_showBadgeInPosition:0];
        }
    }else {
        [self.viewController.navigationController ex_showBadgeInPosition:0];

    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)hideLeftBadge:(CDVInvokedUrlCommand *)command
{
    if(self.viewController.navigationController && self.viewController.navigationController.visibleViewController) {
        [self.viewController.navigationController ex_hideBadgeInPosition:0];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showRightBadge:(CDVInvokedUrlCommand *)command{
    NSString *num = [[command argumentAtIndex:0] description];
    if(num && self.viewController.navigationController && self.viewController.navigationController.visibleViewController) {
        if(num && ![num isEqualToString:@"0"]) {
            [self.viewController.navigationController ex_showBadgeNum:num inPosition:1];
        }else {
            [self.viewController.navigationController ex_showBadgeInPosition:1];
        }
    }else {
        [self.viewController.navigationController ex_showBadgeInPosition:1];

    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)hideRightBadge:(CDVInvokedUrlCommand *)command
{
    if(self.viewController.navigationController && self.viewController.navigationController.visibleViewController) {
        [self.viewController.navigationController ex_hideBadgeInPosition:1];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)disableNaviBar:(CDVInvokedUrlCommand *)command {
    UIWindow * currentWindow =[[[UIApplication sharedApplication] windows] objectAtIndex:0];
    CGRect webRect = self.webView.bounds;
    CGRect position =[self.webView convertRect:webRect toView:currentWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventDisableNativeInteraction object:NSStringFromCGRect(position)];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)enableNaviBar:(CDVInvokedUrlCommand *)command {
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventEnableNativeInteraction object:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showNaviBar:(CDVInvokedUrlCommand *)command {
    [self.viewController.navigationController setNavigationBarHidden:NO];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)hideNaviBar:(CDVInvokedUrlCommand *)command {
    [self.viewController.navigationController setNavigationBarHidden:YES];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
