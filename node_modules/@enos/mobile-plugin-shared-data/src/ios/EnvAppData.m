//
//  EnvAppData.m
//  Mydemo
//
//  Created by zhenghuiyu on 2019/4/19.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "EnvAppData.h"
#import "NSString+EnvHybrid.h"
#import "NSDictionary+EnvHybrid.h"
#import <EnvHybrid/EnvHybridConstants.h>


#define ROOT_OBJECT @"this.global"

@interface EnvAppData()
// 通过JavaScriptCore来存储应用共享数据
@property(nonatomic, strong) JSContext* jsContext;
@property(nonatomic, strong) NSDictionary * initialState;
@end

@implementation EnvAppData

+ (instancetype)sharedData {
    static EnvAppData *_sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedData = [[EnvAppData alloc] init];
        _sharedData.isInitialized = NO;
    });
    return _sharedData;
}

- (instancetype)init
{
    self = [super init];
    _jsContext = [JSContext new];
    __weak __typeof__(self)  weakSelf = self;
    //初始化根元素，所有的字段都挂载在这个根元素下
    [_jsContext evaluateScript:[NSString stringWithFormat:@"%@ = {}", ROOT_OBJECT]];
    [_jsContext setExceptionHandler:^(JSContext * context, JSValue * value) {
        [weakSelf jsExceptionHandler:context value:value];
    }];
    return self;
}

-(void)initializeWith:(id) rootObject{
    @synchronized(_jsContext) {
        self.initialState = (NSDictionary*) rootObject;
        NSString * stringifiedValue = [(NSDictionary *)rootObject convertToUTF8String];
        // 将rootObject合并到当前的 rootObject中
        NSString* jsExpression = [NSString stringWithFormat:@"%@ = Object.assign({}, JSON.parse('%@'), %@); ", ROOT_OBJECT, stringifiedValue, ROOT_OBJECT];
        [self.jsContext evaluateScript:jsExpression];
        self.isInitialized = YES;
    }
}

-(void)jsExceptionHandler:(JSContext *) context value:(JSValue *)value
{
    DLog(@"@@@@@ uncaught exception: %@", value);
}

-(NSString*) escapeSepcialCharacters:(NSString*) origionalString
{
    NSString* resultString = origionalString;
    if([origionalString rangeOfString:@"\\\\"].location != NSNotFound){
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\\\\\\\"];
    }
    if([origionalString rangeOfString:@"\\n"].location != NSNotFound){
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\\\n"];
    }
    if([origionalString rangeOfString:@"\\r"].location != NSNotFound){
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\\r" withString:@"\\\\r"];
    }
    if([origionalString rangeOfString:@"\\t"].location != NSNotFound){
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\\t" withString:@"\\\\t"];
    }
    if([origionalString rangeOfString:@"\\b"].location != NSNotFound){
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\\b" withString:@"\\\\b"];
    }
    if([origionalString rangeOfString:@"\\f"].location != NSNotFound){
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\\f" withString:@"\\\\f"];
    }
    
    return resultString;
}

-(void)setItem:(id) value forKey:(NSString* ) key
{
    @synchronized(_jsContext) {
        NSString *firstPath = [self keyToFirstPath:key];
        NSString *firstPathExpression =  [NSString stringWithFormat:@"%@%@%@%@", firstPath, @" = ", firstPath, @" || {};"];
        NSString * jsPath = [self keyToJsonPath:key];
        DLog(@"@@@ setItem %@", jsPath);
        NSString * jsExpression = nil;
        if(value && [value isKindOfClass:[NSString class]]){
            jsExpression = [NSString stringWithFormat:@"%@ = '%@'", jsPath, value];
        }else if(value && [value isKindOfClass:[NSDictionary class]]){
            NSString * stringifiedValue = [(NSDictionary *)value convertToUTF8String];
            stringifiedValue = [self escapeSepcialCharacters:stringifiedValue];
            if(stringifiedValue){
                jsExpression = [NSString stringWithFormat:@"%@ = JSON.parse('%@')", jsPath, stringifiedValue];
            }
        }else if(value && [value isKindOfClass:[NSArray class]]){
            
            NSError *stringifyError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:0 error:&stringifyError];
            if(!stringifyError){
                NSString *stringifiedValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                stringifiedValue = [self escapeSepcialCharacters:stringifiedValue];
                jsExpression = [NSString stringWithFormat:@"%@ = JSON.parse('%@')", jsPath, stringifiedValue];
            }
        }else if(value && [value isKindOfClass:[NSNumber class]]){
            NSNumber * nValue = value;
            //if (strcmp([nValue objCType], @encode(BOOL)) == 0) {
            if (strcmp([nValue objCType], [[NSNumber numberWithBool:YES] objCType]) == 0) {
                jsExpression = [NSString stringWithFormat:@"%@ = %@", jsPath, nValue.boolValue ? @"true" : @"false"];
            }else if(strcmp([nValue objCType], @encode(int)) == 0){
                jsExpression = [NSString stringWithFormat:@"%@ = %d", jsPath, nValue.intValue];
            }else {
                jsExpression = [NSString stringWithFormat:@"%@ = %f", jsPath, nValue.floatValue];
            }
        }else{
            DLog(@"@@ invalid value type %@" , value);
        }
        
        if(jsExpression){
            [self.jsContext evaluateScript:[NSString stringWithFormat:@"%@%@", firstPathExpression, jsExpression]];
        }
    }
}

-(id)getItem:(NSString* ) key
{
    @synchronized(_jsContext) {
        NSString * jsPath = [self keyToJsonPath:key];
        DLog(@"@@@ getItem %@", jsPath);
        JSValue* value = [self.jsContext evaluateScript:jsPath];
        if(value && [value isNull]){
            return nil;
        }
        else if(value && [value isString]){
            return [value toString];
        }else if(value && [value isObject]){
            id obj = [value toObject];
            if([obj isKindOfClass:[NSDictionary class]]){
                return (NSDictionary *)obj;
            }else if([obj isKindOfClass:[NSArray class]]){
                return (NSArray *) obj;
            }
        }else if(value && [value isNumber]){
            return [value toNumber];
        }else if(value && [value isBoolean]){
            return [NSNumber numberWithBool:[value toBool]];
        }else if(value){
            if([[[UIDevice currentDevice] systemVersion] floatValue] >=9 && [value isArray]){
                return [value toArray];
            }else {
                @try {
                    NSArray * array = [value toObjectOfClass:[NSArray class]];
                    if(array){
                        return array;
                    }
                }
                @catch (NSException *exception) {
                    return nil;
                }
            }
        }
        return nil;
    }
}


-(void)removeItem:(NSString* ) key
{
    @synchronized(_jsContext) {
        __block NSString * parentPath =nil;
        __block BOOL isNum = NO;
        __block int index = -1;
        NSString * jsPath = [self keyToJsonPath:key lastComponentCb:^(NSString *parent, BOOL isNumber, int idx) {
            parentPath = parent;
            isNum = isNumber;
            index = idx;
        }];
        DLog(@"@@@ removeItem %@", jsPath);
        if(!isNum){
            // 如果是删除对象，调用delete方法
            [self.jsContext evaluateScript:[NSString stringWithFormat:@"delete %@", jsPath]];
        }else if([parentPath stringIsValid] && index >= 0){
            // 如果是删除数组元素，对父元素调用 splice方法
            [self.jsContext evaluateScript:[NSString stringWithFormat:@"%@.splice( %d , 1)", parentPath, index]];
        }else{
            DLog(@"@@@@ invalid argument: %@" , key);
        }
    }
}

-(void)resetState
{
    @synchronized(_jsContext) {
        if(self.initialState){
            NSString * stringifiedValue = [self.initialState convertToUTF8String];
            // 将rootObject合并到当前的 rootObject中
            NSString* jsExpression = [NSString stringWithFormat:@"%@ = JSON.parse('%@'); ", ROOT_OBJECT, stringifiedValue];
            [self.jsContext evaluateScript:jsExpression];
        }
    }
}

- (void)savePersistentItem:(NSString *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSString *)getPersistentItem:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)removePersistentItem:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

/**
 *  将model路径转换成json的路径 , eg: /login/codes/0/zh_desc => this.global.login.codes[0].zh_desc
 *  @param key model路径
 *
 *  @return json path
 */
-(NSString* )keyToJsonPath:(NSString * )key
{
    return [self keyToJsonPath:key lastComponentCb:nil];
}

-(NSString *)keyToJsonPath:(NSString * )key lastComponentCb:(void(^)(NSString * parent, BOOL isNumber, int index)) callback
{
    if(key.length <= 0){
        return nil;
    }
    // key对应模型的路径,必须以‘/’开头, 如果不是以‘/’开头，程序默认补齐
    if([key characterAtIndex:0] != '/'){
        key = [@"/" stringByAppendingString:key];
    }
    NSArray * components = [key componentsSeparatedByString:@"/"];
    NSMutableString * result = [[NSMutableString alloc] init];
    for(int i=0; i <components.count; i++){
        if(i == 0){
            [result appendString:ROOT_OBJECT];
        }else{
            NSString * component = components[i];
            if([component stringIsValid]){
                if([component isPureInt]){
                    if(i == components.count -1 && callback!=nil){
                        callback([result mutableCopy], YES, (int)component.integerValue);
                    }
                    [result appendFormat:@"[%d]", component.intValue];
                }else{
                    if(i == components.count -1 && callback!=nil){
                        callback([result mutableCopy], NO, -1);
                    }
                    [result appendFormat:@".%@", component];
                }
            }
        }
    }
    return result;
}
- (NSString *)keyToFirstPath:(NSString *)key {
    if (key == NULL || key.length <= 0) {
        return nil;
    }
    
    if (![key hasPrefix:@"/"]) {
        key = [NSString stringWithFormat:@"/%@", key];
    }
    NSArray *components = [key componentsSeparatedByString:@"/"];
    NSArray *name = [components objectAtIndex:1];
    return [NSString stringWithFormat:@"%@.%@", ROOT_OBJECT, name];
}

-(NSString *)getNamespaceItem:(NSString *)nameSpace key:(NSString *)key {
    NSDictionary* namespaceItem = [[NSUserDefaults standardUserDefaults] objectForKey:nameSpace];
    if(!namespaceItem){
        namespaceItem = [NSDictionary dictionary];
    }
    return [namespaceItem objectForKey:key];
}

- (void)saveNamespaceItem:(NSString *)nameSpace key:(NSString *)key value:(NSString *)value {
    NSDictionary* namespaceItem = [[NSUserDefaults standardUserDefaults] objectForKey:nameSpace];
    NSMutableDictionary *newdic;
    if(!namespaceItem){
        newdic = [NSMutableDictionary dictionary];
    }else{
        newdic= [NSMutableDictionary dictionaryWithDictionary:namespaceItem];
    }
    [newdic setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:newdic] forKey:nameSpace];
}

- (void)removeNamespaceItem:(NSString *)nameSpace key:(NSString *)key {
    NSDictionary* namespaceItem = [[NSUserDefaults standardUserDefaults] objectForKey:nameSpace];
    NSMutableDictionary *newdic;
    if(!namespaceItem){
        newdic = [NSMutableDictionary dictionary];
    }else{
        newdic= [NSMutableDictionary dictionaryWithDictionary:namespaceItem];
    }
    [newdic removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:newdic] forKey:nameSpace];
}

- (void)removeNamespaceAllItem:(NSString *)nameSpace {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:nameSpace];
}

@end
