//
//  SetCell.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *setName;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@end
