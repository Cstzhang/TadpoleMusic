//
//  HomeViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
/** 提示语label */
@property (nonatomic,strong) UILabel * tipsLabel;
/** 监听的Button */
@property (nonatomic,strong) UIButton * searchBtn;
/** 音乐类型button */
@property (nonatomic,strong) UIButton * musicTypeBtn;
/** 哼唱类型button */
@property (nonatomic,strong) UIButton * hummingTypeBtn;

@end

@implementation HomeViewController
#pragma mark - **************** 懒加载


#pragma mark - **************** 初始化
//设置提示title


//设置识别按钮

//设置 音乐/哼唱切换按钮

//添加雷达效果

#pragma mark - **************** 什么周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}



@end
