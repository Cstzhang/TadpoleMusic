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
#import "DBHander.h"

@interface MyViewController ()<SongSlideDelegate>
{
    //卡片的 UIScrollView
    SongSlideView *_slide;
}
//声明AppDelegate对象属性，用于调用类中属性，管理存储上下文
@property(nonatomic,strong)DBHander *dbHander;
@property(nonatomic,strong)NSMutableArray *songArray;

@end

@implementation MyViewController
#pragma mark - **************** 懒加载
-(NSMutableArray *)songArray{
    if (!_songArray) {
        _songArray = [NSMutableArray array];
    }
    return _songArray;

}
-(void)viewWillAppear:(BOOL)animated{
    //====搜索本地缓存的数据
    [self.songArray  removeAllObjects];
    [self.songArray addObjectsFromArray:[self.dbHander searchSong]];
    //数据（需要补充未真实数据源数据）
    [_slide addCardDataWithArray:self.songArray];
}
#pragma mark - **************** 基础UI
-(void)setupUI{
     [self.navigationItem setTitle:@"我的"];
    //====初始化 myAppDelegate
    self.dbHander = [[DBHander alloc]init];
 
    #warning 如果数据为空需要有为空显示，并提醒去识别
    //====初始化UIScrollView
    //设置宽高
    CGRect rect = {{lrintf((SCREEN_WIDTH-RATIO_W(345))/2.0),HEAD_TABBAR_HEIGHT},{lrintf(CardW) , SCREEN_HEIGHT-(HEAD_TABBAR_HEIGHT+HEAD_TABBAR_HEIGHT)}};
    //实例化
    _slide = [[SongSlideView alloc]initWithFrame:rect AndzMarginValue:9/(RatioValue) AndxMarginValue:11/(RatioValue) AndalphaValue:1 AndangleValue:2000];
    _slide.delegate = self;
    //背景色
    _slide.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_slide];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark- UIScrollView 代理
//滚动结束时当前的视图
-(void)slideCardViewDidEndScrollIndex:(NSInteger)index
{
    NSLog(@"__end__%ld",index);
}

//选中某张视图
-(void)slideCardViewDidSlectIndex:(NSInteger)index
{
    NSLog(@"__select__%ld",index);
}
//滑动某张视图
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
