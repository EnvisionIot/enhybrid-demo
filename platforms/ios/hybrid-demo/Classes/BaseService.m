

#import "BaseService.h"

#import "Reachability.h"
#import <EnvHybrid/NSString+EnvHybrid.h>
#import "AFNetworking.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "Persistent.h"
#import "Strs.h"
#import "EnvRouter.h"
#import "EnvAppData.h"


#define kEnvServiceErrorDomain @"kEnvServiceErrorDomain"
#define TIMEOUT 20
#define cSuccessResponse                             @"200"
#define cErrorInvalidResponse                        100
#define cErrorResponseFlagFalse                      101
#define cErrorLoginInvalidResponse                   102
#define sErrorInvalidResponse                        @"ErrorInvalidResponse"
#define sErrorResponseFlagFalse                      @"ErrorResponseFlagFalse"
#define sErrorLoginInvalidResponse                   @"ErrorLoginInvalidResponse"

@implementation BaseService
-(void) fetchJSONWithUrl:(NSString *) url header:(NSDictionary *)header successWithBlock:(EnvServiceSuccess) succ
                 failure:(EnvServiceFailed) fail
    {
        return [self requestWithUrl:url isPost:NO content:nil header: header successWithBlock:succ failure:fail];
    }
    
-(void) postJSONWithUrl:(NSString *) url content:(NSDictionary*) body header:(NSDictionary *)header successWithBlock:(EnvServiceSuccess) succ
                failure:(EnvServiceFailed) fail
    {
        return [self requestWithUrl:url isPost:YES content:body header:header successWithBlock:succ failure:fail];
    }
    
-(void) requestWithUrl:(NSString *) url isPost:(BOOL) isPost content:(NSDictionary*) body
      header:(NSDictionary *)header
      successWithBlock:(EnvServiceSuccess) succ
               failure:(EnvServiceFailed) fail
    {
        if(![self isConnectionAvailable]){
            NSError * error = [NSError errorWithDomain:kEnvServiceErrorDomain
                                                  code: -1
                                              userInfo:[NSDictionary dictionaryWithObject:
                                                        NSLocalizedString(@"tip_network_error", @"network not available")
                                                                                   forKey:NSLocalizedDescriptionKey]];
            fail(error);
        }else if(![url stringIsValid] || (isPost && !body)){
            NSError * error = [NSError errorWithDomain:kEnvServiceErrorDomain
                                                  code: -2
                                              userInfo:[NSDictionary dictionaryWithObject:
                                                        NSLocalizedString(@"invalid_arguments", @"invalid arguments")
                                                                                   forKey:NSLocalizedDescriptionKey]];
            fail(error);
        }else{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.securityPolicy.validatesDomainName = NO;
            manager.securityPolicy.allowInvalidCertificates = NO;

            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            if (header) {
                NSString *str = header[AUTHORIZATION];
                [manager.requestSerializer setValue:str forHTTPHeaderField:AUTHORIZATION];
            }
            manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", @"text/javascript", nil];
            
            
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = TIMEOUT;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
           

            NSString *domain = [[NSURL URLWithString:url] host];
            
            //设置语言Cookie
            NSHTTPCookie *localCookie = [self getLanguageCookieWithDomain: domain expiresDate:[NSDate dateWithTimeIntervalSinceNow: +24*60*60]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:localCookie];
            
            if(!isPost){
                [manager GET:url parameters:@{} progress:nil success:^(NSURLSessionDataTask* task, id  responseObject) {
                    
                    if(responseObject == nil){
                        fail([NSError errorWithDomain:domain code:cErrorInvalidResponse userInfo:nil]);
                    }
                    NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
                    if(code != nil && !([code isEqualToString:cSuccessResponse])){
                        fail([NSError errorWithDomain:domain code:cErrorResponseFlagFalse userInfo:@{@"NSLocalizedDesc": [responseObject objectForKey:@"message"]}]);
                    }else{
                        succ((NSHTTPURLResponse *)task.response,responseObject);
                    }
                } failure:^(NSURLSessionDataTask* operation, NSError* error) {
                    fail(error);
                }];
            }else{
                [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask* task, id  responseObject) {
                    if(responseObject == nil){
                        fail([NSError errorWithDomain:domain code:cErrorInvalidResponse userInfo:nil]);
                    }
                    NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
                    
                    if(code != nil && !([code isEqualToString:cSuccessResponse])){
                        if ([code isEqualToString:@"401"]) {
                            [[EnvRouter sharedRouter] open:LOGIN_ROUTE];
                        }
                        fail([NSError errorWithDomain:domain code:cErrorResponseFlagFalse userInfo:@{@"NSLocalizedDesc": [responseObject objectForKey:@"message"]}]);
                    }else{
                        succ((NSHTTPURLResponse *)task.response, responseObject);
                    }
                } failure:^(NSURLSessionDataTask* operation, NSError* error) {
                    fail(error);
                }];
            }
        }
    }
    
-(BOOL) isConnectionAvailable
    {
        BOOL isExistenceNetwork = YES;
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([reach currentReachabilityStatus]) {
            case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"notReachable");
            break;
            case ReachableViaWiFi:
            isExistenceNetwork = YES;
            NSLog(@"WIFI");
            break;
            case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSLog(@"3G");
            break;
        }
        return isExistenceNetwork;
    }


/**
 设置语言
 
 @param domainStr domainStr 域
 */
-(NSHTTPCookie *) getLanguageCookieWithDomain: (NSString *) domainStr expiresDate: (NSDate *) expiresDate
{
    //语言
    NSDictionary *propertiesLoc = [[NSMutableDictionary alloc] init];
    NSString *localStr = [self language];
    [propertiesLoc setValue:localStr forKey:NSHTTPCookieValue];
    [propertiesLoc setValue:@"locale" forKey:NSHTTPCookieName];
    [propertiesLoc setValue: domainStr forKey:NSHTTPCookieDomain];
    [propertiesLoc setValue: expiresDate forKey:NSHTTPCookieExpires];
    [propertiesLoc setValue:@"/" forKey:NSHTTPCookiePath];
    [[EnvAppData sharedData] savePersistentItem:localStr forKey:[NSString stringWithFormat:@"%@locale", USERDEFAULT_PRIFIX]];
    NSHTTPCookie *cookieLoc = [[NSHTTPCookie alloc] initWithProperties:propertiesLoc];
    return cookieLoc;
}

/**
 设置设备唯一标识
 @param domainStr domainStr 域
 */
-(NSHTTPCookie *) getUUIDCookieWithDomain: (NSString *) domainStr expiresDate : (NSDate *) expiresDate
{
    
    
    NSDictionary *propertiesLoc = [[NSMutableDictionary alloc] init];
    [propertiesLoc setValue:DEVICEUUID forKey:NSHTTPCookieName];
    [propertiesLoc setValue: domainStr forKey:NSHTTPCookieDomain];
    [propertiesLoc setValue:@"/" forKey:NSHTTPCookiePath];
    [propertiesLoc setValue: expiresDate forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:propertiesLoc];
    return cookie;
}

- (NSString *)language{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *result;
    if ([currentLanguage containsString:@"zh"]) {
         result = LANGUAGE_ZH_TO_WEB;
    } else if ([currentLanguage containsString:@"en"]) {
         result = LANGUAGE_EN_TO_WEB;
    }
    return result;
}
    
    @end

