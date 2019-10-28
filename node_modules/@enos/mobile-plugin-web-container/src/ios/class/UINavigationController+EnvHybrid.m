//
//  UINavigationController.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/20.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "UINavigationController+EnvHybrid.h"
#import "EnvHybridConstants.h"
#import "UIColor+Hex.h"
#import "UIImage+EnvHybrid.h"
#import "EnvIconFont.h"
#import "EnvStyleParser.h"
#import "EnvIconFont.h"
#ifdef TXSAKURA_SKIN
#import "TXSakuraKit.h"
#endif

@implementation UINavigationController (EnvHybrid)

/**
 *  清空navigation history stack，只保留当前viewcontroller
 */
- (void)ex_clearHistory
{
    if(self.viewControllers.count > 1){
        NSMutableArray * viewControllersToRemove = [[NSMutableArray alloc] init];
        for(int i=0; i<self.viewControllers.count -1; i++){
            UIViewController * viewController = self.viewControllers[i];
            if(viewController && [viewController isKindOfClass:[UIViewController class]]){
                [viewControllersToRemove addObject:viewController];
            }
        }
        for(UIViewController * viewController in viewControllersToRemove){
            [viewController removeFromParentViewController];
        }
    }
}

- (void)ex_setSegmentsButton:(NSArray *)array withAction:(SEL) action target:(id)target  selectedSegmentIndex: (NSInteger) index
{
    UISegmentedControl *segMent=[[UISegmentedControl alloc] initWithFrame:CGRectMake(70.0f, 5.0f, 180.0f, 34.0f)];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [segMent insertSegmentWithTitle: NSLocalizedString([dic objectForKey:@"title"], @"") atIndex:i animated:NO];
    }
    segMent.momentary = NO;
    segMent.multipleTouchEnabled=NO;
    segMent.selectedSegmentIndex = index;
    [segMent addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    self.visibleViewController.navigationItem.titleView = segMent;
}

- (void)ex_setTitle:(NSString* )title withAction:(SEL) action target:(id)target
{
    UIControl * titleBg =[[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width -150, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:titleBg.frame];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor =[UIColor clearColor];
    
    NSString *fontName = [[EnvStyleParser sharedParser] fontName];
    NSString *titleColorHex = [[EnvStyleParser sharedParser] navigationBarTitleColor];
    CGFloat titleSize = [[EnvStyleParser sharedParser] navigationBarTitleSize];
    
    label.textColor = [UIColor colorWithCSS:titleColorHex];
    label.font = [UIFont fontWithName:fontName size:titleSize];
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.4;
    [titleBg addSubview:label];
    
    self.visibleViewController.navigationItem.titleView = titleBg;
    if ([title isEqualToString:@""] || title == nil) {
//        [titleBg addTarget:target action:nil forControlEvents:UIControlEventTouchUpInside];
    }else {
        [titleBg addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)ex_setBackgroundGradientColors:(NSArray<UIColor *> *)colors direction:(NSInteger) direction
{
    NSMutableArray * cgColors = [[NSMutableArray alloc] init];
    for(int i = 0; i < [colors count]; i++) {
        [cgColors addObject:(id)colors[i].CGColor];
    }
    CGSize size = CGSizeMake(self.navigationBar.bounds.size.width, self.navigationBar.bounds.size.height + 20);
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.colors = cgColors;
    /* 从上到下渐变 */
    if(direction == 1) {
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
    }
    /* 从左到右渐变，默认行为 */
    else {
        layer.startPoint = CGPointMake(0.0, 0.5);
        layer.endPoint = CGPointMake(1.0, 0.5);
    }
    
    UIGraphicsBeginImageContext(size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)ex_setBackgroundColor:(UIColor *) color
{
    UIImage *image = [UIImage imageWithColor:color];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)ex_setNaviBarLeftButton:(NSString *)text withAction:(SEL)action target:(id) target
{
    UIBarButtonItem *barButtonItem = [self naviBarButtonItem:text withAction:action target:target];
    UIBarButtonItem *spacerButtonItem = [self naviSpacerButtonItem];
    self.visibleViewController.navigationItem.leftBarButtonItems = @[spacerButtonItem, barButtonItem];
}

- (void)ex_setNaviBarRightButton:(NSString *)text withAction:(SEL)action target:(id) target
{
    UIBarButtonItem *barButtonItem = [self naviBarButtonItem:text withAction:action target:target];
    UIBarButtonItem *spacerButtonItem = [self naviSpacerButtonItem];
    self.visibleViewController.navigationItem.rightBarButtonItems = @[spacerButtonItem, barButtonItem];
}

- (UIBarButtonItem *)naviBarButtonItem:(NSString *)iconfont withAction:(SEL)action target:(id) target {
    UIView *barButtonView = [[UIView alloc]init];
    barButtonView.frame =CGRectMake(0, 0, 50, 50);
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 50, 50);
    UILabel *label = [[UILabel alloc] init];
    
    NSString *iconColor = [[EnvStyleParser sharedParser] navigationBarIconColor];
    CGFloat iconSize = [[EnvStyleParser sharedParser] navigationBarIconSize];

    NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
    UIFont *font = [UIFont fontWithName:iconFontName size:iconSize];
    [label setFont:font];
    // 判断是icon font
    if(iconfont.length ==1 && [iconfont characterAtIndex:0] > 4096){
        [label setText: iconfont];
    }else{
        [label setText: iconfont];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 50, 50);
    [label setTextColor:[UIColor colorWithCSS:iconColor]];
    [barButtonView addSubview:label];
    [barButtonView addSubview:btn];
    
    //[btn setShowsTouchWhenHighlighted:YES];
    //[btn setBackgroundImage:[UIImage imageWithColor: [UIColor redColor]] forState:UIControlStateHighlighted];
    if ([iconfont isEqualToString:@""] || iconfont == nil) {
//        [btn addTarget:target action:nil forControlEvents:UIControlEventTouchUpInside];
    }else {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    return barBtn;
    
}

- (UIBarButtonItem *)naviSpacerButtonItem {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;
    return spacer;
}

- (UIBarButtonItem *)badgeButtonItem:(int)num {
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888;
    badgeView.layer.cornerRadius = 7;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    badgeView.frame = CGRectMake(0, 0, 14, 14);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    label.text = [[NSString alloc] initWithFormat:@"%d", num];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:7.0];
    
    [badgeView addSubview:label];
    
    UIBarButtonItem *badgeItem = [[UIBarButtonItem alloc] initWithCustomView:badgeView];
    return badgeItem;
}

- (void)ex_hideNaviLeftButton
{
    self.visibleViewController.navigationItem.leftBarButtonItem = nil;
    self.visibleViewController.navigationItem.leftBarButtonItems = nil;
//    UIControl * backBg = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [backBg setBackgroundColor:[UIColor clearColor]];
//    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:backBg];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spacer.width = -10;
//    self.visibleViewController.navigationItem.leftBarButtonItems = @[spacer, barBtn];
}
- (void)ex_hideNaviRightButton
{
    self.visibleViewController.navigationItem.rightBarButtonItem = nil;
    self.visibleViewController.navigationItem.rightBarButtonItems = nil;
//    UIView *view = [[UIView alloc]init];
//    view.frame =CGRectMake(0, 0, 50, 50);
//    [view setBackgroundColor:[UIColor clearColor]];
//    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:view];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spacer.width = -10;
//    self.visibleViewController.navigationItem.rightBarButtonItems = @[spacer, barBtn];
}

// position: 0 左侧， 1 右侧
- (void)ex_showBadgeInPosition:(int)position {
    
    UIView *barView = [self viewForBarButtonItemInPosition:position];

    if(barView) {
        //新建小红点
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(35, 5, 8, 8)];
        badgeView.tag = 888;
        badgeView.layer.cornerRadius = 4;//圆形
        badgeView.backgroundColor = [UIColor redColor];//颜色：红色
        
        [barView addSubview: badgeView];
    }
}

- (void)ex_showBadgeNum:(NSString *)num inPosition:(int)position {
    
    UIView *barView = [self viewForBarButtonItemInPosition:position];
    
    if(barView) {
        //新建小红点
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(35, 5, 14, 14)];
        badgeView.tag = 888;
        badgeView.layer.cornerRadius = 7;//圆形
        badgeView.backgroundColor = [UIColor redColor];//颜色：红色
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        label.text = num;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:7.0];
        
        [badgeView addSubview:label];
        [barView addSubview: badgeView];
    }
}

- (void)ex_hideBadgeInPosition:(int)position {
    UIView *barView = [self viewForBarButtonItemInPosition:position];
    if(barView) {
        for (UIView *subView in barView.subviews) {
            if (subView.tag == 888) {
                [subView removeFromSuperview];
            }
        }
    }
}

- (UIView *)viewForBarButtonItemInPosition:(int)position {
    UIView *barView = nil;
    if(position == 0) {
        UIBarButtonItem *barItem = self.visibleViewController.navigationItem.leftBarButtonItems[1];
        barView = [barItem customView];
    }else if(position == 1) {
        UIBarButtonItem *barItem = self.visibleViewController.navigationItem.rightBarButtonItems[1];
        barView = [barItem customView];
    }else {
        DLog(@"Wrong badge position !");
    }
    return barView;
}

#ifdef TXSAKURA_SKIN
- (void)skin_setNaviBarLeftButton:(NSString *)text withAction:(SEL)action target:(id) target
{
    UIBarButtonItem *barButtonItem = [self skin_naviBarButtonItem:text withAction:action target:target];
    UIBarButtonItem *spacerButtonItem = [self naviSpacerButtonItem];
    self.visibleViewController.navigationItem.leftBarButtonItems = @[spacerButtonItem, barButtonItem];
}

- (void)skin_setNaviBarRightButton:(NSString *)text withAction:(SEL)action target:(id) target
{
    UIBarButtonItem *barButtonItem = [self skin_naviBarButtonItem:text withAction:action target:target];
    UIBarButtonItem *spacerButtonItem = [self naviSpacerButtonItem];
    self.visibleViewController.navigationItem.rightBarButtonItems = @[spacerButtonItem, barButtonItem];
}

- (void)skin_setTitle:(NSString* )title withAction:(SEL) action target:(id)target
{
    UIControl * titleBg =[[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width -190, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:titleBg.frame];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor =[UIColor clearColor];
    
    NSString *fontName = [[EnvStyleParser sharedParser] fontName];
    CGFloat titleSize = [[EnvStyleParser sharedParser] navigationBarTitleSize];
    
    label.sakura.textColor(@"EnvHybrid.NavigationBarStyle.TitleColor");
    label.font = [UIFont fontWithName:fontName size:titleSize];
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.4;
    [titleBg addSubview:label];
    
    self.visibleViewController.navigationItem.titleView = titleBg;
    if ([title isEqualToString:@""] || title == nil) {
        //        [titleBg addTarget:target action:nil forControlEvents:UIControlEventTouchUpInside];
    }else {
        [titleBg addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)skin_setBackgroundColor
{
    self.navigationBar.sakura.barTintColor(@"EnvHybrid.NavigationBarStyle.BackgroundColor");
}

- (UIBarButtonItem *)skin_naviBarButtonItem:(NSString *)iconfont withAction:(SEL)action target:(id) target {
    UIView *barButtonView = [[UIView alloc]init];
    barButtonView.frame =CGRectMake(0, 0, 70, 50);
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 70, 50);
    UILabel *label = [[UILabel alloc] init];
    
    CGFloat iconSize = [[EnvStyleParser sharedParser] navigationBarIconSize];
    
    NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
    UIFont *font = [UIFont fontWithName:iconFontName size:iconSize];
    [label setFont:font];
    // 判断是icon font
    if(iconfont.length ==1 && [iconfont characterAtIndex:0] > 4096){
        NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
        UIFont *font = [UIFont fontWithName:iconFontName size:iconSize];
        [label setText: iconfont];
        [label setFont: font];
    }else{
        NSString *fontName = [[EnvStyleParser sharedParser] fontName];
        UIFont *font = [UIFont fontWithName:fontName size:iconSize];
        [label setText: NSLocalizedString(iconfont, nil)];
        [label setFont: font];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 70, 50);
    label.sakura.textColor(@"EnvHybrid.NavigationBarStyle.IconColor");
    [barButtonView addSubview:label];
    [barButtonView addSubview:btn];
    
    //[btn setShowsTouchWhenHighlighted:YES];
    //[btn setBackgroundImage:[UIImage imageWithColor: [UIColor redColor]] forState:UIControlStateHighlighted];
    if ([iconfont isEqualToString:@""] || iconfont == nil) {
        //        [btn addTarget:target action:nil forControlEvents:UIControlEventTouchUpInside];
    }else {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    return barBtn;
    
}
#endif

@end
