#import "EnvWindow.h"
#import <EnvHybrid/EnvHybridConstants.h>

@interface EnvWindow()
@property (nonatomic) CGRect currentViewPort;
@property (nonatomic) BOOL disableInteraction;
@end

@implementation EnvWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _disableInteraction = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableNativeInteraction:) name:kEventDisableNativeInteraction object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableNativeInteraction) name:kEventEnableNativeInteraction object:nil];
    }
    return self;
}

// 当WebView中显示模式对话框时，禁止native 导航
-(void) disableNativeInteraction:(NSNotification *) notification
{
    if([notification.object isKindOfClass:[NSString class]]){
        CGRect rect = CGRectFromString(notification.object);
        if(rect.size.height >0 && rect.size.width >0){
            self.disableInteraction = YES;
            self.currentViewPort = rect;
        }
    }
}

// 取消对native导航的限制
-(void)enableNativeInteraction
{
    self.disableInteraction = NO;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(self.disableInteraction){
        return CGRectContainsPoint(self.currentViewPort, point);
    }
    return isInside;
}

@end
