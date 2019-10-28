//
//  LoginViewController.m
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/14.
//

#import "LoginViewController.h"
#import "SelectTypeSheetView.h"
#import "UIColor+Hex.h"
#import "EnvHybridConstants.h"
#import <EnvHybrid/EnvRouter.h>
#import "Strs.h"
#import "PublicDefine.h"
#import "LoginService.h"
#import "AESCrypt.h"
#import "RSAEncryptor.h"
#import "Persistent.h"
#import "EnvIconFont.h"
#import "LoadingBtn.h"
#import "EnvAppData.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define SCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define env_list           @[NSLocalizedString(@"env_ch", nil)]

@interface LoginViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
#pragma mark logo
@property (nonatomic,strong) UIImageView *logoImage;

#pragma mark 账号
@property (nonatomic,strong) UILabel *accountLabel;
@property (nonatomic,strong) UITextField *accountTextField;

#pragma mark 密码
@property (nonatomic,strong) UILabel *passwordLabel;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UIButton *passwordVisibleBtn;

#pragma mark 用户环境
@property (nonatomic,strong) UILabel *environmentLabel;
@property (nonatomic,strong) UILabel *environmentTextLabel;
@property (nonatomic,strong) UIButton *environmentChooseButton;
@property (nonatomic,strong) NSArray *environmentValues;
#pragma mark 认证方式
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *typeTextLabel;
@property (nonatomic,strong) UIButton *typeChooseButton;
@property (nonatomic,strong) NSArray *typeValues;
#pragma mark 登录按钮
@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic, strong) SelectTypeSheetView *selectTypeSheetView;

@property (nonatomic, strong) NSDictionary *pageParams;

@end

@implementation LoginViewController

- (instancetype)initWithRouterParams:(NSDictionary *)routerParams {
    self = [super init];
    if(self) {
        if(routerParams && [routerParams objectForKey:kExtraParams]) {
            self.pageParams = [routerParams objectForKey:kExtraParams];
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.hidesBackButton = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.environmentValues = @[CN_SERVER];
    UIImageView  *squerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIImage *widthImage = [UIImage imageNamed:@"loginbg.png"];
    squerImage.image = widthImage;
    squerImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:squerImage];
    [self initLoginFrame];
    
}

-(void)transformView:(NSNotification *)aNSNotification
{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;

    NSLog(@"%f",self.view.frame.origin.y);
    if (deltaY < 0) {
        deltaY = -44;
    }else{
        deltaY = 0;
    }

    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

-(SelectTypeSheetView *)selectTypeSheetView:(NSString *)flag{
        _selectTypeSheetView = [[SelectTypeSheetView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-200, SCREEN_WIDTH, 200) ActionSheetViewType:ActionSheetViewTypeDefault];
        __weak LoginViewController *blockSelf = self;
        if([flag isEqualToString:@"environment"]){
            _selectTypeSheetView.dataTitleArray = env_list;
            [_selectTypeSheetView setDataTitleArray:env_list defaultTitle:NSLocalizedString(@"user_environment_select", nil)];
            _selectTypeSheetView.currentIndex=[[[PublicDefine sharedInstance] getCurrentEnv] intValue];
            _selectTypeSheetView.block = ^(NSInteger index, NSString *indexName) {
                NSLog(@"点击了 ----- %zd, %@", index, indexName);
                blockSelf.environmentTextLabel.text= env_list[index];
                [[PublicDefine sharedInstance] setCurrentEnv:(int)index];
            };
        _selectTypeSheetView.block2 = ^(UIButton * button) {
            [_environmentChooseButton setTitle:@"\ue903" forState:UIControlStateNormal];
            [_typeChooseButton setTitle:@"\ue903" forState:UIControlStateNormal];
        };
      
        [_selectTypeSheetView showActionSheetView];
    }
    return _selectTypeSheetView;
}

-(void)initLoginFrame {
    
    int margin = 40;
    int labelX = 38;
    int labelWidth = 80;
    int labelHeight = 40;
    int textX = 80;
    int textWidth = SCREEN_WIDTH - 2*margin - labelWidth;
    int textHeight = 40;
    int fontSize = 17;
    int initialY = SCREEN_HEIGHT > 750 ? 310 : 260;
    initialY = SCREEN_HEIGHT < 600 ? 210 : initialY;
    int btnY = SCREEN_HEIGHT > 750 ? 580 : 530;
    btnY = SCREEN_HEIGHT < 600 ? 480 : btnY;
    int logoY = SCREEN_HEIGHT > 750 ? 106 : 56;
    logoY = SCREEN_HEIGHT < 600 ? 6 : logoY;
    int verticalSpacing = 52;
    UIColor *textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    UIColor *hintTextColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    
    UIFont *font = [UIFont fontWithName:@"mapicon" size:17];

    //添加图片
    CGRect logoRect=CGRectMake(44, logoY, 130, 130);
    
    _logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];//设置图片
    _logoImage.contentMode=UIViewContentModeScaleAspectFit;//设置内容填充模式
    _logoImage.frame=logoRect;//设置控件大小和位置（相对于父控件的位置）
    [self.view addSubview:_logoImage];//添加到KCMainViewController的View中
    
    //账号提示
    _accountLabel=[[UILabel alloc] init];
    _accountLabel.frame=CGRectMake(labelX, initialY, labelWidth, labelHeight);
    [self setIconFontLabel:_accountLabel iconfont:@"\ue924" fontSize:fontSize];
    _accountLabel.textColor = textColor;
    _accountLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_accountLabel];
    
    //账号输入框
    _accountTextField=[[UITextField alloc] init];
    _accountTextField.frame=CGRectMake(textX, initialY, textWidth+40, textHeight);
    _accountTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:NSLocalizedString(@"account_plceholder", nil) attributes:@{NSForegroundColorAttributeName:hintTextColor,NSFontAttributeName:_accountTextField.font}];
    _accountTextField.font=[UIFont systemFontOfSize:fontSize];
    _accountTextField.borderStyle=UITextBorderStyleNone;
    _accountTextField.textColor=textColor;
    _accountTextField.delegate = self;
    _accountTextField.tag = 100;

    [self.view addSubview:_accountTextField];
    
    
    //用户密码提示
    _passwordLabel=[[UILabel alloc] init];
    _passwordLabel.frame=CGRectMake(labelX, initialY+ verticalSpacing, labelWidth, labelHeight);
//    _passwordLabel.text=NSLocalizedString(@"password", nil);
//    _passwordLabel.font=[UIFont systemFontOfSize:fontSize];
    [self setIconFontLabel:_passwordLabel iconfont:@"\ue91c" fontSize:fontSize];
    _passwordLabel.textColor = textColor;
    _passwordLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_passwordLabel];
    
    //密码输入框
    _passwordTextField=[[UITextField alloc] init];
    _passwordTextField.frame=CGRectMake(textX, initialY+ verticalSpacing, textWidth+40, textHeight);
    _passwordTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:NSLocalizedString(@"password_plceholder", nil) attributes:@{NSForegroundColorAttributeName:hintTextColor,NSFontAttributeName:_passwordTextField.font}];
//    _passwordTextField.placeholder=NSLocalizedString(@"password_plceholder", nil);
    _passwordTextField.font=[UIFont systemFontOfSize:fontSize];
    _passwordTextField.borderStyle=UITextBorderStyleNone;
    _passwordTextField.secureTextEntry=YES;
    _passwordTextField.textColor=textColor;
    _passwordTextField.delegate =self;

    [self.view addSubview:_passwordTextField];
    //密码显隐性
    _passwordVisibleBtn = [[UIButton alloc] init];
    _passwordVisibleBtn.frame = CGRectMake(textX+textWidth+40-17, initialY+ verticalSpacing+10, 17, 17);
    _passwordVisibleBtn.titleLabel.font = [UIFont fontWithName:@"mapicon" size:17];
    [_passwordVisibleBtn setTitle:@"\ue900" forState:UIControlStateNormal];
    [_passwordVisibleBtn addTarget:self action:@selector(passwordVisibleOrNot:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_passwordVisibleBtn];
    
    
    
    //用户环境提示
    _environmentLabel=[[UILabel alloc] init];
    _environmentLabel.frame=CGRectMake(labelX, initialY+ 2*verticalSpacing, 150, 40);
    [self setIconFontLabel:_environmentLabel iconfont:@"\ue917" fontSize:fontSize];
    _environmentLabel.textColor = textColor;

    _environmentLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_environmentLabel];
    
    //用户环境选择结果
    _environmentTextLabel=[[UILabel alloc] init];
    _environmentTextLabel.frame=CGRectMake(textX, initialY+ 2*verticalSpacing, textWidth, textHeight);
    int env = [[[PublicDefine sharedInstance] getCurrentEnv] intValue];
    _environmentTextLabel.text= env_list[env];
    _environmentTextLabel.textColor = textColor;
    
    _environmentTextLabel.font=[UIFont systemFontOfSize:fontSize];
    _environmentTextLabel.textAlignment=NSTextAlignmentLeft;
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseEnvironmentBtnAction:)];
    _environmentTextLabel.userInteractionEnabled = YES;
    [_environmentTextLabel addGestureRecognizer:tap];
    [self.view addSubview:_environmentTextLabel];
    //用户环境选择按钮
    _environmentChooseButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-margin-15, initialY+2*verticalSpacing+15, 16, 16)];
    [_environmentChooseButton addTarget:self action:@selector(chooseEnvironmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _environmentChooseButton.titleLabel.font=font;
    [_environmentChooseButton setTitle:@"\ue903" forState:UIControlStateNormal];
    [_environmentChooseButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.view addSubview:_environmentChooseButton];

    //添加横线
    [self drawLines];
    
    //登录按钮
    _loginButton = [[LoadingBtn alloc] initWithFrame:CGRectMake(40, btnY, SCREEN_WIDTH-2*margin, 44)];
    UIImage *bgImage = [self getGradientColors];
    [_loginButton.layer setMasksToBounds:YES];
    [_loginButton.layer setCornerRadius:20.0];
    [_loginButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    _loginButton.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    [_loginButton setTitleColor:[UIColor colorWithRed:60/255.0 green:62/255.0 blue:71/255.0 alpha:1] forState:UIControlStateNormal];
    [_loginButton setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

-(void)drawLines{
    int lineY = SCREEN_HEIGHT > 750 ? 350 : 300;
    lineY = SCREEN_HEIGHT < 650 ? 250 : lineY;
    for (short i = 0; i < 3; i++) {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(38, lineY+50*i + 8, SCREEN_WIDTH-2*38, 1)];
        line.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        [self.view addSubview:line];
    }
}

-(void)chooseEnvironmentBtnAction:(id)sender {
    //监听键盘，关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (_selectTypeSheetView) {
        _selectTypeSheetView = nil;
    }
    [_environmentChooseButton setTitle:@"\ue906" forState:UIControlStateNormal];
    [self selectTypeSheetView:@"environment"];
}


-(void)setIconFontLabel:(UILabel*)label iconfont:(NSString *)iconfont fontSize:(int)fontSize{
    NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
    UIFont *font = [UIFont fontWithName:iconFontName size:fontSize];
    [label setFont:font];
    // 判断是icon font
    if(iconfont.length ==1 && [iconfont characterAtIndex:0] > 4096){
        [label setText: iconfont];
    }else{
        [label setText: iconfont];
    }
}

-(void)chooseTypeBtnAction:(id )sender {
    NSLog(@"手势触发");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (_selectTypeSheetView) {
        _selectTypeSheetView = nil;
    }
    [_typeChooseButton setTitle:@"\ue906" forState:UIControlStateNormal];
    [self selectTypeSheetView:@"type"];
}

-(void)loginAction:(LoadingBtn *)button {
//    [self putKeyboardDown];
    NSString *username = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    [button startLoading];

    if(username == nil || [username isEqual:@""] || password == nil || [password isEqual:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:NSLocalizedString(@"msg_username_or_password_empty", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [button stopLoading];

        return;
    }
    
    // 对密码进行加密
    [[LoginService sharedService] performLogin:username password:password succ:^{
        
        //登录成功跳转到loading页面
        [button stopLoading];
        [[EnvRouter sharedRouter] open:HOME_ROUTE];
    } failure:^(NSError *error) {
        [button stopLoading];

        //处理登录错误信息
//        [_loading stopAnimating];
        //        NSLog(@"Login Failed %@", error.domain);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:error.userInfo[@"NSLocalizedDesc"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}

- (UIImage *)getGradientColors
{
    
    CGSize size = CGSizeMake(SCREEN_WIDTH-2*24, 44);
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.colors = @[(id)[UIColor colorWithCSS:@"#FFFFFFFF"].CGColor,
                     (id)[UIColor colorWithCSS:@"#FFFFFFFF"].CGColor];
    
    layer.startPoint = CGPointMake(0.0, 0.5);
    layer.endPoint = CGPointMake(1.0, 0.5);
    
    UIGraphicsBeginImageContext(size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountTextField resignFirstResponder];//失去焦点
    [_passwordTextField resignFirstResponder];
}

-(void)passwordVisibleOrNot:(UIButton *)sender{
    sender.selected = !sender.selected;
    _passwordVisibleBtn.titleLabel.font = [UIFont fontWithName:@"mapicon" size:17];
    if (sender.selected) {
        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @"";
        self.passwordTextField.secureTextEntry = NO;
        self.passwordTextField.text = tempPwdStr;
        [_passwordVisibleBtn setTitle:@"\ue907" forState:UIControlStateNormal];
    }else{
        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @"";
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.text = tempPwdStr;
        [_passwordVisibleBtn setTitle:@"\ue900" forState:UIControlStateNormal];

    }
    
}
- (void)clearButtonDidClick: (UIButton *)button {
    UITextField *textField = (UITextField *)button.superview;
    if (textField.tag == 100) {
        self.accountTextField.text = nil;
    }else{
        self.passwordTextField.text = nil;
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 账号清除按钮
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame;
    if (textField.tag == 100) {
        frame = CGRectMake(textField.frame.size.width - 17, 10, 17, 17);
    }else{
        frame = CGRectMake(textField.frame.size.width - 47, 10, 17, 17);
    }
    clearButton.frame = frame;
    [clearButton addTarget:self action:@selector(clearButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.titleLabel.font = [UIFont fontWithName:@"mapicon" size:17];
    [clearButton setTitle:@"\ue90e" forState:UIControlStateNormal];
    [textField addSubview:clearButton];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIButton *clearBtn;
    if (textField.tag == 100) {
        clearBtn = textField.subviews[0];
    }else{
        clearBtn = textField.subviews[1];
    }
    [clearBtn removeFromSuperview];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.accountTextField resignFirstResponder];//return后收起键盘
    [self.passwordTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
