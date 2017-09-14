//
//  MyViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/8.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "MyViewController.h"
#import "SongList+CoreDataClass.h"
#import "HummingSongViewCell.h"
#import "DBHander.h"
#import "SongViewController.h"
#import "SongModel.h"
#import "SetViewController.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/**我的歌曲列表 */
@property (nonatomic,strong) ZBTableView *mySongTableView;
//声明AppDelegate对象属性，用于调用类中属性，管理存储上下文
@property(nonatomic,strong)DBHander *dbHander;
/** 歌曲数据库 */
@property (nonatomic,strong) NSMutableArray * songArr;
//当前页码
@property (nonatomic, assign) int curryPage;
/** 搜索 */
@property (nonatomic,strong) UISearchBar * searchBar;

@end

@implementation MyViewController
#pragma mark - **************** 懒加载
-(NSMutableArray *)songArr{
    if (!_songArr) {
        _songArr = [NSMutableArray array];
    }
    return _songArr;
}

/** 客户列表
 */
-(UITableView *)mySongTableView{
//    kWeakSelf(self);
    if (!_mySongTableView) {
        _mySongTableView=[[ZBTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEAD_TABBAR_HEIGHT)];
        _mySongTableView.backgroundColor=CLEAR_COLOR;
        _mySongTableView.delegate=self;
        _mySongTableView.dataSource=self;
        _mySongTableView.tableFooterView = [UIView new];
        [_mySongTableView registerNib:[UINib nibWithNibName:@"HummingSongViewCell" bundle:nil] forCellReuseIdentifier:@"songCell"];
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
        header.stateLabel.textColor = [UIColor whiteColor];
         header.lastUpdatedTimeLabel.hidden = YES;
        _mySongTableView.mj_header=header;
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
          footer.stateLabel.textColor = [UIColor whiteColor];
        _mySongTableView.mj_footer=footer;
        _mySongTableView.mj_footer.automaticallyHidden = YES;
        /** 添加默认的数据为空，网络异常提示 */
        [_mySongTableView addViewWithWarnImage:EMPTY_BACKGROUND_IMAGE title:@"还没有收藏歌曲,快去搜歌吧!" whetherNetWorkError:YES action:^{
            /** 点击重写加载 */
        }];
    }
    return _mySongTableView;
}

#pragma mark - **************** 基础UI
-(void)setBaseUI {
    /** 添加歌曲历史列表 */
    [self.view addSubview:self.mySongTableView];
    //头部
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //设置透明的背景图，
    [navigationBar setBackgroundImage:[ComFunc createImageWithColor:UIColorFromRGB(0x67f770)]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    //初始化页码 从0页开始，每页10条数据
    self.curryPage=0;
    [self getSongData];
    //设置按钮
    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBt.frame=CGRectMake(0, 0, 30, 30);
    [rightBt setImage:[UIImage imageNamed:@"ic_set"] forState:UIControlStateNormal];
    [rightBt addTarget:self action:@selector(setProfile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    //添加搜索按钮
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, CGRectGetMaxX(self.navigationController.navigationBar.frame)-70, 28)];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"btu_search"];
    self.searchBar.placeholder = @"网上搜索";
    self.searchBar.delegate = self;
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:searchButton];
  
    
    
}

#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置CGRectZero从导航栏下开始计算
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setBaseUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefresh) name:@"songDataChanged" object:nil];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - **************** 代理方法
#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (int)RATIO_H(75);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HummingSongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HummingSongViewCell" owner:nil options:nil][0];
    }
    if (self.songArr.count!=0) {
        SongList *model = self.songArr[indexPath.row];
        cell.songNameLabel.text = model.title;
        cell.albumLabel.text = [NSString stringWithFormat:@"《%@》",model.album];
        cell.artistLabel.text = [NSString stringWithFormat:@"作者：%@",model.artist];
        cell.scoreLabel.text = [NSString stringWithFormat:@"识别度：%.0f%@",model.score,@"%"];
        
        NSURL *imgUrl = [NSURL URLWithString:model.attr1];
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
        [cell.songImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SongViewController *cardVC = [[SongViewController alloc]init];
    cardVC.songList= self.songArr[indexPath.row];
    [cardVC setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:cardVC animated:YES completion:nil];
    
}


//刷新
-(void)onRefresh{
    [self.searchBar resignFirstResponder];
    self.curryPage=0;
    NSLog(@"刷新中");
    [self.songArr removeAllObjects];
    [self getSongData];
}
//下一页
-(void)onNextPage{
    [self.searchBar resignFirstResponder];
    if (kObjectIsEmpty(self.songArr)) {
        [self.mySongTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    if (self.songArr.count==(self.curryPage+1)*REQUEST_MIN_PAGE_NUM) {
        self.curryPage++;
        [self getSongData];
    }else{
        NSLog(@"无需到下一页");
        [self.mySongTableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}




#pragma mark - **************** 获取本地数据
-(void)getSongData{
    //====初始化 myAppDelegate
    if (self.dbHander==nil) {
        self.dbHander  = [[DBHander alloc]init];
    }
    //获取本地数据库数据
    [self.songArr addObjectsFromArray:[self.dbHander searchSong:self.curryPage]];
    [self.mySongTableView reloadData];
    [self.mySongTableView.mj_header endRefreshing];
    [self.mySongTableView.mj_footer endRefreshing];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
 
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
    [self jumpToSearch:searchBar.text];
    self.searchBar.text=nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];

}

-(void)jumpToSearch:(NSString *)key{
    SongViewController *searchVC = [[SongViewController alloc]init];
    searchVC.searchKey = key;
    [searchVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:searchVC animated:YES completion:nil];



}
  
//设置界面
-(void)setProfile{
    SetViewController *setVC = [[SetViewController alloc]init];
    [setVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:setVC animated:YES completion:nil];
}

@end
