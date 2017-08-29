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
#import "SongModel.h"
#import "SongViewController.h"

@interface HummingListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *firstSongBackView;
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UITableView *hummingSongTabelView;

@end

@implementation HummingListController
#pragma mark - **************** 懒加载
-(NSMutableArray *)hummingArray{
    if (!_hummingArray) {
        _hummingArray = [NSMutableArray array];
    }
    return _hummingArray;
}

#pragma mark - **************** UI初始化

-(void)setBaseUI{
    //nav
    [self.navigationItem setTitle:@"识别列表"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:TITLE_FONT,NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSLog(@"humming data %@",self.hummingArray);
    //first view
    self.firstSongBackView.layer.cornerRadius = 8;
    self.firstSongBackView.layer.masksToBounds = YES;
    UIImage *backGroundImage=[UIImage imageNamed:@"bg1"];
    self.firstSongBackView.contentMode=UIViewContentModeScaleAspectFill;
    self.firstSongBackView.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.firstSongBackView addGestureRecognizer:singleTap];
    //tableview
    [self.hummingSongTabelView registerNib:[UINib nibWithNibName:@"HummingSongViewCell" bundle:nil] forCellReuseIdentifier:@"HummingSongViewCell"];
    self.hummingSongTabelView.delegate = self;
    self.hummingSongTabelView.dataSource = self;
    self.hummingSongTabelView.bounces = NO;
    self.hummingSongTabelView.tableFooterView = [UIView new];
    if (self.hummingArray.count!=0) {
        HummingModel *model = self.hummingArray[0];
         //firt view
        self.songName.text = model.title;
        self.albumLabel.text = [NSString stringWithFormat:@"《%@》",model.album];
        self.artistLabel.text = [NSString stringWithFormat:@"作者：%@",model.artist];
        int score = (int)(model.score.floatValue*100);
        self.scoreLabel.text = [NSString stringWithFormat:@"识别度：%d/100",score];
         [self.hummingSongTabelView reloadData];
    }
    
    
    
}

#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseUI];
}



#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hummingArray.count-1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HummingSongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HummingSongViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HummingSongViewCell" owner:nil options:nil][0];
    }
    if (self.hummingArray.count!=0) {
        HummingModel *model = self.hummingArray[indexPath.row+1];
        cell.songNameLabel.text = model.title;
        cell.albumLabel.text = [NSString stringWithFormat:@"《%@》",model.album];
        cell.artistLabel.text = [NSString stringWithFormat:@"作者：%@",model.artist];
        int score = (int)(model.score.floatValue*100);
        cell.scoreLabel.text = [NSString stringWithFormat:@"识别度：%d/100",score];

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath %ld",(long)indexPath.row);
    HummingModel *hummingModel = self.hummingArray[indexPath.row+1];
    SongViewController *searchVC = [[SongViewController alloc]init];
    searchVC.songModel =[self changeModelWithHummingData:hummingModel];
    searchVC.searchType = 1;
    [self presentViewController:searchVC animated:YES completion:nil];
    
    
    
}

-(void)handleSingleTap{
    HummingModel *hummingModel = self.hummingArray[0];
    SongViewController *searchVC = [[SongViewController alloc]init];
    searchVC.songModel =[self changeModelWithHummingData:hummingModel];
    searchVC.searchType = 1;
    [self presentViewController:searchVC animated:YES completion:nil];
    NSLog(@"点击了第一首歌曲");
}

-(SongModel *)changeModelWithHummingData:(HummingModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:model.score forKey:@"score"];
    
    [dic setValue:model.title forKey:@"title"];
    
    NSMutableDictionary *albumDic = [NSMutableDictionary dictionary];
    [albumDic setValue:model.album forKey:@"name"];
    [dic setValue:albumDic forKey:@"album"];
    
    NSMutableDictionary *artistsDic = [NSMutableDictionary dictionary];
    [artistsDic setValue:model.artist forKey:@"name"];
    NSMutableArray *artistsArray =[NSMutableArray array];
    [artistsArray addObject:artistsDic];
    [dic setValue:artistsArray forKey:@"artists"];
    
    NSMutableDictionary *modelDoc = [NSMutableDictionary dictionary];
    NSMutableArray *modelArray =[NSMutableArray array];
    [modelArray addObject:dic];
    [modelDoc setValue:modelArray forKey:@"metadata.music"];
    
    SongModel *songMode =  [SongModel musicInfoWithDict:modelDoc];

    return songMode;
}

@end
