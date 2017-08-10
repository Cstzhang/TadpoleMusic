//
//  MyViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "MyViewController.h"
#import "CircleRippleView.h"

@interface MyViewController ()
/** <#注释#> */
@property (nonatomic,strong) CircleRippleView * rippleView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的"];
//    self.rippleView = [[CircleRippleView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    _rippleView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
//    [self.view addSubview:_rippleView];
//    _rippleView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
//    [_rippleView startAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
