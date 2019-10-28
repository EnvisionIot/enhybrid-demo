//
//  ErrorViewController.m
//  hybrid-demo
//
//  Created by syl on 2019/7/29.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()
@property (nonatomic, strong) NSDictionary *pageParams;
@end

@implementation ErrorViewController

- (instancetype)initWithRouterParams:(NSDictionary *)routerParams {
    self = [super init];
    if(self) {
        if(routerParams && [routerParams objectForKey:@"extraParams"]) {
            self.pageParams = [routerParams objectForKey:@"extraParams"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
