//
//  HummingSongViewCell.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/28.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HummingSongViewCell : UITableViewCell
/**
 *  歌曲图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
/**
 *  歌曲名称
 */
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
/**
 *  歌曲专辑名
 */
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
/**
 *  歌曲作者
 */
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
/**
 *  歌曲识别度
 */
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
/**
 *  歌曲查找按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end
