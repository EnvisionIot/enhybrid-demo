#import "SharedDataPlugin.h"
#import <Cordova/CDVPluginResult.h>
#import "EnvAppData.h"

@implementation SharedDataPlugin
- (void)isInitialized:(CDVInvokedUrlCommand*)command
{
    if([EnvAppData sharedData].isInitialized){
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }else{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)initialize:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        if(![EnvAppData sharedData].isInitialized){
            id value = [command argumentAtIndex:0];
            [[EnvAppData sharedData]initializeWith:value];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }else{
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

- (void)setItem:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString * key = [command argumentAtIndex:0];
        id value = [command argumentAtIndex:1];
        
        [[EnvAppData sharedData] setItem:value forKey: key];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getItem:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString * key = [command argumentAtIndex:0];
        id value = [[EnvAppData sharedData] getItem:key];
        CDVPluginResult* pluginResult = nil;
        if(value && [value isKindOfClass:[NSString class]]){
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
        }else if(value && [value isKindOfClass:[NSDictionary class]]){
            pluginResult =[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:value];
        }else if(value && [value isKindOfClass:[NSArray class]]){
            pluginResult =[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:value];
        }else if(value && [value isKindOfClass:[NSNumber class]]){
            NSNumber * nValue = value;
            if (strcmp([nValue objCType], @encode(BOOL)) == 0) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:nValue.boolValue];
            }else if(strcmp([nValue objCType], @encode(int)) == 0){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:nValue.intValue];
            }else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:nValue.floatValue];
            }
        }else{
            NSLog(@"@@ not found key %@" , key);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)removeItem:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString * key = [command argumentAtIndex:0];
        [[EnvAppData sharedData] removeItem:key];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)savePersistentItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString * key = [command argumentAtIndex:0];
        NSString * value = [command argumentAtIndex:1];
        
        [[EnvAppData sharedData] savePersistentItem:value forKey: key];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getPersistentItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString *key = [command argumentAtIndex:0];
        NSString *value = [[EnvAppData sharedData] getPersistentItem:key];
        CDVPluginResult* pluginResult = nil;
        if(value) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
        } else {
            NSLog(@"@@ not found key %@", key);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)removePersistentItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString * key = [command argumentAtIndex:0];
        [[EnvAppData sharedData] removePersistentItem:key];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)saveNamespaceItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString * namespace = [command argumentAtIndex:0];
        NSString * key = [command argumentAtIndex:1];
        NSString * value = [command argumentAtIndex:2];
        
        [[EnvAppData sharedData] saveNamespaceItem:namespace key: key value: value];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getNamespaceItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString *namespace = [command argumentAtIndex:0];
        NSString *key = [command argumentAtIndex:1];
        NSString *value = [[EnvAppData sharedData] getNamespaceItem:namespace key:key];
        CDVPluginResult* pluginResult = nil;
        if(value) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
        } else {
            NSLog(@"@@ not found key %@", key);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)removeNamespaceItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString * nameSpace = [command argumentAtIndex:0];
        NSString * key = [command argumentAtIndex:1];
        [[EnvAppData sharedData] removeNamespaceItem:nameSpace key:key];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)removeNamespaceAllItem:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString * nameSpace = [command argumentAtIndex:0];
        [[EnvAppData sharedData] removeNamespaceAllItem:nameSpace];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
