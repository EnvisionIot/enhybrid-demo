//
//  HomeViewController.m
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/15.
//

#import "HomeViewController.h"
#import "EnvWebViewController.h"
#import "UINavigationController+EnvHybrid.h"
#import "EnvRouter.h"
#import "EnvHybridConstants.h"
#import "EnvStyleParser.h"
#import "UIColor+Hex.h"
#import "EnvIconFont.h"
#import "CoverView.h"
#import "Persistent.h"
#import "PublicDefine.h"
#import "AppDelegate.h"
#import "EnvAppData.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSDictionary *pageParams;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) NSArray *menuList;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"home--viewWillDisappear");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isFirstDownload = [self checkFirstDownLoad];
    if (isFirstDownload) {
        [self showGuidePage];
//        [self getMenus];
    }
    NSString * bgColor = [[EnvStyleParser sharedParser] webViewBackgroundColor];
    if(bgColor){
        self.view.backgroundColor  = [UIColor colorWithCSS:bgColor];
        self.view.opaque= NO;
    }
}

- (void)setNavigationTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, 44)];
    label.text = NSLocalizedString(title, nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = (UIView *)label;
}

-(BOOL)checkFirstDownLoad{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    if (isFirst) {
        return false;
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isFirst"];
        return true;
    }
    
}
-(void)showGuidePage{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.cover.backgroundColor = [UIColor colorWithRed:17/255.0 green:22/255.0 blue:36/255.0 alpha:0.64];
    CoverView *cover = [[CoverView alloc] initWithFrame:frame];
  
    [cover.knowBtn addTarget:self action:@selector(hideCover) forControlEvents:UIControlEventTouchUpInside];
    [self.cover addSubview:cover];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
    //判断当前机型是否是iPhone X
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    if(height >= 44){
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(8,40,44, 44) cornerRadius:0] bezierPathByReversingPath]];
    }else{
          [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(8,20,44, 44) cornerRadius:0] bezierPathByReversingPath]];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineDashPattern = @[@4, @4];
    shapeLayer.lineWidth = 2.f;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.cover.layer setMask:shapeLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCover)];
    [self.cover addGestureRecognizer:tap];

}

-(void)hideCover{
    [self.cover removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
