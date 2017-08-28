//
//  HummingListController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/28.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HummingListController.h"
#import "HummingModel.h"
#import "HummingSongViewCell.h"

@interface HummingListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *firstSongBackView;
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *hummingSongTabel;

@end

@implementation HummingListController
#pragma mark - **************** UI初始化
-(void)setBaseUI{
    //nav
    [self.navigationItem setTitle:@"识别列表"];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:TITLE_FONT,NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSLog(@"humming data %@",self.hummingArray);
    //firt view
    
    //tableview
    
    
    

}

#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hummingArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
