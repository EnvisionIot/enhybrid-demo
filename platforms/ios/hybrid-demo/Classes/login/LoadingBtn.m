//
//  LoadingBtn.m
//  Wind
//
//  Created by syl on 2018/12/6.
//

#import "LoadingBtn.h"
#define K_Indecator_Width 25

@implementation LoadingBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIActivityIndicatorView *)indecator {
    if (_indecator == nil) {
        self.indecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indecator];
        self.indecator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indecator;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commentInit];
        [self setupConstrains];
    }
    return self;
}
- (void)commentInit{
    self.indecator.hidden = YES;
    self.indecator.userInteractionEnabled = NO;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
}
- (void)setupConstrains{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indecator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indecator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indecator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:25]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indecator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:25]];

}

- (void)startLoading{
    self.titleLabel.alpha = 0;
    [self.indecator startAnimating];
}

- (void)stopLoading{
    self.titleLabel.alpha = 1;
    [self.indecator stopAnimating];

}

@end
