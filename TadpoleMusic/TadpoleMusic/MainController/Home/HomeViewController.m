//
//  HomeViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HomeViewController.h"
#import "CircleRippleView.h"

//搜索按钮的宽度
static  const int BTN_WIDTH = 193;

@interface HomeViewController ()
/** 提示语label */
@property (nonatomic,strong) UILabel * tipsLabel;
/** 监听的Button */
@property (nonatomic,strong) UIButton * searchBtn;
/** 音乐类型button */
@property (nonatomic,strong) UIButton * musicTypeBtn;
/** 哼唱类型button */
@property (nonatomic,strong) UIButton * hummingTypeBtn;
/** 搜索波纹视图 */
@property (nonatomic,strong) CircleRippleView * rippleView;

@end

@implementation HomeViewController
#pragma mark - **************** 懒加载
//设置提示title
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = [UIFont systemFontOfSize:20];
        _tipsLabel.textColor = WHITE_COLOR;
        _tipsLabel.text = @"点击按钮开始识别";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(searchMusic) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateHighlighted];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateHighlighted];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateSelected];
    }
    return _searchBtn;
}

-(CircleRippleView *)rippleView{
    if (!_rippleView) {
        _rippleView = [[CircleRippleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _rippleView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
        _rippleView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    }
    return  _rippleView;

}

#pragma mark - **************** 初始化
-(void)setupUI{
    //波纹视图
    [self.view addSubview:self.rippleView];
    //设置识别按钮
    [self.view addSubview:self.searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.centerY);
        make.centerX.equalTo(self.view.centerX);
        make.width.height.equalTo(RATIO_W(BTN_WIDTH));
    }];
    //提示语
    [self.view addSubview:self.tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.centerY).offset(-RATIO_W(BTN_WIDTH)/2 -20);
    }];

    
}
//设置提示title



//设置 音乐/哼唱切换按钮

//添加雷达效果

#pragma mark - **************** 什么周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
  
}





#pragma mark - **************** 交互方法
//搜索音乐
-(void)searchMusic{
    NSLog(@"搜索音乐");
    [_rippleView startAnimation];
}

@end
