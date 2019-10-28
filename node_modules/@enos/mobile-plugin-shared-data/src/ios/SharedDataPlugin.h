#import <Cordova/CDVPlugin.h>

@interface SharedDataPlugin : CDVPlugin
- (void)isInitialized:(CDVInvokedUrlCommand*)command;
- (void)initialize:(CDVInvokedUrlCommand*)command;
- (void)setItem:(CDVInvokedUrlCommand*)command;
- (void)getItem:(CDVInvokedUrlCommand*)command;
- (void)removeItem:(CDVInvokedUrlCommand*)command;
- (void)savePersistentItem:(CDVInvokedUrlCommand*)command;
- (void)getPersistentItem:(CDVInvokedUrlCommand*)command;
- (void)removePersistentItem:(CDVInvokedUrlCommand*)command;
- (void)saveNamespaceItem:(CDVInvokedUrlCommand*)command;
- (void)getNamespaceItem:(CDVInvokedUrlCommand*)command;
- (void)removeNamespaceItem:(CDVInvokedUrlCommand*)command;
- (void)removeNamespaceAllItem:(CDVInvokedUrlCommand*)command;
@end