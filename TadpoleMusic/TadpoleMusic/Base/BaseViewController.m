//
//  BaseViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "BaseViewController.h"



@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackImage];
    //设置头部样式，透明头部
    [self setBaseNav];
    //取消默认缩进
}

#pragma mark - **************** set base navigationController
/**
 *  设置头部navigationBar透明
 */
-(void)setBaseNav{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //设置透明的背景图，
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                       barMetrics:UIBarMetricsDefault];
    //此处使底部线条失效
    [navigationBar setShadowImage:[UIImage new]];
   
}

//设置背景图
-(void)setBackImage{
    UIImage *image = [UIImage imageNamed:@"main_background_green"];
    self.view.layer.contents = (id)image.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
}



@end
