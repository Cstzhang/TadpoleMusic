//
//  SearchMusicViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/15.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  音乐搜索结果的view

#import "SearchMusicViewController.h"
#import "SearchHandle.h"
@interface SearchMusicViewController ()

@end

@implementation SearchMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor yellowColor];
     [SearchHandle searchMusicInBD:self.songName];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     //点击返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
