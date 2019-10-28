//
//  EnvRouterProtocol.h
//  EnvHybrid
//
//  Created by xuchao on 17/4/5.
//
//

#import <Foundation/Foundation.h>

@protocol EnvRouterProtocol <NSObject>

- (void)open:(NSString *)url;
- (void)setNavigationController:(UINavigationController *)nav;
- (void)map:(NSString *)format toController:(Class)controllerClass;

@end
