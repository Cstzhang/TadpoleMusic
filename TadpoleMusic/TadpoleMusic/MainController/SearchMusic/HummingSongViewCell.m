//
//  HummingSongViewCell.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/28.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HummingSongViewCell.h"

@implementation HummingSongViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self.songNameLabel setFont:[UIFont systemFontOfSize:15]];
    [self.albumLabel setFont:[UIFont systemFontOfSize:12]];
    [self.artistLabel setFont:[UIFont systemFontOfSize:12]];
    [self.scoreLabel setFont:[UIFont systemFontOfSize:8]];
    int index = arc4random_uniform(4);
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd",@"music_",index+1]];
    self.songImage.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
