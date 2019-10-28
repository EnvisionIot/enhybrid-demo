#import "ShellRouterPlugin.h"
#import <Cordova/CDVPluginResult.h>
#import <EnvHybrid/Routable.h>
#import <EnvHybrid/EnvHybridConstants.h>
#import "Persistent.h"
#import "AppDelegate.h"
#import "PublicDefine.h"

@implementation ShellRouterPlugin
- (void)replaceState:(CDVInvokedUrlCommand*)command
{
    NSString * path = [command argumentAtIndex:0];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [[Routable sharedRouter] pop:NO];
    @try {
         [[Routable sharedRouter] open:path];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)pushState:(CDVInvokedUrlCommand*)command
{
    NSString * path = [command argumentAtIndex:0];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    @try {
        [[Routable sharedRouter] open:path];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)goBack:(CDVInvokedUrlCommand*)command
{
     CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    @try {
        [[Routable sharedRouter] popViewControllerFromRouterAnimated:YES];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)logout:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    // TODO: logout
    // 删除持久化用户信息
    @try {
        [self clearCookies];
        [self clearAllUserDefaultsData];
        [self clearWebviews];
        [PublicDefine sharedInstance].menus = @[];
        [PublicDefine sharedInstance].orgSelect = nil;
        [PublicDefine sharedInstance].menuSelect = nil;
        [Persistent removeFile:LOGIN_INFO];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)action:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    @try {
        // TODO: action
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

- (void)clearAllUserDefaultsData{
    NSUserDefaults*userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary*dic=[userDefaults dictionaryRepresentation];
    for(NSString *key in dic) {
        if ([key containsString:USERDEFAULT_PRIFIX]) {
            [userDefaults removeObjectForKey:key];
        }
    }
    [userDefaults synchronize];
}
-(void) clearCookies
{
    //    清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSArray *oldCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in oldCookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie: cookie];
    }
}
-(void) clearWebviews {
    [(AppDelegate *)[UIApplication sharedApplication].delegate showWindowHome];
}

@end
