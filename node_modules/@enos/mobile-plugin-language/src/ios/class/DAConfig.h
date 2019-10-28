//
//  DAConfig.h
//  kusos
//
//  Created by zhenghuiyu on 2018/9/6.
//
//
#import <Foundation/Foundation.h>

#define CONFIG_LANGUAGE_EN                @"en-US"
#define CONFIG_LANGUAGE_ZH                @"zh-Hans"

NS_ASSUME_NONNULL_BEGIN

/**
 设置
 */
@interface DAConfig : NSObject
/**
 用户自定义使用的语言，当传nil时，等同于resetSystemLanguage
 */
@property (nonatomic, strong) NSString *userLanguage;
/**
 重置系统语言
 */
+ (void)resetSystemLanguage;
+ (NSString *)getUserLanguage;
+ (void)setUserLanguage:(NSString *)userLanguage;
+ (void)setLanguageCookie:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
