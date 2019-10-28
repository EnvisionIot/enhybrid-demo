//
//  SelectTypeSheetCell.h
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/14.
//

#import <UIKit/UIKit.h>

#define ActionSheetCell_Height  60

@interface SelectTypeSheetCell : UITableViewCell
@property (nonatomic, copy)   NSString        *titleString;
@property (nonatomic, assign) NSTextAlignment  textAlignment;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
