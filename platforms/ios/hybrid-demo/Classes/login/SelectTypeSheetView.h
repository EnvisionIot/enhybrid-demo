//
//  SelectTypeSheetView.h
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActionSheetViewType) {
    ActionSheetViewTypeDefault = 0,      // 默认类型：无标题、无取消；有默认选项
    ActionSheetViewTypeTitle,            // 标题类型：无默认选项、无取消；有标题
    ActionSheetViewTypeCancel,           // 取消类型：无默认选项、无标题；有取消
    ActionSheetViewTypeTitleCancel       // 标题取消类型：无默认选项；有标题，有取消
};

typedef void(^ActionSheetViewSelectBlock)(NSInteger index, NSString *indexName);
typedef void(^ActionSheetViewSelect2Block)();


@interface SelectTypeSheetView : UIView

@property (nonatomic, strong) NSArray *dataTitleArray;
@property (nonatomic, copy)   NSString *defaultTitleString;     // 默认选项文字；标题文字
@property (nonatomic, copy)   NSString *defaultTitle;     // 默认选项文字；标题文字
@property (nonatomic) int currentIndex;
@property (nonatomic, assign) NSTextAlignment textAlignment;    // 设置文字居中样式
@property (nonatomic, copy)  ActionSheetViewSelectBlock block;
@property (nonatomic, copy)  ActionSheetViewSelect2Block block2;

- (instancetype)initWithFrame:(CGRect)frame ActionSheetViewType:(ActionSheetViewType)type;

- (void)showActionSheetView;
- (void)hideActionSheetView;
- (void)setDataTitleArray:(NSArray *)dataTitleArray defaultTitle:(NSString *)defaultTitle;

@end
