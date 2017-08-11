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
static  const int BTN_WIDTH = 160;
//搜索类型
typedef NS_ENUM(NSInteger, SearchType){
    /**
     *  音乐搜索
     */
    SearchTypeMusic=1,
    /**
     *  哼歌搜索
     */
    SearchTypeMusicHumming
};


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
/** 搜索类型 */
@property (nonatomic, assign) SearchType searchType;

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
//搜索歌曲按钮（按音乐搜索）
-(UIButton *)musicTypeBtn{
    if (!_musicTypeBtn) {
        _musicTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_musicTypeBtn addTarget:self action:@selector(searchTypeMusic) forControlEvents:UIControlEventTouchUpInside];
        [_musicTypeBtn setTitle:@"音乐" forState:UIControlStateNormal];
        _musicTypeBtn.titleLabel.font = TEXT_FONT;
        [_musicTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateNormal];
        [_musicTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateHighlighted];
        [_musicTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_slected"] forState:UIControlStateSelected];
        
    }
    return _musicTypeBtn;
}
//搜索歌曲（按哼唱搜索）
-(UIButton *)hummingTypeBtn{
    if (!_hummingTypeBtn) {
        _hummingTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hummingTypeBtn addTarget:self action:@selector(searchTypeHumming) forControlEvents:UIControlEventTouchUpInside];
        [_hummingTypeBtn setTitle:@"哼唱" forState:UIControlStateNormal];
        _hummingTypeBtn.titleLabel.font = TEXT_FONT;
        [_hummingTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateNormal];
        [_hummingTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateHighlighted];
        [_hummingTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_slected"] forState:UIControlStateSelected];
    }
    return _hummingTypeBtn;
}
//搜索歌曲按钮
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
//水波纹视图
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
   //选择按钮
    [self.view addSubview:self.musicTypeBtn];
    [_musicTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBtn.bottom).offset(20);
        make.right.equalTo(self.view.centerX).offset(-30);
        make.width.equalTo(RATIO_W(100));
        make.height.equalTo(RATIO_W(30));
    }];
    self.musicTypeBtn.selected = YES;
    //默认选择音乐识别
    [self.view addSubview:self.hummingTypeBtn];
    [_hummingTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBtn.bottom).offset(20);
            make.left.equalTo(self.view.centerX).offset(30);
            make.width.equalTo(RATIO_W(100));
            make.height.equalTo(RATIO_W(30));
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
-(void)searchTypeMusic{
    NSLog(@"听音乐搜索模式");
    self.searchType=SearchTypeMusic;
    self.hummingTypeBtn.selected = NO;
    self.musicTypeBtn.selected=YES;
}

-(void)searchTypeHumming{
    NSLog(@"听音乐搜索模式");
    self.searchType=SearchTypeMusicHumming;
    self.hummingTypeBtn.selected = YES;
    self.musicTypeBtn.selected=NO;
}
@end
