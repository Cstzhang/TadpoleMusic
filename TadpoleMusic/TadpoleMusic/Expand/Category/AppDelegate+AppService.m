//
//  AppDelegate+AppService.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/9.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  

#import "AppDelegate+AppService.h"

@implementation AppDelegate (AppService)


/**
 *  网络监测
 */
- (void)startNetworkMonitoring{
    /** 初始化网络状态为异常 */
    self.netConnection=NO;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络异常");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"网络正常");
            self.netConnection=YES;
        }else
        {
            NSLog(@"失去网络连接");
            self.netConnection=NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络失去连接，请检查网络" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:actionConfirm];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
            
            
        }
    }];
    
    
}

/**
 *  Bug收集
 */
- (void)startBugly{
    [Bugly startWithAppId:@"076a4256bf"];

};

-(void)firstStart{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"statusSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"第一次启动");
    }else{
        NSLog(@"不是第一次启动");
    }

}

@end
