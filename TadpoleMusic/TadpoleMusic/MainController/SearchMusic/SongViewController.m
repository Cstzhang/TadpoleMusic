//
//  SongViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/24.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SongViewController.h"
#import "SearchHandle.h"
#import "SearchModel.h"
@interface SongViewController ()
/** 注释 */
@property (nonatomic,strong) NSMutableArray * searchArray;
@end

@implementation SongViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.searchArray = [NSMutableArray arrayWithArray:[SearchHandle searchMusicInBD:self.songName]];
    NSLog(@"self.searchArray %@",self.searchArray);
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击返回
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
