//
//  CoverView.m
//  Wind
//
//  Created by syl on 18/4/4.
//
//

#import "CoverView.h"


@implementation CoverView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *nibs=[[NSBundle mainBundle]loadNibNamed:@"CoverView" owner:nil options:nil];
        self=[nibs objectAtIndex:0];
        
        _myframe = frame;
        self.knowBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.knowBtn.layer.cornerRadius = 24;
        self.knowBtn.layer.masksToBounds = true;
        self.knowBtn.layer.borderWidth = 1;
        [self.knowBtn setTitle: NSLocalizedString(@"i_know", nil) forState:UIControlStateNormal];
        self.notice_label.text = NSLocalizedString(@"guide_notice", nil);
        self.subviews.firstObject.frame = _myframe;
    
        
    }
    
    return self;
}
-(void)drawRect:(CGRect)rect{
    self.frame=_myframe;
   }

@end
