

#import <UIKit/UIKit.h>

@interface UINavigationController (EnvHybrid)

- (void)ex_clearHistory;
- (void)ex_setTitle:(NSString* )title withAction:(SEL) action target:(id)target;
- (void)ex_setNaviBarLeftButton:(NSString *)leftIcon withAction:(SEL)action target:(id)target;
- (void)ex_setNaviBarRightButton:(NSString *)rightIcon withAction:(SEL)action target:(id) target;
- (void)ex_setBackgroundGradientColors:(NSArray<UIColor *> *)colors direction:(NSInteger) direction;
- (void)ex_setBackgroundColor:(UIColor *) color;

- (void)skin_setTitle:(NSString* )title withAction:(SEL) action target:(id)target;
- (void)skin_setNaviBarLeftButton:(NSString *)leftIcon withAction:(SEL)action target:(id)target;
- (void)skin_setNaviBarRightButton:(NSString *)rightIcon withAction:(SEL)action target:(id) target;
- (void)skin_setBackgroundColor;

- (void)ex_hideNaviLeftButton;
- (void)ex_hideNaviRightButton;
- (void)ex_setSegmentsButton:(NSArray *)array withAction:(SEL) action target:(id)target selectedSegmentIndex: (NSInteger) index;

- (void)ex_showBadgeInPosition:(int)position;
- (void)ex_showBadgeNum:(NSString *)num inPosition:(int)position;
- (void)ex_hideBadgeInPosition:(int)position;
@end
