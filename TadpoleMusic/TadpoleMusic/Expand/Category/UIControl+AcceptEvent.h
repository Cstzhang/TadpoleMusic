//
//  UIControl+AcceptEvent.h
//  HXyxb
//
//  Created by 恒信永利 on 2017/6/2.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  uicontrol分类，替换点击事件方法，限制短时间内不能连续点击

#import <UIKit/UIKit.h>

@interface UIControl (AcceptEvent)

/** 这里添加了属性，里面实现了set get 方法 */
@property (nonatomic, assign) NSTimeInterval acceptEventTime;// 响应点击的时间记录
@property (nonatomic, assign) NSTimeInterval acceptEventInterval; // 重复点击的间隔

@end
