//
//  ZBNavigationBar.m
//  TadpoleMusic
//
//  Created by Mzhangzb on 2018/2/5.
//  Copyright © 2018年 zhangzb. All rights reserved.
//

#import "ZBNavigationBar.h"

@implementation ZBNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        NSString* subViewClassName = NSStringFromClass([subview class]);
        if ([subViewClassName containsString:@"UIBarBackground"]) {
            subview.frame = self.bounds;
        }else if ([subViewClassName containsString:@"UINavigationBarContentView"]) {
            subview.frame = CGRectMake(0.0, 20.0, subview.frame.size.width, 44.0);
        }
    }
}

@end
