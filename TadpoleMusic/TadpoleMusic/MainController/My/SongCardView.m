//
//  SongCardView.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SongCardView.h"
#import "PlatformViewCell.h"
#import "SongList+CoreDataClass.h"
#import "SearchHandle.h"
#import "SearchModel.h"
#import "DBHander.h"

@interface SongCardView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *clollectBtn;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchScoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *platformCollectionView;

/** <#注释#> */
@property (nonatomic,strong) SearchModel * searchModel;

//声明AppDelegate对象属性，用于调用类中属性，管理存储上下文
@property(nonatomic,strong)DBHander *dbHander;
/** 平台数组 */
@property (nonatomic,strong) NSMutableDictionary * searchDic;

/** 平台数组 */
@property (nonatomic,strong) NSMutableArray * songPlatform;

@end

@implementation SongCardView

-(NSMutableDictionary *)platformDoc{
    if (!_platformDoc) {
        _platformDoc = [NSMutableDictionary dictionary];
    }
    return _platformDoc;
}

-(NSMutableDictionary *)headUrlDic{
    if (!_headUrlDic) {
        _headUrlDic = [NSMutableDictionary dictionary];
    }
    return _headUrlDic;
}
//搜索结果
-(NSMutableDictionary *)searchDic{
    if (!_searchDic) {
        _searchDic= [[NSMutableDictionary alloc]init];
        //====初始化 myAppDelegate
        self.dbHander = [[DBHander alloc]init];
    }
    return  _searchDic;
}
//平台数组
-(NSMutableArray *)songPlatform{
    if (!_songPlatform) {
        _songPlatform= [[NSMutableArray alloc]init];
    }
    return  _songPlatform;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //初始化
        self=[[[NSBundle mainBundle]loadNibNamed:@"SongCardView" owner:self options:nil] lastObject];
        //背景
        UIImage *backGroundImage2=[UIImage imageNamed:@"bg2"];
        self.backGroundView.contentMode=UIViewContentModeScaleAspectFill;
        self.backGroundView.layer.contents=(__bridge id _Nullable)(backGroundImage2.CGImage);
        self.platformCollectionView.delegate = self;
        self.platformCollectionView.dataSource= self;
        //注册cell
        [self.platformCollectionView registerNib:[UINib nibWithNibName:@"PlatformViewCell" bundle:nil]forCellWithReuseIdentifier:@"PlatformViewCell"];
        //设置背景卡片圆角
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        //头像圆角
        self.artistImage.layer.masksToBounds =YES;
        self.artistImage.layer.cornerRadius =self.artistImage.bounds.size.height/2;
        self.artistImage.layer.borderWidth=1;
        self.artistImage.layer.borderColor=[UIColor whiteColor].CGColor;
        //设置边框及边框颜色
        self.layer.borderWidth = 8;
        self.layer.borderColor =[ [UIColor clearColor] CGColor];
        //收藏按钮
        [self.clollectBtn setImage:[UIImage imageNamed:@"collect_unselect"] forState:UIControlStateNormal];
        [self.clollectBtn setImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateSelected];

    }
    return self;
}




-(void)setModel:(SongList *)model{
    _model=model;
    NSLog(@"设置了一次数据");
    //初始化数据
    [self.songNameLabel setValue:_model.title forKey:@"text"];
    self.artistLabel.text=_model.artist;
    self.albumLabel.text=_model.album;
    self.companyLabel.text=[NSString stringWithFormat:@"发行方:%@",_model.label];
    self.releaseTimeLabel.text=[NSString stringWithFormat:@"发行时间:%@",_model.release_date];
    self.searchScoreLabel.text=[NSString stringWithFormat:@"识别度：%.0f/100",_model.score];
    NSString *key = [NSString stringWithFormat:@"%@+%@",self.model.title,self.model.artist];
    //内存中有图片信息，则不需要再次请求
    if (!kObjectIsEmpty(self.headUrlDic[key])) {
        NSString *head =self.headUrlDic[key];
        [self.artistImage sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    };
    //如果内存中还有平台信息，则显示
    if (!kObjectIsEmpty(self.platformDoc[key])) {
        NSArray * arr =  [self.platformDoc objectForKey:key];
        self.songPlatform = [NSMutableArray arrayWithArray:arr];
        if (self.songPlatform.count != 0 ) {
            [self.platformCollectionView reloadData];
        }else{
            NSLog(@"没有歌曲的平台信息");
        }
    }else{//内存中没有平台信息 则请求获取
        //搜索歌曲平台
        [self searchMusciInfo];
    }
    //收藏按钮样式
    self.clollectBtn.selected = [ self.dbHander isFollowed:_model.label artist:_model.artist];
}


- (IBAction)clickFollow:(id)sender {
    NSLog(@"点击了收藏");
    
    
}


-(void)searchMusciInfo{
    NSString *key = [NSString stringWithFormat:@"%@+%@",self.model.title,self.model.artist];
    
    //主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(globalQueue, ^{
        
    self.searchDic = [SearchHandle searchMusicInBD:key];
    dispatch_async(mainQueue, ^{
        //如果还没有请求过头像，则请求一次
        if (kObjectIsEmpty(self.headUrlDic[key])) {
            [self.headUrlDic setObject:[self.searchDic valueForKey:@"songImageUrl"] forKey:key];
            [self showHeadview];
        };
        //如果数组中还没有平台信息，则添加，显示
        if (kObjectIsEmpty(self.platformDoc[key]) && !kObjectIsEmpty(self.searchDic[@"musicPlatform"])) {
            [self.platformDoc setObject:self.searchDic[@"musicPlatform"] forKey:key];
            self.songPlatform = [NSMutableArray arrayWithArray:self.searchDic[@"musicPlatform"]];
            if (self.songPlatform.count != 0 ) {
                [self.platformCollectionView reloadData];
            }else{
                NSLog(@"没有歌曲的平台信息");
            }
        }else{

                NSLog(@"没有歌曲的平台信息");
        }
        
       
        });
    });
    

    
   
    
}

-(void)showHeadview{
    NSURL *imgUrl = [NSURL URLWithString:[self.searchDic valueForKey:@"songImageUrl"]];
    NSString * userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    [self.artistImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    
}

#pragma mark - **************** collectionView

// numberOfItemsInSection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.songPlatform.count;
}

//cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建 PhotoCollectionViewCell 创建cell的时候与cell对应的presenter 也创建了
    PlatformViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlatformViewCell" forIndexPath:indexPath];
    if (self.songPlatform.count!=0) {
        self.searchModel = self.songPlatform[indexPath.row];
        cell.platformName.text = self.searchModel.musicPlatform;
        cell.platformImage.image = [UIImage imageNamed:self.searchModel.musicPlatform];
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
    SearchModel * model = self.songPlatform[indexPath.row];
    [self opebScheme:model.songUrl];
    
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
