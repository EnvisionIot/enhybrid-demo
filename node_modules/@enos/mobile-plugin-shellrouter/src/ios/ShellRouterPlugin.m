#import "ShellRouterPlugin.h"
#import <Cordova/CDVPluginResult.h>
#import <EnvHybrid/Routable.h>
#import <EnvHybrid/EnvHybridConstants.h>

@implementation ShellRouterPlugin
- (void)replaceState:(CDVInvokedUrlCommand*)command
{
    NSString * path = [command argumentAtIndex:0];
    [[Routable sharedRouter] pop:NO];
    [[Routable sharedRouter] open:path];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)pushState:(CDVInvokedUrlCommand*)command
{
    NSString * path = [command argumentAtIndex:0];
    [[Routable sharedRouter] open:path];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)goBack:(CDVInvokedUrlCommand*)command
{
    [[Routable sharedRouter] popViewControllerFromRouterAnimated:YES];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logout:(CDVInvokedUrlCommand*)command
{
    // TODO: logout
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)action:(CDVInvokedUrlCommand*)command
{
    // TODO: action
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
