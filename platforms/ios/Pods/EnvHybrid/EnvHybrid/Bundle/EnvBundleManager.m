//
//  BundleManager.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/27.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "EnvBundleManager.h"
#import "EnvHybridConstants.h"
#import "EnvVersionUtils.h"
#import "EnvRouter.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"

// 标识是否所有的bundle都更新成功
static BOOL update_success = YES;
static BOOL iscopyToTemp = YES;

@implementation EnvBundleManager

+ (void)copyFromResources:(void (^)(BOOL))complete {
    NSString *webappPath = [[NSBundle mainBundle] pathForResource:BUNDLE_SRC_PATH ofType:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bundleBasePath = BUNDLES_BASE_PATH;
    NSError *error = nil;
    
    if([fileManager fileExistsAtPath:bundleBasePath]) {
        [fileManager removeItemAtPath:bundleBasePath error:&error];
        if(error) {
            DLog(@"Copy Resources error: %@", error);
            complete(NO);
            return;
        }
    }
    
    BOOL isFinished = [fileManager copyItemAtPath:webappPath toPath:bundleBasePath error: &error];
    if(isFinished && !error) {
        complete(YES);
    }else {
        DLog(@"Copy Resources error: %@", error);
        complete(NO);
    }
    
}

+ (BOOL)isFirstLaunchOrNativeUpdate {
    NSString *pkgVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion];
    if(!currentVersion || (pkgVersion && [pkgVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) ) {
        return YES;
    }
    return NO;
    
}

+ (void)checkUpdate:(void (^)(BOOL success))complete  pkgUpdateCallback:(void (^)(NSDictionary *response))pkgUpdateCallback {
    NSString *endPoint = [[[NSBundle mainBundle] infoDictionary] objectForKey:kUpdateServer];
    NSString *appKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:kAppKey];
    if(!endPoint || [endPoint isEqualToString:@""] || !appKey || [appKey isEqualToString:@""]) {
        DLog(@"Skip checking update");
        [self rollbackFromVersion];
        complete(YES);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", [endPoint stringByStandardizingPath], UpdateUrl];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[EnvVersionUtils currentVersion] forKey:@"version"];
    [params setObject:@"2" forKey:@"platform"];
    [params setObject:appKey forKey:@"appkey"];
    
    // temp method GET
    [EnvBundleManager requestDataWithMethod:@"POST" url:url params:params success:^(id response) {
        if([response isKindOfClass:[NSDictionary class]]) {
            NSString *code = [[response objectForKey:@"code"] description];   // 兼容code 为整型的情景
            NSString *latestVersion = [response objectForKey:@"latest_version"];
            NSArray *bundles = [response objectForKey:@"bundles"];
            if(!code) {
                complete(NO);
                DLog(@"Check update error: The data structure misses 'code' field!");
            }else if ([code isEqualToString: @"20001"] || [code isEqualToString:@"40003"] ) {//无更新或无此版本
                complete(YES);
            }else if ([code isEqualToString:@"20002"]) {//大版本升级
                if(pkgUpdateCallback) {
                    pkgUpdateCallback(response);
                } else {
                    complete(YES);
                }
            } else if([code isEqualToString:@"20003"] && latestVersion && bundles && bundles.count > 0){//热更新
                [EnvBundleManager copyOldBundlesToTempBundles:^(BOOL success) {
                    if (success) {
                        [EnvBundleManager downloadBundles:bundles withVersion:latestVersion complete:complete];
                    }else {
                        return;
                    }
                }];
            }
        } else {
            DLog(@"%@", response);
            complete(NO);
        }
    } fail:^(NSError *error) {
        DLog(@"Check update error: %@", error);
        complete(NO);
    }];
    
}
+ (void)copyOldBundlesToTempBundles:(void (^)(BOOL))complete {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *bundleTempPath = [documentPath stringByAppendingPathComponent:BUNDLES_TEMP];
    NSString *bundleBasePath = BUNDLES_BASE_PATH;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    NSError *error;
    if([fileManager fileExistsAtPath:bundleBasePath isDirectory:&isDirectory]) {
        if ([fileManager fileExistsAtPath:bundleTempPath]) {
            [fileManager removeItemAtPath:bundleTempPath error:&error];
            if (error) {
                DLog(@"Copy Resources error: %@", error);
                complete(NO);
                return;
            }
        }
        BOOL isfinished =  [fileManager copyItemAtPath:bundleBasePath toPath:bundleTempPath error:&error];
        if (isfinished && !error) {
            complete(YES);
        }else {
            iscopyToTemp = NO;
            complete(NO);
            DLog(@"faile to copy bundle to document %@", error);
        }
    }
}

+ (void)downloadBundles:(NSArray *)bundles withVersion:(NSString *)version complete:(void (^)(BOOL success))complete {
    dispatch_queue_t myQueue = dispatch_queue_create("com.envisioncn.envhybrid", DISPATCH_QUEUE_SERIAL);
    NSString *bundleBasePath = BUNDLES_BASE_PATH;
    NSString *libraryPath = [NSHomeDirectory() stringByAppendingPathComponent:LIBRARY_PATH];
    
    for(int i = 0; i < bundles.count; i++) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *bundle = bundles[i];
        NSString *type = [bundle objectForKey:@"type"];
        
        dispatch_async(myQueue, ^{
            /* 当遇到下载或解析失败的bundle时，取消此次后续的模块更新 */
            if(!update_success) {
                return;
            }
            if (![type isEqualToString:BUNDLE_REMOVE]) {
                NSURLSessionDownloadTask *downloadTask = [EnvBundleManager downloadTask:bundle version:version toPath:libraryPath dispatch_semaphore:semaphore];
                [downloadTask resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }else {//删除对应的bundle
                NSError *error;
                NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundleBasePath error:&error];
                for (NSString *name in files) {
                    if ([name isEqualToString:[bundle objectForKey:@"name"]]) {
                        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", bundleBasePath, name] error:&error];
                        if (!error) {
                            update_success = true;
                        }
                    }
                }
            }
        });
    }
    
    dispatch_async(myQueue, ^{
        if(update_success) {
            [EnvVersionUtils setCurrentVersion:version];
            NSArray *bundleArr = [[EnvRouter sharedRouter] parseBundlesFromRoutesFile:BUNDLES_BASE_PATH];
            [[EnvRouter sharedRouter] mapUrlToControllerWithBundles:bundleArr];
            // 确保升级完成后的回调在UI线程中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(YES);
            });
            
        }else {
            [EnvBundleManager rollBackFromTemp];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(NO);
            });
            //重置标志位
            update_success = YES;
        }
    });
}
+ (void)rollBackFromTemp {
    NSError *error;
    NSString *bundlesPath = BUNDLES_BASE_PATH;
    NSArray *bundleTempPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *bundleTempPath = [[bundleTempPaths firstObject] stringByAppendingPathComponent:@"/bundleTemp"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bundlesPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:bundlesPath error:&error];
    }
    
    [[NSFileManager defaultManager] copyItemAtPath:bundleTempPath toPath:bundlesPath error:&error];
    [self rollbackFromVersion];
    
    
    
}
+ (NSURLSessionDownloadTask *)downloadTask:(NSDictionary *)bundle version:(NSString *)version toPath:(NSString *)path
                        dispatch_semaphore:(dispatch_semaphore_t)semaphore {
    NSString *downloadUrl = [bundle objectForKey:@"url"];
    NSString *name = [bundle objectForKey:@"name"];
    
    AFURLSessionManager *manager =[[AFURLSessionManager alloc] init];
    NSURL *url = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                      
                                                                      NSURL *bundleDirUrl = [[NSURL fileURLWithPath:path]
                                                                                             URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", name]];
                                                                      return bundleDirUrl;
                                                                  }
                                                            completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                
                                                                if(error) {
                                                                    DLog(@"Download bundles failed %@", error);
                                                                    update_success = NO;
                                                                    dispatch_semaphore_signal(semaphore);
                                                                }else {
                                                                    [SSZipArchive unzipFileAtPath:[filePath.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]
                                                                                    toDestination:[NSString stringWithFormat:@"%@/%@", path, name]
                                                                                  progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                                                                                      
                                                                                  } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
                                                                                      if(error) {
                                                                                          DLog(@"Unzip bundle failed: %@", error);
                                                                                          update_success = NO;
                                                                                      } else {
                                                                                          [EnvBundleManager addOrUpdateBundle:bundle withVersion:version];
                                                                                      }
                                                                                      // 删除zip文件
                                                                                      NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                                      [fileManager removeItemAtURL:filePath error:nil];
                                                                                      
                                                                                      dispatch_semaphore_signal(semaphore);
                                                                                  }
                                                                     ];
                                                                }
                                                            }];
    
    return downloadTask;
}

+ (void)addOrUpdateBundle:(NSDictionary *)bundle withVersion:(NSString *)version {
    NSError *error;
    NSString *bundleName = [bundle objectForKey:kName];
    NSString *oldBundlePath = BUNDLES_BASE_PATH;
    NSString *newBundlePath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:LIBRARY_PATH], bundleName];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:oldBundlePath error:&error];
    
    if ([[bundle objectForKey:@"type"] isEqualToString:BUNDLE_UPDATE]) {//替换原来的模块
        for (NSString *name in files) {
            if ([name isEqualToString:bundleName]) {
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", oldBundlePath, bundleName] error:&error];
                NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:newBundlePath error:&error];
                NSString *unZipName = [files lastObject];
                if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@", newBundlePath, unZipName,ROUTE_FILE_NAME ]]) {
                    [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/%@", newBundlePath, unZipName] toPath:[NSString stringWithFormat:@"%@/%@", oldBundlePath, bundleName] error:&error];
                    [[NSFileManager defaultManager] removeItemAtPath:newBundlePath error:&error];
                    if (error) {
                        update_success = NO;
                    }
                }else {
                    [[NSFileManager defaultManager] removeItemAtPath:newBundlePath error:&error];
                    update_success = NO;
                    [self rollBackFromTemp];
                }
                
            }
        }
        
    }else{
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:newBundlePath error:&error];
        NSString *unZipName = [files lastObject];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@", newBundlePath, unZipName,ROUTE_FILE_NAME]]) {
            [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/%@", newBundlePath, unZipName] toPath:[NSString stringWithFormat:@"%@/%@", oldBundlePath, bundleName] error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:newBundlePath error:&error];
            if (error) {
                update_success = NO;
            }
        }else {
            [[NSFileManager defaultManager] removeItemAtPath:newBundlePath error:&error];
            update_success = NO;
            [self rollBackFromTemp];
        }
        
        
    }
}

+ (void)rollbackFromVersion {
    [[EnvRouter sharedRouter] rollbackRoutes];
}

+ (void)requestDataWithMethod:(NSString *)method
                          url:(NSString *)url
                       params:(NSMutableDictionary *)params
                      success:(void (^)(id response))successCallback
                         fail:(void (^)(NSError *error))errorCallback {
    
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma afn2.x
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
//        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//        manager.requestSerializer.timeoutInterval = 20;
//        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//        if ([[method uppercaseString] isEqualToString:@"GET"]) {
//            [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                successCallback(responseObject);
//            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                errorCallback(error);
//            }];
//        }else {
//            [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                successCallback(responseObject);
//            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                errorCallback(error);
//            }];
//        }
#pragma afn3.x
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        if ([[method uppercaseString] isEqualToString:@"GET"]) {
            [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successCallback(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                errorCallback(error);
            }];
        }else if([[method uppercaseString] isEqualToString:@"POST"]) {
            [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successCallback(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                errorCallback(error);
            }];
        }

    });
}

@end
