//
//  EnvRouter.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/14.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "EnvRouter.h"
#import "EnvBundleManager.h"
#import "EnvHybridConstants.h"
#import "EnvContainerFactory.h"
#import "EnvVersionUtils.h"
//#import <Routable/Routable.h>
#import "Routable.h"

@interface EnvRouter()

@property (nonatomic, strong) NSMutableDictionary *urlToRoute;
@property (nonatomic, strong) NSString *rootUrl;

@end

@implementation EnvRouter

+ (instancetype)sharedRouter {
    static EnvRouter *_router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [[EnvRouter alloc] init];
    });
    return _router;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _urlToRoute = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public methods

- (void)setRootUrl:(NSString *)rootUrl {
    _rootUrl = rootUrl;
}

- (void)setUpRoutes:(void (^)(BOOL success))complete {
    if([EnvBundleManager isFirstLaunchOrNativeUpdate]) {
        [EnvBundleManager copyFromResources:^(BOOL success) {
            if(success) {
                self.bundleArray = [self parseBundlesFromRoutesFile:BUNDLES_BASE_PATH];
                [self mapUrlToControllerWithBundles:self.bundleArray];
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                [EnvVersionUtils setCurrentVersion:version];
                complete(YES);
            }else {
                complete(NO);
                DLog(@"Failed to copy resources !");
            }
        }];
    }else {
        self.bundleArray = [self parseBundlesFromRoutesFile:BUNDLES_BASE_PATH];
        [self mapUrlToControllerWithBundles:self.bundleArray];
        complete(YES);
    }
}

- (void)mapUrlToController {
    [self mapUrlToControllerWithBundles:self.bundleArray];
}

- (void)rollbackRoutes {
    self.bundleArray = [self parseBundlesFromRoutesFile:BUNDLES_BASE_PATH];
    [self mapUrlToControllerWithBundles:self.bundleArray];
}

- (NSDictionary *)routeForUrl:(NSString *)url {
    return [self.urlToRoute objectForKey:url];
}

- (NSString *)pathForUrl:(NSString *)url withParams:(NSDictionary *)params {
    NSString *path = nil;
    if(!self.rootUrl) {
        self.rootUrl = BUNDLES_BASE_PATH;
    }
    NSDictionary *extraParams = [params objectForKey:kExtraParams];
    
    NSString *concatUrl = [self concatUrl:url withParams:params];
    NSString *bundleName = [extraParams objectForKey:kName];
    //    NSRange range = [concatUrl rangeOfString:@"/index.html"];
    NSRange range = [concatUrl rangeOfString:bundleName];
    //change "/index.html" to "/bundles/index.html"
    //    NSString *bundlePath = [concatUrl stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"/%@/index.html", BUNDLES_PATH_NAME]];
    NSString *bundlePath = [concatUrl stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%@/%@", bundleName, BUNDLES_PATH_NAME]];
    NSString *remoteServer = [extraParams objectForKey:kRemoteServer];
    
    // setRootUrl 设置为私有方法，目前阶段，第一个分支永远不会执行
    if([self.rootUrl rangeOfString:@"http"].location == 0) {
        path = [NSString stringWithFormat:@"%@%@", self.rootUrl, concatUrl];        
    }else if(remoteServer && [remoteServer hasPrefix:@"http"]) {
        path = [NSString stringWithFormat:@"%@%@", remoteServer, concatUrl];
    }else {
        path = [NSString stringWithFormat:@"%@%@", self.rootUrl, bundlePath];
        NSURL *url = [NSURL fileURLWithPath:path];
        // 把路径中的 %23 替换为原始符号 #
        path = [[url absoluteString] stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
        path = [path stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
        
//        NSString *filePath = [url relativePath];
//        NSRange range = [filePath rangeOfString:@"#"];
//        if( range.length ) {
//            filePath  = [filePath substringToIndex:range.location];
//        }
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if(![fileManager fileExistsAtPath:filePath]) {
//            // 使用config中配置的ErrorUrl，注意不能设置为nil，否则cordova内部会重置为index.html
//            path = @"_blank";
//        }
    }
    return path;
}



- (NSMutableArray *)parseBundlesFromRoutesFile:(NSString *)routesFilePath {
    NSMutableArray *bundles = [NSMutableArray new];
    NSError *error;
    NSArray *fileArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:routesFilePath error:&error];
    for (NSString *name in fileArr) {
        NSString *bundlePath = [routesFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", name,ROUTE_FILE_NAME]];
        NSData *data = [NSData dataWithContentsOfFile:bundlePath];
        if(data) {
            NSError *error = nil;
            id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if(!error && [response isKindOfClass:[NSDictionary class]]) {
                [bundles addObject:response];
            }
        }
    }
    return bundles;
}

#pragma mark - private methods


- (void)mapUrlToControllerWithBundles:(NSArray *)bundles {
    [self.urlToRoute removeAllObjects];
    for(NSDictionary *bundle in bundles) {
        NSString *bundleName = [bundle objectForKey:kName];
        NSString *bundleVersion = [bundle objectForKey:kVersion];
        NSString *remoteServer = [bundle objectForKey:kRemoteServer];
        for(NSDictionary *route in [bundle objectForKey:kRoutes]) {
            NSString *url = [route objectForKey:kURL];
            if(!url) {
                continue;
            }
            
            NSMutableDictionary *newRoute = [NSMutableDictionary dictionaryWithDictionary:route];
            NSString *newUrl = [NSString stringWithFormat:@"/%@%@",bundleName, [self normalizeUrl:url]];
            [newRoute setValue:newUrl forKey:kURL];
            [newRoute setValue:bundleName forKey:kName];
            [newRoute setValue:bundleVersion forKey:kVersion];
            if(![newRoute objectForKey:kRemoteServer]) {
                [newRoute setValue:remoteServer forKey:kRemoteServer];
            }
            
            [self.urlToRoute setValue:newRoute forKey:newUrl];
            
            if([newRoute objectForKey:kClsContainer]) {
                Class viewControllerClass = [EnvContainerFactory containerClassForName:[newRoute objectForKey:kClsContainer]];
                if(viewControllerClass) {
                    [[Routable sharedRouter] map:newUrl toController:viewControllerClass withOptions:[UPRouterOptions routerOptionsForDefaultParams:@{kExtraParams: newRoute}]];
                }else {
                    DLog(@"ClsContainer %@ for %@ does not exsit", [newRoute objectForKey:kClsContainer], newUrl);
                }
            }else {
                [[Routable sharedRouter] map:newUrl toController:[EnvContainerFactory defaultContainerClass]
                                 withOptions:[UPRouterOptions routerOptionsForDefaultParams:@{kExtraParams: newRoute}]];
            }
        }
    }
}


/**
 *  标准化URL格式
 *  eg: a/b -> /a/b,  a/b/ -> /a/b
 */
- (NSString *)normalizeUrl:(NSString *)url {
    NSString *normalizeUrl = url;
    if([url rangeOfString:@"/"].location != 0){
        normalizeUrl = [NSString stringWithFormat:@"/%@", url];
    }
    return [normalizeUrl stringByStandardizingPath];
}


/**
 *  解析并匹配url和参数
 *
 *  @param urlPatten url 模式 eg. "/main/:id"
 *  @param params    参数 eg. {id: 10, extraParams: {...}}
 *
 *  @return 组合成的完整url eg. "/main/10"
 */
-(NSString* )concatUrl:(NSString *) urlPatten withParams:(NSDictionary *) params {
    NSString *url = urlPatten;
    for(NSString *key in params.allKeys){
        if(![key isEqualToString:kExtraParams]){
            url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@":%@", key] withString: [params objectForKey:key]];
        }
    }
    return url;
}

- (NSString *)routesFilePath {
    NSString *bundleBasePath = BUNDLES_BASE_PATH;
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion];
    NSString *routeBasePath = [bundleBasePath stringByAppendingPathComponent:version];
    return [NSString stringWithFormat:@"%@/%@", routeBasePath, ROUTE_FILE_NAME];
}


#pragma mark - EnvRouterProtocol

- (void)open:(NSString *)url {
    [[Routable sharedRouter] open:url];
}

- (void)setNavigationController:(UINavigationController *)nav {
    [[Routable sharedRouter] setNavigationController:nav];
}

- (void)map:(NSString *)format toController:(Class)controllerClass {
    [[Routable sharedRouter] map:format toController:controllerClass];
}

@end
