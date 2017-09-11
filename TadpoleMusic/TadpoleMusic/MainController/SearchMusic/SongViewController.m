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
#import "DBHander.h"
#import "SongList+CoreDataClass.h"
#import "DGActivityIndicatorView.h"
@interface SongViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
#pragma mark - **************** UI部分
/** 歌曲名字 */
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *clollectBtn;

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
@property (weak, nonatomic) IBOutlet UIView *songBackView;

/** <#注释#> */
@property (nonatomic,strong) DGActivityIndicatorView * activityIndicatorView;

#pragma mark - **************** 数据部分

/** 平台数组 */
@property (nonatomic,strong) NSMutableDictionary * searchDic;

/** 平台数组 */
@property (nonatomic,strong) NSMutableArray * songPlatform;


//声明AppDelegate对象属性，用于调用类中属性，管理存储上下文
@property(nonatomic,strong)DBHander *dbHander;

/** 头部 */
@property (nonatomic,copy) NSString *headUrl;
@end

@implementation SongViewController
#pragma mark - **************** 懒加载
-(DGActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[DGActivityIndicatorView alloc]
                                  initWithType:DGActivityIndicatorAnimationTypeRotatingSquares
                                  tintColor:[UIColor whiteColor]
                                  size:40.0f];
        
        CGFloat width = 80.0f;
        CGFloat height = 80.0f;
        _activityIndicatorView.frame = CGRectMake(SCREEN_WIDTH/2-40.0f, SCREEN_HEIGHT-150.0f, width, height);
    }
    return _activityIndicatorView;

}
//搜索结果
-(NSMutableDictionary *)searchDic{
    if (!_searchDic) {
        _searchDic= [[NSMutableDictionary alloc]init];
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

#pragma mark - **************** -初始化
-(void)setBaseUI{
    //初始化 myAppDelegate
    self.dbHander = [[DBHander alloc]init];
    //背景
    UIImage *backGroundImage=[UIImage imageNamed:@"bg"];
    self.view.contentMode=UIViewContentModeScaleAspectFill;
    self.view.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    self.platformCollectionView.delegate = self;
    self.platformCollectionView.dataSource= self;
    //注册cell
    [self.platformCollectionView registerNib:[UINib nibWithNibName:@"PlatformViewCell" bundle:nil]forCellWithReuseIdentifier:@"PlatformViewCell"];
    //设置背景卡片圆角
    self.songBackView.layer.cornerRadius = 8;
    self.songBackView.layer.masksToBounds = YES;
    //头像圆角
    self.artistImage.layer.masksToBounds =YES;
    self.artistImage.layer.cornerRadius =self.artistImage.bounds.size.height/2;
    self.artistImage.layer.borderWidth=1;
    self.artistImage.layer.borderColor=[UIColor whiteColor].CGColor;
    //设置边框及边框颜色
    self.songBackView.layer.borderWidth = 8;
    self.songBackView.layer.borderColor =[ [UIColor clearColor] CGColor];
    //收藏按钮
    [self.clollectBtn setImage:[UIImage imageNamed:@"collect_unselect"] forState:UIControlStateNormal];
    [self.clollectBtn setImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateSelected];
    //字体适配
    [self.songNameLabel setFont:[UIFont systemFontOfSize:17]];
    [self.artistLabel setFont:[UIFont systemFontOfSize:17]];
    [self.albumLabel setFont:[UIFont systemFontOfSize:17]];
    [self.companyLabel setFont:[UIFont systemFontOfSize:10]];
    [self.releaseTimeLabel setFont:[UIFont systemFontOfSize:10]];
    [self.searchScoreLabel setFont:[UIFont systemFontOfSize:10]];
    //指示器
    [self.view addSubview:self.activityIndicatorView];

   
}

-(void)setBaseData{
    if (self.songModel != nil) {
        NSLog(@"[NSThread currentThread] %@",[NSThread currentThread]);
        [self.songNameLabel setValue:self.songModel.title forKey:@"text"];
        self.artistLabel.text= [NSString stringWithFormat:@"作者：%@",self.songModel.artist];
        self.albumLabel.text=[NSString stringWithFormat:@"《%@》",self.songModel.album];
        self.companyLabel.text=[NSString stringWithFormat:@"发行方:%@",self.songModel.label];
        self.releaseTimeLabel.text=[NSString stringWithFormat:@"发行时间:%@",self.songModel.release_date];
        if (self.searchType==1) {
            int  score = (int)self.songModel.score.floatValue*100;
            self.searchScoreLabel.text=[NSString stringWithFormat:@"识别度：%d%@",score,@"%"];
        }else{
            self.searchScoreLabel.text=[NSString stringWithFormat:@"识别度：%d%@",self.songModel.score.intValue,@"%"];
        }
         self.clollectBtn.selected = [self.dbHander isFollowed:self.songModel.title artist:self.songModel.artist];
    }else{
        if (self.songList!=nil) {
            [self.songNameLabel setValue: self.songList.title forKey:@"text"];
            self.artistLabel.text= [NSString stringWithFormat:@"作者：%@",self.songList.artist];
            self.albumLabel.text=[NSString stringWithFormat:@"《%@》",self.songList.album];
            self.companyLabel.text=[NSString stringWithFormat:@"发行方:%@",self.songList.label];
            self.releaseTimeLabel.text=[NSString stringWithFormat:@"发行时间:%@",self.songList.release_date];
            self.searchScoreLabel.text = [NSString stringWithFormat:@"识别度：%.0f%@",self.songList.score,@"%"];
            self.headUrl =self.songList.attr1;
             self.clollectBtn.selected = [self.dbHander isFollowed:self.songList.title artist:self.songList.artist];
        }else{
           [self.songNameLabel setValue: self.searchKey forKey:@"text"];
            self.artistLabel.text= [NSString stringWithFormat:@"作者：%@",@"无"];
            self.albumLabel.text=[NSString stringWithFormat:@"《%@》",@"无"];
        
        }
    
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseUI];
    [self setBaseData];
    [self searchMusciInfo];
    
    
}

-(void)searchMusciInfo{
    NSString *key =@"";
    NSString *songNmae =@"";
    if (self.songModel!=nil) {
         key = [NSString stringWithFormat:@"%@+%@",self.songModel.title,self.songModel.artist];
        songNmae=self.songModel.title;
    }
    if (self.songList!=nil) {
        key = [NSString stringWithFormat:@"%@+%@",self.songList.title,self.songList.artist];
        songNmae=self.songList.title;
    }
    if (self.searchKey!=nil) {
        key= self.searchKey;
        songNmae=self.searchKey;
    }
    
    NSLog(@"key %@",key);
    [self showTip];
    //主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //在线搜索歌曲平台信息
        self.searchDic = [SearchHandle searchMusicInBD:key];
        self.songPlatform = [NSMutableArray arrayWithArray:self.searchDic[@"musicPlatform"]];
        if (self.songPlatform.count != 0 ) {
    
            dispatch_async(mainQueue, ^{
                //更新头部信息
                [self showHeadview];
                //更新平台信息
                [self hiddenTip];
                [self.platformCollectionView reloadData];
            });
        }else{
            NSLog(@"没有歌曲的平台信息");
            //再搜索一次
            dispatch_async(mainQueue, ^{
              [self tryOtherKey:songNmae];
            });
        }
       
    });
}

-(void)tryOtherKey:(NSString *)key{
    NSLog(@"key %@",key);
    //主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //在线搜索歌曲平台信息
        self.searchDic = [SearchHandle searchMusicInBD:key];
        dispatch_async(mainQueue, ^{
            //更新头部信息
            [self showHeadview];
            //更新平台信息
            self.songPlatform = [NSMutableArray arrayWithArray:self.searchDic[@"musicPlatform"]];
            [self hiddenTip];
            if (self.songPlatform.count != 0 ) {
                [self.platformCollectionView reloadData];
            }else{
                NSLog(@"没有歌曲的平台信息");
                [MsgTool showMsg:@"该歌曲没有支持的播放平台"];
            }
        });
    });


}



-(void)showHeadview{
   
    if (![self.headUrl isEqualToString:[self.searchDic valueForKey:@"songImageUrl"]]) {
         self.headUrl = [self.searchDic valueForKey:@"songImageUrl"];
    }
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
- (IBAction)clickClose:(id)sender {
     NSLog(@"点击关闭");
    //点击返回
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//点击收藏
- (IBAction)clickCollect:(id)sender {
    NSLog(@"点击收藏");
    if (self.songModel!=nil) {
        if (!self.clollectBtn.selected) {//关注
            [self.dbHander followFun:self.songModel headUrl:self.headUrl];
            
        }else{//取消关注
            [self.dbHander unfollowSongWithTitle:self.songModel.title artist:self.songModel.artist isFollw:0];
        }

    }else if(self.songList!=nil){
        
        if (!self.clollectBtn.selected) {//关注
           [self.dbHander unfollowSongWithTitle:self.songList.title artist:self.songList.artist isFollw:1];
        }else{//取消关注
            
            [self.dbHander unfollowSongWithTitle:self.songList.title artist:self.songList.artist isFollw:0];
        }
        
    
    
    }else{
        if (!self.clollectBtn.selected) {//关注
            SongModel * model = [[SongModel alloc]init];
            model.title =self.searchKey;
            model.artist= self.searchKey;
            model.album = @"无";
            model.label=@"无";
            model.release_date=@"无";
            [self.dbHander followFun:model headUrl:self.headUrl];
        }else{//取消关注
            
            [self.dbHander unfollowSongWithTitle:self.searchKey artist:self.searchKey isFollw:0];
        }
        
    
    }
     //修改按钮显示状态
    self.clollectBtn.selected =!self.clollectBtn.selected;
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
        SearchModel * model = self.songPlatform[indexPath.row];
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


-(void)showTip{
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView startAnimating];

}
-(void)hiddenTip{
    _activityIndicatorView.hidden = YES;
    [_activityIndicatorView stopAnimating];
    
}





@end
