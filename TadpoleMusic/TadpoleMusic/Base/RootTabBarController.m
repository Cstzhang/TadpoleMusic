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
    //透明度,设置为不是半透明
    self.tabBar.translucent=YES;
    //背景图去掉
    self.tabBar.backgroundImage=[ComFunc createImageWithColor:CLEAR_COLOR];
    //设置分割线颜色
    [self.tabBar setShadowImage:[ComFunc createImageWithColor:[UIColor zb_colorWithHex:0x28e532]]];
    self.delegate=self;
    //tabbar数据数组
    NSArray * itemTitles        = @[@"搜歌",@"我的"];
    NSArray *normalImageItems = @[@"music_icon_unselect",@"me_icon_unselect"];
    NSArray *selectImageItems = @[@"music_icon_select",@"me_icon_select"];
    NSArray * controllClass   = @[@"HomeViewController",@"MyViewController"];
    NSMutableArray * controllers = [[NSMutableArray alloc]init];
    //循环添加tabbar的Controller
    for (int i = 0; i<itemTitles.count; i++) {
        //实例化控制器
        UIViewController *oneTabController            = [[NSClassFromString(controllClass[i]) alloc]init];
        BaseNavController *navigation                 = [[BaseNavController alloc]initWithRootViewController:oneTabController];
        //图片
        navigation.tabBarItem.image                   = [[UIImage imageNamed:normalImageItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        navigation.tabBarItem.selectedImage            = [[UIImage imageNamed:selectImageItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //偏移量
        navigation.tabBarItem.titlePositionAdjustment  = UIOffsetMake(0,0);//文字向上偏移-3
        [controllers addObject:navigation];
        //设置文字的颜色
        NSMutableDictionary *textAttrs                 = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName]      = [UIColor zb_colorWithHex:0x11ee83];
        textAttrs[NSFontAttributeName]                 = TEXT_FONT;
        NSMutableDictionary *selectTextAttrs           = [NSMutableDictionary dictionary];
        selectTextAttrs[NSFontAttributeName]           = TEXT_FONT;
        selectTextAttrs[NSForegroundColorAttributeName] = TABBAR_NORMAL_TINTCOLOR;
        //设置字体大小
        
        
        // navigation.tabBarItem
        [navigation.tabBarItem  setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        [navigation.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        // 设置tabbaritem 的title
        navigation.tabBarItem.title                    = itemTitles[i];
        
        
    }
    self.viewControllers = controllers;
}
@end
