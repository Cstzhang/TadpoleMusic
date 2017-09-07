//
//  SongCardView.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongList;
@interface SongCardView : UIView
/** 歌曲数据 */
@property (nonatomic,strong) SongList * model;
/** 当前index */
@property (nonatomic,assign) NSInteger  index;
/** 歌曲url */
@property (nonatomic,strong) NSMutableDictionary * headUrlDic;
/** 平台数组 */
@property (nonatomic,strong) NSMutableDictionary * platformDoc;
@end
