//
//  SetCell.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.statusSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"statusSwitch"] animated:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickSwitch:(UISwitch *)sender {
    NSLog(@"%@", sender.isOn ? @"ON" : @"OFF");
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"statusSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
