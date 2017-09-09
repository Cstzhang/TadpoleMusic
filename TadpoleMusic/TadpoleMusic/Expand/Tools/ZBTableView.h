//
//  ZBTableView.h
//  TadpoleMusic
//
//  Created by zhangzb on 26/05/2017.
//  Copyright © 2017 zhangzb. All rights reserved.
//  继承原有的UITableView 添加新的方法

#import <UIKit/UIKit.h>
/** block用于点击回调：点击刷新之类的 */
typedef void(^tipClick)(void);

@interface ZBTableView : UITableView

/**
 tableView 数据为空提示
 
 @param imageName  提示图片
 @param title 提示文字
 @param call 点击刷新  不需要刷新 传 nil
 */
-(void)addViewWithWarnImage:(NSString*)imageName title:(NSString*)title action:(tipClick)call;


/**
 tableView 数据为空提示 + 网路异常默认提示
 
 @param imageName 提示图片名字
 @param title 提示文字
 @param isError 是否提示网络异常
 @param call 点击刷新  不需要刷新 传 nil
 */
-(void)addViewWithWarnImage:(NSString*)imageName title:(NSString*)title whetherNetWorkError:(BOOL)isError  action:(tipClick)call;



@end
