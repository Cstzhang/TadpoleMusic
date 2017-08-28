//
//  PlatformViewCell.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/27.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformViewCell : UICollectionViewCell
/**
 *  平台icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *platformImage;
/**
 *  平台名称
 */
@property (weak, nonatomic) IBOutlet UILabel *platformName;
@end
