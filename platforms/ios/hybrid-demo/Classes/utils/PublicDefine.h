

#import <Foundation/Foundation.h>
#import "Strs.h"


@interface PublicDefine : NSObject

@property(nonatomic,strong) NSString *currentHost;
@property(nonatomic,strong) NSString *currentAuth;
@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, strong) NSString *orgSelect;
@property (nonatomic, strong) NSString *menuSelect;



+(PublicDefine *)sharedInstance;

- (NSString *)getCurrentHost;//服务器

- (NSString *)getCurrentEnv;

- (void)setCurrentEnv:(EnvironmentType)env;

- (NSString *)getCurrentAuthValue;//认证方式

- (NSString *)getCurrentAuthType;

- (void)setCurrentAuthType:(AuthType)env;

-(NSString *)getAuthorization;

@end
