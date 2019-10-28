
//处理登录请求
#import "BaseService.h"

typedef void (^LoginServiceSuccess) (void);
typedef void (^LoginServiceFailed) (NSError*);

@interface LoginService : BaseService
+(instancetype)sharedService;

-(void)performLogin:(NSString *) loginId
           password:(NSString *) password
               succ:(LoginServiceSuccess) succ
            failure: (LoginServiceFailed) fail;
-(void)performLogout;

- (void)autoLogin:(NSDictionary *)dictionary succ:(LoginServiceSuccess) succ
          failure: (LoginServiceFailed) fail;
@end
