//
//  HummingListController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/28.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HummingListController.h"
#import "HummingModel.h"
@interface HummingListController ()

@end

@implementation HummingListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"识别列表"];
    NSLog(@"humming data %@",self.hummingArray);
}

@end
