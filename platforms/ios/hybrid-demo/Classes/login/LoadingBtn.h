//
//  LoadingBtn.h
//  Wind
//
//  Created by syl on 2018/12/6.
//

#import <UIKit/UIKit.h>

@interface LoadingBtn : UIButton
@property (nonatomic, strong) UIActivityIndicatorView *indecator;


- (void)startLoading;
- (void)stopLoading;
@end
