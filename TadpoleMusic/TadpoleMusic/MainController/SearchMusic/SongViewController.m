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
#import "PlatformViewCell.h"
@interface SongViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
/** 各个平台View */
@property (weak, nonatomic) IBOutlet UICollectionView *platformCollectionView;

#pragma mark - **************** 数据部分

/** 平台数组 */
@property (nonatomic,strong) NSMutableArray * searchArray;


@end

@implementation SongViewController
#pragma mark - **************** 懒加载
-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray= [[NSMutableArray alloc]init];
    }
    return  _searchArray;
}


#pragma mark - **************** -初始化
-(void)setBaseUI{
    UIImage *backGroundImage=[UIImage imageNamed:@"bg"];
    self.view.contentMode=UIViewContentModeScaleAspectFill;
    self.view.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    self.platformCollectionView.delegate = self;
    self.platformCollectionView.dataSource= self;
    //注册cell
    [self.platformCollectionView registerNib:[UINib nibWithNibName:@"PlatformViewCell" bundle:nil]forCellWithReuseIdentifier:@"PlatformViewCell"];
}

-(void)setBaseData{
    if (self.songModel != nil) {
        NSLog(@"[NSThread currentThread] %@",[NSThread currentThread]);
        [self.songNameLabel setValue:self.songModel.title forKey:@"text"];
        self.artistLabel.text=self.songModel.artist;
        self.albumLabel.text=self.songModel.album;
        self.companyLabel.text=[NSString stringWithFormat:@"发行方:%@",self.songModel.label];
        self.releaseTimeLabel.text=[NSString stringWithFormat:@"发行时间:%@",self.songModel.release_date];
        self.searchScoreLabel.text=[NSString stringWithFormat:@"识别度:%@/100",self.songModel.score];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseUI];
    [self setBaseData];
    [self searchMusciInfo];
    
}

-(void)searchMusciInfo{
   
    self.searchArray = [SearchHandle searchMusicInBD:self.songModel.title];
    if (self.searchArray.count != 0 ) {
        NSLog(@" self.searchArray %@", self.searchArray);
        [self showPlatformData];
    }else{
        NSLog(@"没有歌曲的平台信息");
    }
    
  

}


-(void)showPlatformData{
    
    SearchModel * model = self.searchArray[0];
    NSURL *imgUrl = [NSURL URLWithString:model.songImageUrl ];
    [self.artistImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.platformCollectionView reloadData];
}

- (IBAction)clickCloseBtn:(id)sender {
    //点击返回
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - **************** collectionView

// numberOfItemsInSection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

//cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建 PhotoCollectionViewCell 创建cell的时候与cell对应的presenter 也创建了
    PlatformViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlatformViewCell" forIndexPath:indexPath];
    if (self.searchArray.count!=0) {
        SearchModel * model = self.searchArray[indexPath.row];
        cell.platformName.text = model.musicPlatform;
        cell.platformImage.image = [UIImage imageNamed:model.musicPlatform];
    }
    //赋值数据
    return cell;
}

//sizeForItemAtIndexPath
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetHeight(self.platformCollectionView.bounds), CGRectGetHeight(self.platformCollectionView.bounds));
}

//didSelectItemAtIndexPath 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel * model = self.searchArray[indexPath.row];
    NSURL *songUrl = [NSURL URLWithString:model.songUrl];
    NSLog(@"你点击了我 %ld %@",(long)indexPath.row,songUrl);
    [[UIApplication sharedApplication] openURL:songUrl];
    
}


@end
