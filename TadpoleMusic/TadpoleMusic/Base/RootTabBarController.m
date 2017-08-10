//
//  RootTabBarController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/9.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseNavController.h"
@interface RootTabBarController ()<UITabBarControllerDelegate>

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarUI];
}

-(void)setTabBarUI{
    
    //基础设置
    self.tabBar.translucent=NO;//透明度,设置为不是半透明
    self.tabBar.backgroundImage=[CommonMethods createImageWithColor:CLEAR_COLOR];//背景图去掉
    self.delegate=self;
    //tabbar数据数组
    NSArray * itemTitles        = @[@"搜歌",@"榜单",@"我的"];
    NSArray *normalImageItems = @[@"Home-icon-unselect",@"My-case-icon-unselect",@"My-case-icon-unselect"];
    NSArray *selectImageItems = @[@"Home-icon-select",@"My-case-icon-select",@"My-case-icon-select"];
    NSArray * controllClass   = @[@"HomeViewController",@"HotListViewController",@"MyViewController"];
    NSMutableArray * controllers = [[NSMutableArray alloc]init];
    //循环添加tabbar的Controller
    for (int i = 0; i<itemTitles.count; i++) {
        UIViewController *oneTabController            = [[NSClassFromString(controllClass[i]) alloc]init];
        BaseNavController *navigation                 = [[BaseNavController alloc]initWithRootViewController:oneTabController];
        //tabBarItem样式
        navigation.tabBarItem.image                   = [[UIImage imageNamed:normalImageItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        navigation.tabBarItem.selectedImage            = [[UIImage imageNamed:selectImageItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navigation.tabBarItem.titlePositionAdjustment  = UIOffsetMake(0,-3);//文字向上偏移
        [controllers addObject:navigation];
        // 设置文字的样式
        NSMutableDictionary *textAttrs                 = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName]      = TABBAR_NORMAL_TINTCOLOR;
        NSMutableDictionary *selectTextAttrs           = [NSMutableDictionary dictionary];
        selectTextAttrs[NSForegroundColorAttributeName] = TABBAR_SELECT_TINTCOLOR;
        // navigation.tabBarItem
        [navigation.tabBarItem  setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        [navigation.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        // 设置tabbaritem 的title
        navigation.tabBarItem.title                    = itemTitles[i];
        
        
    }
    self.viewControllers = controllers;
}
@end
