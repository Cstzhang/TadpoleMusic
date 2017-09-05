//
//  MyViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "MyViewController.h"
#import "CircleRippleView.h"
#import "SongSlideView.h"
//#define adsViewWidth 293.0*(APPScreenBoundsWidth/320.0)
#define RatioValue  (SCREEN_HEIGHT-HEAD_TABBAR_HEIGHT-10)/667.0
#define APPScreenBoundsHeight [UIScreen mainScreen].bounds.size.height
#define APPScreenBoundsWidth [UIScreen mainScreen].bounds.size.width
@interface MyViewController ()<SongSlideDelegate>
{
    //卡片的 UIScrollView
    SongSlideView *_slide;
}


@end

@implementation MyViewController
#pragma mark - **************** 懒加载
#pragma mark - **************** 基础UI
-(void)setupUI{
     [self.navigationItem setTitle:@"我的"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    NSArray *array = @[
  @{@"red":@"255",@"green":@"46",@"blue":@"62"},
  @{@"red":@"82",@"green":@"255",@"blue":@"64"},
  @{@"red":@"82",@"green":@"255",@"blue":@"255"},
  @{@"red":@"79",@"green":@"85",@"blue":@"255"},
  @{@"red":@"236",@"green":@"30",@"blue":@"255"},
  @{@"red":@"46",@"green":@"255",@"blue":@"219"},
  @{@"red":@"255",@"green":@"152",@"blue":@"56"}];
    /*
     zMarginValue;//图片之间z方向的间距值，越小间距越大
     xMarginValue;//图片之间x方向的间距值，越小间距越大
     alphaValue;//图片的透明比率值
     angleValue;//偏移角度
     */
    
    CGRect rect = {{lrintf(LEFT_ORIGIN),HEAD_TABBAR_HEIGHT+10},{lrintf(SCREEN_HEIGHT-(2*LEFT_ORIGIN)) , SCREEN_HEIGHT-HEAD_TABBAR_HEIGHT-10}};
    
    _slide = [[SongSlideView alloc]initWithFrame:rect AndzMarginValue:9/(RatioValue) AndxMarginValue:11/(RatioValue) AndalphaValue:1 AndangleValue:2000];
    
    _slide.delegate = self;
    
    [_slide addCardDataWithArray:array];
    _slide.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_slide];
}

#pragma mark- 代理
-(void)slideCardViewDidEndScrollIndex:(NSInteger)index
{
    NSLog(@"__end__%ld",index);
}

-(void)slideCardViewDidSlectIndex:(NSInteger)index
{
    NSLog(@"__select__%ld",index);
}

-(void)slideCardViewDidScrollAllPage:(NSInteger)page AndIndex:(NSInteger)index
{
    NSLog(@"__page__%ld__index__%ld",page,index);
    
    //判断是否为第一页
    //    if(page == index){
    //        if (self.comeBackFirstMessageButton.frame.origin.y<APPScreenBoundsHeight) {
    //            [UIView animateWithDuration:0.8 animations:^{
    //                self.comeBackFirstMessageButton.center = CGPointMake(self.comeBackFirstMessageButton.center.x, self.comeBackFirstMessageButton.center.y+self.comeBackFirstMessageButton.frame.size.height);
    //            }];
    //        }
    //    }else{
    //        if (self.comeBackFirstMessageButton.frame.origin.y>=APPScreenBoundsHeight) {
    //            [UIView animateWithDuration:0.8 animations:^{
    //                self.comeBackFirstMessageButton.center = CGPointMake(self.comeBackFirstMessageButton.center.x, self.comeBackFirstMessageButton.center.y-self.comeBackFirstMessageButton.frame.size.height);
    //            }];
    //        }
    //    }
    
    //提醒已是最后一条消息,由透明慢慢显现
    //    if (_curPage == _totalPage && slideImageView.scrollView.contentOffset.y<0) {
    //        self.lastMessageLabel.alpha = -(slideImageView.scrollView.contentOffset.y/50.0);
    //    }
}



@end
