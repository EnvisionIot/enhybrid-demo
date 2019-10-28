

#import <Foundation/Foundation.h>

typedef void (^EnvServiceSuccess) (NSHTTPURLResponse* task, id data);
typedef void (^EnvServiceFailed) (NSError*);

static NSString * currentUserName;
static NSString * currentLoginId;
static NSString * currentSessionId;

@interface BaseService : NSObject
-(void) fetchJSONWithUrl:(NSString *) url header:(NSDictionary *)header successWithBlock:(EnvServiceSuccess) succ
                 failure:(EnvServiceFailed) fail;
    
-(void) postJSONWithUrl:(NSString *) url content:(NSDictionary*) body header:(NSDictionary *)header successWithBlock:(EnvServiceSuccess) succ
                failure:(EnvServiceFailed) fail;
    @end
