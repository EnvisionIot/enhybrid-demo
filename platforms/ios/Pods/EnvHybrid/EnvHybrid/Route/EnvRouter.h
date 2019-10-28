//
//  EnvRouter.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/14.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnvRouterProtocol.h"

@interface EnvRouter : NSObject<EnvRouterProtocol>

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *bundleArray;

+ (instancetype)sharedRouter;
- (void)setUpRoutes:(void (^)(BOOL success))complete;
- (void)rollbackRoutes;
- (void)mapUrlToController;
- (NSString *)pathForUrl:(NSString *)url withParams:(NSDictionary *)params;
- (NSDictionary *)routeForUrl:(NSString *)url;
- (void)mapUrlToControllerWithBundles:(NSArray *)bundles;
- (NSMutableArray *)parseBundlesFromRoutesFile:(NSString *)routesFilePath;

@end
