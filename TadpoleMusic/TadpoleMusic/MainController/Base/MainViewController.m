//
//  MainViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavController.h"
#import "HomeViewController.h"
#import "HotListViewController.h"
#import "MyViewController.h"
#define kScreenHeight      [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth       [[UIScreen mainScreen] bounds].size.width
@interface MainViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
/** 控制器数组 */
@property (nonatomic,strong) NSArray * controllClassArr;
@end

@implementation MainViewController
#pragma mark - **************** 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth * self.controllClassArr.count, kScreenHeight);
        //设置默认偏移量，先显示首页
        _scrollView.contentOffset=CGPointMake(kScreenWidth, 0);
    }
    return _scrollView;
}
-(NSArray *)controllClassArr{
    if (!_controllClassArr) {
        _controllClassArr =@[@"MyViewController",@"HomeViewController",@"HotListViewController"];
    }

    return  _controllClassArr;

}
#pragma mark - **************** 初始化
-(void)setBaseScroView{
    //添加基础的BaseScroView
    [self.view addSubview:self.scrollView];
    //基础控制器数组
    //for 循环添加控制器
    for (int i = 0; i<self.controllClassArr.count; i++) {
        NSLog(@"creat controller %@",self.controllClassArr[i]);
        //初始化一个控制器
        UIViewController *oneController=[[NSClassFromString(self.controllClassArr[i]) alloc]init];
//        //初始化一个NavController
//        BaseNavController *navController=[[BaseNavController alloc]initWithRootViewController:oneController];
        //设置位置
        oneController.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        //添加控制器
        [self.scrollView addSubview:oneController.view];
    }
}



#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBaseScroView];
}

#pragma mark - **************** pageController
//






@end
