//
//  EnvWebViewController.m
//  EnvHybrid
//

#import "EnvWebViewController.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "NSDictionary+EnvHybrid.h"
#import "WildcardGestureRecognizer.h"
#import "UIColor+Hex.h"
#import "EnvRouter.h"
#import "UIImage+EnvHybrid.h"
#import "UINavigationController+EnvHybrid.h"
#import "EnvStyleParser.h"
#import "EnvContainerFactory.h"
#ifdef TXSAKURA_SKIN
#import "TXSakuraKit.h"
#endif
// IMPORT START
// IMPORT END

@interface EnvWebViewController ()
@property (nonatomic, strong) WildcardGestureRecognizer *gesture;
@end

@implementation EnvWebViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 导航栏的设置放在viewWillAppear中，保证每次切换tab时，导航栏也会被重新设置
    EnvStyleParser *parser = [EnvStyleParser sharedParser];
    parser.plistName = self.plistName;
    [self setAppearance];
    [self postEventToJs:@"viewOnStart" data:@{}];
}
//视图已经出现
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 不能在viewWillAppear中调用。保证在beginLogPageView调用前，前一个页面的endLogPageView一定被调用
    // 发送appear的消息给当前webview
    [self postEventToJs:@"viewOnResume" data:@{}];
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 发送disappear的消息给当前webview
    [self postEventToJs:@"viewOnPause" data:@{}];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self postEventToJs:@"viewOnStop" data:@{}];
}

- (void)dealloc{
    [self postEventToJs:@"viewOnDestroy" data:@{}];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCookie: self.appUrl];
    [self postEventToJs:@"viewOnCreate" data:@{}];
}

- (void)setCookie:(NSURL*) url{
    // SETCOOKIE START
    // SETCOOKIE END
}

- (NSURL*)appUrl
{
    NSURL* appURL = nil;
    
    if ([self.startPage rangeOfString:@"://"].location != NSNotFound) {
        appURL = [NSURL URLWithString:self.startPage];
    } else if ([self.wwwFolderName rangeOfString:@"://"].location != NSNotFound) {
        appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.wwwFolderName, self.startPage]];
    } else if([self.wwwFolderName rangeOfString:@".bundle"].location != NSNotFound){
        // www folder is actually a bundle
        NSBundle* bundle = [NSBundle bundleWithPath:self.wwwFolderName];
        appURL = [bundle URLForResource:self.startPage withExtension:nil];
    } else if([self.wwwFolderName rangeOfString:@".framework"].location != NSNotFound){
        // www folder is actually a framework
        NSBundle* bundle = [NSBundle bundleWithPath:self.wwwFolderName];
        appURL = [bundle URLForResource:self.startPage withExtension:nil];
    } else {
        // CB-3005 strip parameters from start page to check if page exists in resources
        NSURL* startURL = [NSURL URLWithString:self.startPage];
        NSString* startFilePath = [self.commandDelegate pathForResource:[startURL path]];
        
        if (startFilePath == nil) {
            appURL = nil;
        } else {
            appURL = [NSURL fileURLWithPath:startFilePath];
            // CB-3005 Add on the query params or fragment.
            NSString* startPageNoParentDirs = self.startPage;
            NSRange r = [startPageNoParentDirs rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
            if (r.location != NSNotFound) {
                NSString* queryAndOrFragment = [self.startPage substringFromIndex:r.location];
                appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
            }
        }
    }
    
    return appURL;
}

- (instancetype)initWithRouterParams:(NSDictionary *) routerParams {
    self = [super init];
    if(self) {
        if(routerParams && [routerParams objectForKey:kExtraParams]) {
            self.pageParams = [routerParams objectForKey:kExtraParams];
            NSString *url = [routerParams objectForKey:kREALURL] ? [routerParams objectForKey:kREALURL] : [self.pageParams objectForKey:kURL];
            if(url) {
                self.pageName = url;
                self.startPage = [[EnvRouter sharedRouter] pathForUrl:url withParams:routerParams];
            }
            [self setTabBarItem];
        }
        // 禁用自动根据navigationbar, statusbar 调整WebView的内容大小
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    return self;
}

#pragma mark - NavigationBar

- (void)setAppearance {
    NSNumber *showNavi = [self.pageParams objectForKey:kShowNavi];
    if(showNavi && showNavi.boolValue) {
        [self setNavigationBarBg];
        [self setTitle];
        [self setNavigationBarLeftButton];
        [self setNavigationBarRightButton];
    }else {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)setNavigationBarBg{
    Class viewControllerClass = [EnvContainerFactory containerClassForName:@"TXSakuraManager"];
    if(viewControllerClass) {
        [self.navigationController setNavigationBarHidden:NO];
        self.navigationController.navigationBar.translucent=NO;
        [self.navigationController skin_setBackgroundColor];
    }else {
        [self.navigationController setNavigationBarHidden:NO];
        NSArray *naviBarBgColors = [[EnvStyleParser sharedParser] navigationBarBackgroundColors];
        if([naviBarBgColors count] > 1) {
            NSInteger gradientDirection = [[EnvStyleParser sharedParser] navigationBarGradient];
            NSMutableArray *colors = [[NSMutableArray alloc] init];
            for(int i = 0; i < [naviBarBgColors count]; i++){
                colors[i] = (id)[UIColor colorWithCSS:naviBarBgColors[i]];
            }
            [self.navigationController ex_setBackgroundGradientColors:colors direction:gradientDirection];
        }else {
            [self.navigationController ex_setBackgroundColor:[UIColor colorWithCSS:naviBarBgColors[0]]];
        }
    }
}

- (void)setTitle {
    Class viewControllerClass = [EnvContainerFactory containerClassForName:@"TXSakuraManager"];
    if(viewControllerClass) {
        NSString * title = [self.pageParams objectForKey: kTitle];
        if(title) {
            [self.navigationController skin_setTitle:NSLocalizedString(title, title)  withAction:@selector(onNaviTop:) target:self];
        }
    }else{
        NSString * title = [self.pageParams objectForKey: kTitle];
        if(title) {
            [self.navigationController ex_setTitle:NSLocalizedString(title, title)  withAction:@selector(onNaviTop:) target:self];
        }
    }
}

- (void)setNavigationBarLeftButton {
    Class viewControllerClass = [EnvContainerFactory containerClassForName:@"TXSakuraManager"];
    if(viewControllerClass) {
        NSString *leftIcon = [self.pageParams objectForKey:kLeftIcon];
        if(leftIcon) {
            [self.navigationController skin_setNaviBarLeftButton:leftIcon withAction:@selector(onNaviLeft:) target:self];
        } else {
            [self.navigationItem setHidesBackButton:YES];
            self.navigationController.visibleViewController.navigationItem.leftBarButtonItem = nil;
            
        }
    }else{
        NSString *leftIcon = [self.pageParams objectForKey:kLeftIcon];
        if(leftIcon) {
            [self.navigationController ex_setNaviBarLeftButton:leftIcon withAction:@selector(onNaviLeft:) target:self];
        } else {
            [self.navigationItem setHidesBackButton:YES];
            self.navigationController.visibleViewController.navigationItem.leftBarButtonItem = nil;
            
        }
    }
}

- (void)setNavigationBarRightButton{
    Class viewControllerClass = [EnvContainerFactory containerClassForName:@"TXSakuraManager"];
    if(viewControllerClass) {
        NSString *rightIcon = [self.pageParams objectForKey:kRightIcon];
        if(rightIcon) {
            [self.navigationController skin_setNaviBarRightButton:rightIcon withAction:@selector(onNaviRight:) target:self];
        } else {
            [self.navigationController ex_hideNaviRightButton];
        }
    }else{
        NSString *rightIcon = [self.pageParams objectForKey:kRightIcon];
        if(rightIcon) {
            [self.navigationController ex_setNaviBarRightButton:rightIcon withAction:@selector(onNaviRight:) target:self];
        } else {
            [self.navigationController ex_hideNaviRightButton];
        }
    }
}


#pragma mark - TabBarItem

- (void)setTabBarItem {
    NSString *tabIcon = [self.pageParams objectForKey:kTabIcon];
    NSString *tabTitle = [self.pageParams objectForKey:kTabTitle];
    
    if(tabIcon) {
        CGFloat tabImageSize = [[EnvStyleParser sharedParser] tabBarItemImageSize];
        NSString *tabItemColor = [[EnvStyleParser sharedParser] tabBarItemColor];
        NSString *tabItemSelectedColor = [[EnvStyleParser sharedParser] tabBarItemSelectedColor];
        self.tabBarItem.image = [[UIImage imageWithIconFont:tabIcon imageSize:CGSizeMake(tabImageSize, tabImageSize) fontSize:tabImageSize color:[UIColor colorWithCSS:tabItemColor]]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageWithIconFont:tabIcon imageSize:CGSizeMake(tabImageSize, tabImageSize) fontSize:tabImageSize color:[UIColor colorWithCSS:tabItemSelectedColor]]
                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    if(tabTitle) {
        CGFloat tabTitleSize = [[EnvStyleParser sharedParser] tabBarItemTitleSize];
        self.tabBarItem.title = NSLocalizedString(tabTitle, tabTitle);
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:FontName size:tabTitleSize], NSFontAttributeName, nil] forState: UIControlStateNormal];
        if(!tabIcon) {
            [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -12)];
        }
    }
}

#pragma mark - Event

- (void)onNaviTop:(id)sender{
    DLog(@"onNaviTop");
    [self postEventToJs:@"navitop" data:@{}];
}

- (void)onNaviLeft:(id)sender{
    DLog(@"onNaviLeft");
    [self postEventToJs:@"navileft" data:@{}];
}

- (void)onNaviRight:(id)sender{
    DLog(@"onNaviRight");
    [self postEventToJs:@"naviright" data:@{}];
}

- (void)postEventToJs:(NSString * )type data:(NSDictionary *)data
{
    NSString *encodedMessage = [[data convertToUTF8String] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *jsExpression = [NSString stringWithFormat:@"document.dispatchEvent(new CustomEvent(\"%@\", {detail : \"%@\"}));", type, encodedMessage];
    [self.commandDelegate evalJs:jsExpression];
}

#pragma mark - WebView Settings

/**
 * overwrite CDVViewController's view creator to modify the size
 */
- (void)createGapView
{
    CGRect webViewBounds = self.view.bounds;
    
    webViewBounds.origin = self.view.bounds.origin;
    
    NSNumber* showNavi = [self.pageParams objectForKey:kShowNavi];
    if(showNavi && !showNavi.boolValue){
        webViewBounds.size.height += 20;
    }
    if(self.tabBarController) {
        webViewBounds.size.height -= self.tabBarController.tabBar.frame.size.height;
    }
    
    UIView* view = [self newCordovaViewWithFrame:webViewBounds];
    NSString * bgColor = [[EnvStyleParser sharedParser] webViewBackgroundColor];
    if(bgColor){
        [view setBackgroundColor:[UIColor colorWithCSS:bgColor]];
        view.opaque= NO;
    }
    
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    // [self fixTouchEndOutofBound:self.webView]; 暂时去掉，Cordova升级到4.3版本后，该问题是否存在待验证
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
}

/**
 *  当拖动超出WebView 时，touchend事件会缺失，这里检测并补充这个事件
 */
-(void) fixTouchEndOutofBound:(UIWebView *) webview
{
    self.gesture = [[WildcardGestureRecognizer alloc] init];
    self.gesture.touchesEndCallback = ^(NSSet * touches, UIEvent * event)
    {
        NSString *jsString = [[NSString alloc] initWithFormat:@"window.dispatchEvent(new Event('touchend'));"];
        [webview stringByEvaluatingJavaScriptFromString:jsString];
    };
    [webview addGestureRecognizer:self.gesture];
}

@end
