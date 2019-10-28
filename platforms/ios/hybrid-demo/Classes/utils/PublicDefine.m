

#import "PublicDefine.h"
#import "Strs.h"
#import "Persistent.h"

@implementation PublicDefine

@synthesize currentHost;
@synthesize currentAuth;

static PublicDefine *instance = nil;

+(PublicDefine *)sharedInstance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(id)init
{
    self = [super init];
    return self;
}


-(NSString *)getCurrentHost
{
    if(!self.currentHost) {
        NSString *currentEnv = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_ENV];
        self.currentHost = [self getCurrentHostByEnv:[currentEnv intValue]];
    }
    return self.currentHost;
}

-(void)setCurrentEnv:(EnvironmentType)env
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",env] forKey:CURRENT_ENV];
    self.currentHost = [self getCurrentHostByEnv:env];
}

-(NSString *)getCurrentEnv
{
    NSString *currentEnv = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_ENV];
    return currentEnv;
}

-(NSString *)getCurrentHostByEnv:(EnvironmentType)env {
    NSString *host = @"";
    switch (env) {
            case CN:
        {
            host = CN_SERVER;
            break;
        }
        default:
            break;
    }
    return host;
}

-(NSString *)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

-(NSString *) getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

-(NSString *)getAuthorization {
    NSDictionary *loginInfo = [Persistent readFromFile:LOGIN_INFO];
    NSString *accessToken = [loginInfo objectForKey:ACCESSTOKEN];
    return [NSString stringWithFormat:@"Bearer %@", accessToken];
}




@end
