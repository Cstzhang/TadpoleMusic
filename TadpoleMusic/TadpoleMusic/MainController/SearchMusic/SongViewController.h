//
//  SongViewController.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/24.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongModel;
@interface SongViewController : UIViewController
/** 搜索到的歌曲模型 */
@property (nonatomic,strong) SongModel * songModel;
@end
