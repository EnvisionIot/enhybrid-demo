//
//  SelectTypeSheetView.m
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/14.
//

#import "SelectTypeSheetView.h"
#import "SelectTypeSheetCell.h"
#import "EnvIconFont.h"

#define SCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define Space_X               10
#define Space_Y               10
#define View_BGColor    [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0]  // 基础底色



@interface SelectTypeSheetView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ActionSheetViewType type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat tableHeight;

@end

@implementation SelectTypeSheetView

- (instancetype)initWithFrame:(CGRect)frame ActionSheetViewType:(ActionSheetViewType)type {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
        self.type = type;
        self.tableHeight = 0;
        self.dataArray = [NSMutableArray array];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)createUI {
    if (self.type == ActionSheetViewTypeTitleCancel) {
        self.tableHeight = (self.dataTitleArray.count + 2) * ActionSheetCell_Height + Space_Y/2*2;
    } else {
        self.tableHeight = (self.dataTitleArray.count) * ActionSheetCell_Height + 44 + Space_Y/2;
    }
    if (self.dataTitleArray.count >0 && !_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-self.tableHeight, SCREEN_WIDTH, self.tableHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        
        UIButton * xbutton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 5, 40, 40)];
        NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
        UIFont *font = [UIFont fontWithName:iconFontName size:18];
        xbutton.titleLabel.font=font;
        [xbutton setTitle:@"\ue902" forState:UIControlStateNormal];
        [xbutton setTitleColor:[UIColor colorWithRed:187/255.0 green:191/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
        [xbutton addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(20,5,250,40);
        label2.text = self.defaultTitle;
        label2.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        label2.textColor = [UIColor colorWithRed:41/255.0 green:43/255.0 blue:66/255.0 alpha:1];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.alpha = 1;
        label2.numberOfLines = 0;
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(15, 44, SCREEN_WIDTH-30, 1);
        lineView.layer.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:250/255.0 alpha:1].CGColor;
        [_tableView.tableHeaderView addSubview:label2];
        [_tableView.tableHeaderView addSubview:xbutton];
        [_tableView.tableHeaderView addSubview:lineView];
        
        
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = ActionSheetCell_Height;
        if (self.tableHeight > SCREEN_HEIGHT/2) {
            _tableView.bounces = YES;
        } else {
            _tableView.bounces = NO;
        }
        [self addSubview:_tableView];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark ---------------  UITableViewDataSource、UITableViewDelegate 代理  ---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectTypeSheetCell *cell = [SelectTypeSheetCell cellWithTableView:tableView];
    cell.titleString   = self.dataArray[indexPath.section][indexPath.row];
    cell.textAlignment = self.textAlignment;
    if(self.currentIndex == indexPath.row){
        UIView *iconview = [[UIView alloc] init];
        int strlength = [self convertToByte:cell.titleString];
        iconview.frame = CGRectMake(SCREEN_WIDTH/2 - ((strlength / 2) * 17 + 25), ActionSheetCell_Height/2 - 5,10,10);
        iconview.layer.backgroundColor = [UIColor colorWithRed:42/255.0 green:134/255.0 blue:255/255.0 alpha:1].CGColor;
        iconview.layer.shadowColor = [UIColor colorWithRed:42/255.0 green:134/255.0 blue:255/255.0 alpha:0.3].CGColor;
        iconview.layer.cornerRadius=5;
        iconview.layer.shadowOffset = CGSizeMake(0,2);
        iconview.layer.shadowOpacity = 1;
        iconview.layer.shadowRadius = 3;
        iconview.layer.masksToBounds = NO;
        [cell.contentView addSubview:iconview];
    }
    return cell;
}

- (int)convertToByte:(NSString*)str {
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == ActionSheetViewTypeDefault) {
        if (indexPath.section == 0) {
            [self hideActionSheetView];
        } else {
            self.block(indexPath.row, self.dataTitleArray[indexPath.row]);
            [self hideActionSheetView];
        }
    } else if (self.type == ActionSheetViewTypeTitle) {
        if (indexPath.section == 1) {
            self.block(indexPath.row, self.dataTitleArray[indexPath.row]);
            [self hideActionSheetView];
        }
    } else if (self.type == ActionSheetViewTypeCancel) {
        if (indexPath.section == 0) {
            self.block(indexPath.row, self.dataTitleArray[indexPath.row]);
        }
        [self hideActionSheetView];
    } else if (self.type == ActionSheetViewTypeTitleCancel) {
        if (indexPath.section == 1) {
            self.block(indexPath.row, self.dataTitleArray[indexPath.row]);
            [self hideActionSheetView];
        } else if (indexPath.section == 2) {
            [self hideActionSheetView];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        if (self.type == ActionSheetViewTypeTitleCancel && section == 2) {
            return 0;
        } else {
            return Space_Y/2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.type == ActionSheetViewTypeTitleCancel && section == 1) {
        return Space_Y/2;
    } else {
        return 0;
    }
}

#pragma mark -----
#pragma mark ---------------  Method  ---------------

- (void)setDataTitleArray:(NSArray *)dataTitleArray defaultTitle:(NSString *)defaultTitle{
    _dataTitleArray = dataTitleArray;
    _defaultTitle = defaultTitle;
    if (self.type == ActionSheetViewTypeDefault) {
        self.dataArray = [NSMutableArray arrayWithObjects:@[], _dataTitleArray, nil];
    } else if (self.type == ActionSheetViewTypeTitle) {
        self.dataArray = [NSMutableArray arrayWithObjects:@[@"请选择"], _dataTitleArray, nil];
    } else if (self.type == ActionSheetViewTypeCancel) {
        self.dataArray = [NSMutableArray arrayWithObjects:_dataTitleArray, @[NSLocalizedString(@"cancel", nil)], nil];
    } else if (self.type == ActionSheetViewTypeTitleCancel) {
        self.dataArray = [NSMutableArray arrayWithObjects:@[@"请选择"], _dataTitleArray, @[NSLocalizedString(@"cancel", nil)], nil];
    }
    [self createUI];
}

- (void)setDefaultTitleString:(NSString *)defaultTitleString {
    _defaultTitleString = defaultTitleString;
    if (self.type == ActionSheetViewTypeDefault) {
        self.dataArray = [NSMutableArray arrayWithObjects:@[defaultTitleString], _dataTitleArray, nil];
    } else if (self.type == ActionSheetViewTypeTitle) {
        self.dataArray = [NSMutableArray arrayWithObjects:@[defaultTitleString], _dataTitleArray, nil];
    } else if (self.type == ActionSheetViewTypeCancel) {
        self.dataArray = [NSMutableArray arrayWithObjects:_dataTitleArray, @[NSLocalizedString(@"cancel", nil)], nil];
    } else if (self.type == ActionSheetViewTypeTitleCancel) {
        self.dataArray = [NSMutableArray arrayWithObjects:@[defaultTitleString], _dataTitleArray, @[NSLocalizedString(@"cancel", nil)], nil];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
}

/********************  Animation  *******************/

- (void)showActionSheetView {
    if (self.dataTitleArray.count > 0) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        CGRect tempFrame = self.tableView.frame;
        self.alpha = 0.0f;
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.tableView.frame = tempFrame;
            }];
        }];
    }
}

- (void)hideActionSheetView {
    self.block2();
    [UIView animateWithDuration:0.25f animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }];
}


-(void)hideAction:(UIButton *)button {
    [self hideActionSheetView];
}

@end
