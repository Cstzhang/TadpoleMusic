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
#import "SongModel.h"
@interface SongViewController ()
#pragma mark - **************** UI部分
/** 歌曲名字 */
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
/** 关闭返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/** 背景图 */
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
/** 艺术家头像像 */
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
/** 艺术家名字 */
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
/** 专辑名字 */
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
/** 发行公司 */
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
/** 不发时间 */
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
/** 识别相识度 */
@property (weak, nonatomic) IBOutlet UILabel *searchScoreLabel;
/** 各个平台ScrollView */
@property (weak, nonatomic) IBOutlet UIScrollView *platformScrollView;

#pragma mark - **************** 数据部分

/** 平台数组 */
@property (nonatomic,strong) NSMutableArray * searchArray;


@end

@implementation SongViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backGroundImage=[UIImage imageNamed:@"bg"];
    self.view.contentMode=UIViewContentModeScaleAspectFill;
    self.view.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击返回
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickCloseBtn:(id)sender {
}



@end
