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
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBaseScroView];
}

#pragma mark - **************** switch

#pragma mark - **************** UIScrollView
-(void)setBaseScroView{
    [self.view addSubview:self.scrollView];
 
    NSArray * controllClass     = @[@"MyViewController",@"HomeViewController",@"HotListViewController"];
    for (int i = 0; i<controllClass.count; i++) {
    UIViewController *oneController            = [[NSClassFromString(controllClass[i]) alloc]init];
    BaseNavController *navController     = [[BaseNavController alloc]initWithRootViewController:oneController];
    navController.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
    
    [self.scrollView addSubview:navController.view];
    }
//   
//    MyViewController *myVC = [[MyViewController alloc] init];
//    [self addChildViewController:myVC];
//    
//    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    [self addChildViewController:homeVC];
//    
//    HotListViewController *hotListVC = [[HotListViewController alloc] init];
//    [self addChildViewController:hotListVC];
//    
//    myVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    [self.scrollView addSubview:myVC.view];
//    
//    homeVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
//    [self.scrollView addSubview:homeVC.view];
//    
//    hotListVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight);
//    [self.scrollView addSubview:hotListVC.view];
    
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight);
        //设置默认偏移量，先显示首页
        _scrollView.contentOffset=CGPointMake(kScreenWidth, 0);
    }
    return _scrollView;
}

@end
