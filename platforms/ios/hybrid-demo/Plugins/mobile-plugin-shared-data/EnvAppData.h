//
//  EnvAppData.h
//  Mydemo
//
//  Created by zhenghuiyu on 2019/4/19.
//

#import <Foundation/Foundation.h>

@interface EnvAppData : NSObject
// 是否被redux.js的initial data初始化过
@property(nonatomic) BOOL isInitialized;

+ (instancetype)sharedData;
- (void)initializeWith:(id)rootObject;
- (void)setItem:(id)value forKey:(NSString* ) key;
- (id)getItem:(NSString *) key;
- (void)removeItem:(NSString *) key;
- (void)resetState;

- (void)savePersistentItem:(NSString *)value forKey:(NSString *)key;
- (NSString *)getPersistentItem:(NSString *)key;
- (void)removePersistentItem:(NSString *)key;

- (void)saveNamespaceItem:(NSString *)nameSpace key:(NSString *)key value:(NSString *)value;
- (NSString *)getNamespaceItem:(NSString *)nameSpace key:(NSString *)key;
- (void)removeNamespaceItem:(NSString *)nameSpace key:(NSString *)key;
- (void)removeNamespaceAllItem:(NSString *)nameSpace;
@end
