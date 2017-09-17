//
//  SetViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 设置*/
@property (nonatomic,strong) UITableView *setTableView;

@end

@implementation SetViewController
#pragma mark - **************** 懒加载
/** 客户列表
 */
-(UITableView *)mySongTableView{
    //    kWeakSelf(self);
    if (!_setTableView) {
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _setTableView.backgroundColor=WHITE_COLOR;
        _setTableView.delegate=self;
        _setTableView.dataSource=self;
        _setTableView.scrollEnabled = NO;
        _setTableView.tableFooterView = [UIView new];
        [_setTableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetCell"];
    }
    return _setTableView;
}


#pragma mark - **************** 初始化
-(void)baseUI{
    //头部
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    [self.view addSubview:headView];
    //返回按钮
    UIButton *leftbtn =[[UIButton alloc]init];
    [leftbtn setImage:[UIImage imageNamed:@"back_arrow"] forState:0];
    [leftbtn addTarget:self action:@selector(leftbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftbtn];
    [leftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.left).offset(15);
        make.centerY.equalTo(headView.centerY);
    }];
    
    UILabel *titleLabel =[[UILabel alloc]init];
    [titleLabel setText:@"设置"];
    titleLabel.font = TITLE_FONT;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.centerX);
        make.centerY.equalTo(headView.centerY);
    }];
    //title
    [self.view addSubview:self.mySongTableView];
}

#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUI];
}


#pragma mark - **************** 交互
//返回
- (void)leftbtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (int)RATIO_H(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SetCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.nextBtn.hidden=YES;
            cell.statusSwitch.hidden=NO;
            cell.setName.text = @"启动时自动搜索音乐";
            break;
        case 1:
            cell.nextBtn.hidden=NO;
            cell.statusSwitch.hidden=YES;
            cell.setName.text = @"帮助与反馈";
            break;
        case 2:
            cell.nextBtn.hidden=NO;
            cell.statusSwitch.hidden=YES;
            cell.setName.text = @"去评价";
            break;

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:

            break;
        case 1:
            [self opebScheme:@"http://www.jianshu.com/p/12d910ade2e4"];
            break;
        case 2:
            [self opebScheme:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1281257029"]];
            break;
            
    }
}

//打开浏览器
-(void)opebScheme:(NSString *)scheme{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URl = [NSURL URLWithString:scheme];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URl options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@   success:%d",scheme,success);
        }];
        
    }else{
        BOOL success = [application openURL:URl];
        NSLog(@"Open %@  success:%d",scheme,success);
    }
    
}

@end
