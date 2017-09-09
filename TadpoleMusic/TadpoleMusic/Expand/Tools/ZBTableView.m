//
//  ZBTableView.m
//  TadpoleMusic
//
//  Created by zhangzb on 26/05/2017.
//  Copyright © 2017 zhangzb. All rights reserved.
//

#import "ZBTableView.h"
@interface ZBTableView()
{
    
    UIView *_noMessageView;/** 提示的View */
    UIImageView *_tipImageView;/** 提示图片 */
    UILabel *_tipLabel;/** 提示语 */
}
/** 网络异常，数据为空的提示View */
@property (nonatomic, strong) UIView *tipView;

/** 点击回调 */
@property (nonatomic,copy) tipClick tipClickCall;

@property (nonatomic,assign) BOOL showEmptyView;//是否提示空数据
@property (nonatomic, copy) NSString *emptyTipString;     // 空提示文字
@property (nonatomic, copy) NSString *emptyTipImageName;  // 空提示图片

@property (nonatomic,assign) BOOL showErrorView;//是否提示网络异常
@property (nonatomic, copy) NSString *errorTipString;     // 网络提示文字
@property (nonatomic, copy) NSString *errorTipImageName;  // 网络提示图片


@end



@implementation ZBTableView
#pragma mark ——— 重写API方法
/** 重现reloadData方法，在数据为空的时候进行判断，显示view */
-(void)reloadData{
    /** 先默认隐藏提示的View */
    self.tipView.hidden = YES;
    /** 父类的实现 */
    [super reloadData];
    /** 添加自己的处理，判断为空状态和网络异常状态 */
    if (self.showEmptyView){// 显示空数据提示
        NSInteger count = 0;
        /** 遍历每一个Section，统计cell总数 */
        for (NSInteger i=0; i<[self numberOfSections]; i++) {
            count +=[self numberOfRowsInSection:i];
        }
        /** 如果数据为空，则显示提示信息 */
        if (!count) {
            self.tipView.hidden = NO;
            _tipLabel.text = self.emptyTipString;/** 显示提示语 */
            _tipImageView.image = [UIImage imageNamed:self.emptyTipImageName]; /** 显示提示图片 */
        }else{
            self.tipView.hidden = YES;
        }
    }
    if (self.showErrorView) {//判断是否要显示网络异常信息
        /** 如果要显示网络异常的信息，先判断网络状态，如果是网络异常，在修改显示的提示语和图片 */
        if(![kAppDelegate isNormalConnection]){
            _tipLabel.text = self.errorTipString;/** 网络异常的提示语 */
            _tipImageView.image = [UIImage imageNamed:self.errorTipImageName];/** 网络异常的图片 */
        }
        
    }
 
    
}

#pragma mark ——— 视图的懒加载
/** 提示图的懒加载方法 */
-(UIView *)tipView{
    if (!_tipView) {
        CGRect frame = self.bounds;
        /** 显示的图片 */
        UIImage* image = [UIImage imageNamed:self.emptyTipImageName];
        _tipView = [[UIView alloc] initWithFrame:frame];
        _tipView.backgroundColor = [UIColor clearColor];
        
        /** 居中显示图片 */
        _tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, (frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        [_tipImageView setImage:image];
        [_tipView addSubview:_tipImageView];
        
        /** 添加提示语，这里高度写死了20，有待优化 */
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipImageView.frame)+10, frame.size.width, 20)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor lightGrayColor];
        /** 提示语 */
        _tipLabel.text = self.emptyTipString;
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        [_tipView addSubview:_tipLabel];
        [self  addSubview:_tipView];
        
        /** 添加点击手势，用于做点击事件的回调  tipClickAction*/
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipClickAction)];
        [_tipView addGestureRecognizer:tap];
        
    }
    return _tipView;
}

#pragma mark ——— 点击事件处理
/** 点击手势 调用回调 */
-(void)tipClickAction{
    if (self.tipClickCall) {
        self.tipClickCall();
    }
}


#pragma mark ——— 新增两个对象方法

/**
 tableView 数据为空提示
 
 @param imageName  提示图片
 @param title 提示文字
 @param call 点击刷新  不需要刷新 传 nil
 */
-(void)addViewWithWarnImage:(NSString*)imageName title:(NSString*)title action:(tipClick)call
{
    /** 显示的提示语 */
    self.emptyTipString = title;
    /** 显示的提示图片 */
    self.emptyTipImageName = imageName;
    /** 显示数据为空图片 */
    self.showEmptyView = YES;
    /** 点击回调 */
    self.tipClickCall = call;
}



/**
 tableView 数据为空提示 + 网路异常默认提示
 
 @param imageName 提示图片名字
 @param title 提示文字
 @param isError 是否提示网络异常
 @param call 点击刷新  不需要刷新 传 nil
 */

-(void)addViewWithWarnImage:(NSString*)imageName title:(NSString*)title whetherNetWorkError:(BOOL)isError  action:(tipClick)call{
    /** 显示提示view */
    [self addViewWithWarnImage:imageName title:title action:call];
    self.showErrorView = isError;
    /** 是否显示网络异常图片 */
    if (isError) {/** 设置要显示的信息 */
        self.errorTipString = NETERR;/** 网络异常提示语 */
        self.errorTipImageName = @"";/** 网络异常占位图 */
    }
}








@end
