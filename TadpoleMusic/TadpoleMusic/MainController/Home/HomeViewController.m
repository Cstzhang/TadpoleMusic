//
//  HomeViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CircleRippleView.h"
#import "ACRCloudConfig.h"
#import "ACRCloudRecognition.h"
#import "SongViewController.h"
#import "SongModel.h"
#import "HummingModel.h"
#import "SearchHandle.h"
#import "HummingListController.h"
#import "LoadButton.h"
#import "LazyFadeInView.h"
//搜索按钮的宽度
static  const int BTN_WIDTH = 160;
//搜索类型
typedef NS_ENUM(NSInteger, SearchType){
    /**
     *  音乐搜索
     */
    SearchTypeMusic=1,
    /**
     *  哼歌搜索
     */
    SearchTypeMusicHumming
};


@interface HomeViewController (){
    //ACR的属性
    ACRCloudRecognition     *_client;
    ACRCloudConfig          *_config;
    UITextView              *_resultTextView;
    NSTimeInterval          startTime;
    __block BOOL    _start;
}
/** 监听的Button */
@property (nonatomic,strong) LoadButton * searchBtn;
/** 音乐类型button */
@property (nonatomic,strong) UIButton * musicTypeBtn;
/** 哼唱类型button */
@property (nonatomic,strong) UIButton * hummingTypeBtn;
/** 搜索波纹视图 */
@property (nonatomic,strong) CircleRippleView * rippleView;
/** 搜索类型 */
@property (nonatomic, assign) SearchType searchType;
/** 音乐搜索模型 */
@property (nonatomic,strong) SongModel * songModel;
/** 哼唱识别数组 */
@property (nonatomic,strong) NSMutableArray * hummingArray;
//提示语
@property (strong, nonatomic) LazyFadeInView *fadeInView;
//搜索次数
@property (nonatomic,assign) int searchTimeCount;
/** 消息数组 */
@property (nonatomic,strong) NSArray * msgArr;
@end

@implementation HomeViewController
#pragma mark - **************** 懒加载
-(NSMutableArray *)hummingArray{
    if (!_hummingArray) {//哼唱模糊识别只提供前6个识别歌曲
        _hummingArray= [NSMutableArray arrayWithCapacity:6];
    }
    return  _hummingArray;
}

//搜索歌曲按钮（按音乐搜索）
-(UIButton *)musicTypeBtn{
    if (!_musicTypeBtn) {
        _musicTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_musicTypeBtn addTarget:self action:@selector(searchTypeMusic) forControlEvents:UIControlEventTouchUpInside];
        [_musicTypeBtn setTitle:@"音乐" forState:UIControlStateNormal];
        _musicTypeBtn.titleLabel.font = TEXT_FONT;
        [_musicTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateNormal];
        [_musicTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateHighlighted];
        [_musicTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_slected"] forState:UIControlStateSelected];
    }
    return _musicTypeBtn;
}
//搜索歌曲（按哼唱搜索）
-(UIButton *)hummingTypeBtn{
    if (!_hummingTypeBtn) {
        _hummingTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hummingTypeBtn addTarget:self action:@selector(searchTypeHumming) forControlEvents:UIControlEventTouchUpInside];
        [_hummingTypeBtn setTitle:@"哼唱" forState:UIControlStateNormal];
        _hummingTypeBtn.titleLabel.font = TEXT_FONT;
        [_hummingTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateNormal];
        [_hummingTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_unslected"] forState:UIControlStateHighlighted];
        [_hummingTypeBtn setBackgroundImage:[UIImage imageNamed:@"type_slected"] forState:UIControlStateSelected];
    }
    return _hummingTypeBtn;
}
//搜索歌曲按钮
-(LoadButton *)searchBtn{
    if (!_searchBtn) {        
        _searchBtn = [[LoadButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-RATIO_W(BTN_WIDTH))/2, (SCREEN_HEIGHT-RATIO_W(BTN_WIDTH))/2, RATIO_W(BTN_WIDTH), RATIO_W(BTN_WIDTH))];
        [_searchBtn addTarget:self action:@selector(searchMusic:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateHighlighted];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateSelected];
    
    }
    return _searchBtn;
}
//水波纹视图
-(CircleRippleView *)rippleView{
    if (!_rippleView) {
        _rippleView = [[CircleRippleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _rippleView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
        _rippleView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    }
    return  _rippleView;

}

#pragma mark - **************** 初始化
-(void)setupUI{
    //波纹视图
    [self.view addSubview:self.rippleView];
    //设置识别按钮
    [self.view addSubview:self.searchBtn];
   //选择按钮
    [self.view addSubview:self.musicTypeBtn];
    [_musicTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBtn.bottom).offset(20);
        make.right.equalTo(self.view.centerX).offset(-30);
        make.width.equalTo(RATIO_W(100));
        make.height.equalTo(RATIO_W(30));
    }];
    self.musicTypeBtn.selected = YES;
    self.musicTypeBtn.acceptEventInterval=1;
    self.searchBtn.acceptEventInterval=1;
    self.hummingTypeBtn.acceptEventInterval=1;
    //默认选择音乐识别
    [self.view addSubview:self.hummingTypeBtn];
    [_hummingTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBtn.bottom).offset(20);
            make.left.equalTo(self.view.centerX).offset(30);
            make.width.equalTo(RATIO_W(100));
            make.height.equalTo(RATIO_W(30));
    }];
    self.searchTimeCount = 0;
    self.msgArr = @[MsgStop01,MsgStop02,MsgStop03];

}



#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UI
    [self setupUI];
    //注册识别组件
    [self registerACR];
    //初始化识别类型
    self.searchType=SearchTypeMusic;
    //如果是启动自动搜索的话，开始搜索
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"statusSwitch"]){
        [self searchMusic:self.searchBtn];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    //提示语
    self.fadeInView = [[LazyFadeInView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.searchBtn.frame)-5, CGRectGetMinY(self.searchBtn.frame)-80, SCREEN_WIDTH-(2*CGRectGetMinX(self.searchBtn.frame)-80), 70)];
    //显示提示语
    [self.view addSubview:self.fadeInView];
    //没有开始的时候，动画要停止
    if (!_start) {
        //停止转圈
        [self.searchBtn endLoading];
    }

    //判断是否要自动旋转
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"statusSwitch"] &&!_start) {
        self.fadeInView.text = weclome;
    }else{
        self.fadeInView.text = MsgChangeMusci;
    }
    
  
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [self.fadeInView removeFromSuperview];
    
    [self stopSearchMusic];
}


#pragma mark - **************** 交互方法
//搜索音乐
-(void)searchMusic:(LoadButton*)sender{
    
    //初始化识别为歌曲识别
    if (_start) {
        [self stopSearchMusic];
        return;
    }
    if (![self checkAudioStatus]) {
        NSLog(@"没有麦克风权限");
        return;
    }
    switch (_searchType) {
        case SearchTypeMusic:
            
        {
            self.fadeInView.text = musicMsg;
        }
            break;
            
        case SearchTypeMusicHumming:
        {
            self.fadeInView.text = hummingMsg;
        }
            break;
    }
    //开始动画
    [_rippleView startAnimation];
    
    [sender beginLoading];
    //开始采集声纹
    [_client startRecordRec];
    //开始状态
    _start = YES;
    //搜索次数加一
    _searchTimeCount++;
    //开始时间
    startTime = [[NSDate date] timeIntervalSince1970];
}
//音乐搜索的类型：听歌
-(void)searchTypeMusic{
    if (_start) {
        return;
    }
    NSLog(@"听音乐搜索模式");
    self.searchType=SearchTypeMusic;
    self.hummingTypeBtn.selected = NO;
    self.musicTypeBtn.selected=YES;
    _config.accessKey = ACR_ACCESS_KEY;
    _config.accessSecret = ACR_ACCESS_SECRET;
    self.fadeInView.text = MsgChangeMusci;
    
    [self searchMusic:self.searchBtn];
}

//音乐搜索的类型：哼唱
-(void)searchTypeHumming{
    if (_start) {
        return;
    }
    NSLog(@"听音乐搜索模式");
    self.searchType=SearchTypeMusicHumming;
    self.hummingTypeBtn.selected = YES;
    self.musicTypeBtn.selected=NO;
    _config.accessKey = ACR_HUMMING_ACCESS_KEY;
    _config.accessSecret = ACR_HUMMING_ACCESS_SECRET;
    self.fadeInView.text = MsgChangeHumming;
    
    [self searchMusic:self.searchBtn];
}

//停止音乐识别
-(void)stopSearchMusic{
    //停止识别
    NSLog(@"停止音乐识别");
    //停止动画
    [_rippleView stopAnimation];
    //停止转圈
    [self.searchBtn endLoading];
    //提示语
    int index = arc4random_uniform(3);
    self.fadeInView.text = self.msgArr[index];
    if(_client) {
       [_client stopRecordRec];
    }
    _start = NO;
  
}



#pragma mark - **************** 音乐识别
//注册识别者
-(void)registerACR{
    //识别标识 初始化NO
    _start = NO;
    //实例化
    _config = [[ACRCloudConfig alloc] init];
    //秘钥
    _config.accessKey = ACR_ACCESS_KEY;
    _config.accessSecret = ACR_ACCESS_SECRET;
    //HOST
    _config.host = ACR_HOST;
    //http https
    _config.protocol = @"http";
    
    //if you want to identify your offline db, set the recMode to "rec_mode_local"
    /*
    1,线上识别rec_mode_remote is for Audio & Video Recognition, Live Channel Detection, Hybrid Recognition, it’s online recognition
    2,离线识别rec_mode_local  is for Offline Recognition, please put the offline database ( such as “acrcloud_local_db” ) into your app project’s workspace.
    
    3，线上线下识别结合rec_mode_both support both online and offline recognition. it will search the local db first, then search the cloud db.
    4，只能模式，断网的时候默认给一个回调  rec_mode_advance_remote : is as almost as same as rec_mode_remote, except that you can get the fingerprint data when the network does not work. You should set resultFpBlock to the ACRCloudConfig
    */
    //识别模式
    _config.recMode = rec_mode_remote;
    //暂时未知用处
    _config.audioType = @"recording";
    //识别超时
    _config.requestTimeout = 10;
    
    __weak typeof(self) weakSelf = self;
    
    _config.stateBlock = ^(NSString *state) {
        [weakSelf handleState:state];
    };
    
    _config.volumeBlock = ^(float volume) {
        //do some animations with volume
        [weakSelf handleVolume:volume];
    };
    
    _config.resultBlock = ^(NSString *result, ACRCloudResultType resType) {
        [weakSelf handleResult:result resultType:resType];
    };
    
    //if you want to get the result and fingerprint, uncoment this code, comment the code "resultBlock".
    //_config.resultFpBlock = ^(NSString *result, NSData* fingerprint) {
    //    [weakSelf handleResultFp:result fingerprint:fingerprint];
    //};
    _client = [[ACRCloudRecognition alloc] initWithConfig:_config];
    
    //start pre-record
    [_client startPreRecord:3000];


}

// 返回声纹数据长度
-(void)handleResultFp:(NSString *)result
          fingerprint:(NSData*)fingerprint
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", result);
        
        // the fingerprint is nil when can't generate fingerprint from pcm data.
        if (fingerprint) {
            NSLog(@"fingerprint data length = %ld", fingerprint.length);
        }
        //停止识别
        [_client stopRecordRec];
        //停止转圈
        [self.searchBtn endLoading];
        //停止波纹
        [_rippleView stopAnimation];
        _start = NO;
    });
}

//搜索返回
-(void)handleResult:(NSString *)result resultType:(ACRCloudResultType)resType{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"识别结果:%@ ", result);
        //能够搜索到歌曲的处理
        if ([[jsonObject valueForKeyPath: @"status.code"] integerValue] == 0) {
            if ([jsonObject valueForKeyPath: @"metadata.music"]) {
                self.songModel = [SongModel musicInfoWithDict:jsonObject];
                [self jumpToSearhMusicView];
            }
            //处理哼唱识别的数据结果
            if ([jsonObject valueForKeyPath: @"metadata.humming"]) {
                NSArray *metas = [jsonObject valueForKeyPath: @"metadata.humming"];
                //清除上次的缓存
                [self.hummingArray removeAllObjects];
                if (metas.count!=0) {
                    for (id song in metas) {
                        HummingModel *oneModel = [HummingModel hummingInfoWithDict:song];
                        [self.hummingArray addObject:oneModel];
                    }
                    [self jumpToSearhMusicView];
                }
            }
        } else {
            NSInteger errorCode = [[jsonObject valueForKeyPath: @"status.code"] integerValue];
            switch (errorCode) {
                case 2005:
                {
                self.fadeInView.text = Msg2005;
                }
                    break;
                case 1001:
                {
                    self.fadeInView.text = Msg1001;
                }
                    break;
                case 2001:
                {
                    self.fadeInView.text = Msg2001;
                }
                    break;
                case 2004:
                {
                    self.fadeInView.text = Msg2004;
                }
                    break;
                case 3003:
                {
                    if (!(self.searchTimeCount>5)) {
                       self.fadeInView.text =Msg300301;
                    }else{
                        self.fadeInView.text =Msg300302;

                    }
                }
                    break;

                default:
                {
                    self.fadeInView.text =Msg9999;
                }
                    break;
            }

            NSLog(@"error %@",error);
            
        }
        
        //结束识别动画
        [_client stopRecordRec];
        _start = NO;
        [_rippleView stopAnimation];
        
        [self.searchBtn endLoading];
    });
}
//音量状态
-(void)handleVolume:(float)volume
{
//    #warning 提示音量问题
    dispatch_async(dispatch_get_main_queue(), ^{
      //  NSLog(@"volume :%f",volume);
    });
}

//识别状态
-(void)handleState:(NSString *)state
{
//    #warning 识别结果 暂时用不到  onRecording
    dispatch_async(dispatch_get_main_queue(), ^{
       //  NSLog(@"state :%@",state);
    });
}
#pragma mark - **************** other
/**
 *  跳转到搜索结果页
 */
-(void)jumpToSearhMusicView{
    switch (self.searchType) {
        case SearchTypeMusic:
        {
            SongViewController *searchVC = [[SongViewController alloc]init];
            searchVC.songModel =self.songModel;
            searchVC.searchType = 0;
            [searchVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self presentViewController:searchVC animated:YES completion:nil];
        }
            break;
            
        case SearchTypeMusicHumming:
        {
            HummingListController *hummingVC =[[HummingListController alloc]init];
            hummingVC.hummingArray = [NSMutableArray arrayWithArray:self.hummingArray];
            [self.navigationController pushViewController:hummingVC animated:YES];
        }
            break;
    }
   
}


#pragma mark - **************** 麦克风

//检查麦克风权限
- (BOOL) checkAudioStatus{
   __block BOOL result = NO;
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL available) {
            
            if (available) {
                //completionHandler
                  result = YES;
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在“设置-隐私-麦克风”选项中允许蝌蚪访问您的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
                 result = NO;
            }
        }];
        
    }
    
    return result;
}



static NSString * const weclome = @"请靠近音乐源来辨别音乐";
static NSString * const musicMsg = @"杂音会干扰蝌蚪的识别哦";
static NSString * const hummingMsg = @"请大声歌唱吧";
static NSString * const Msg2005 = @"没找到哦,再试试吧";
static NSString * const Msg1001 = @"没找到哦,再试试吧";
static NSString * const Msg2001 = @"没找到哦,再试试吧";
static NSString * const Msg2004 = @"声音实在太小了,蝌蚪无能为力";
static NSString * const Msg300301 = @"蝌蚪已经精疲力尽了";
static NSString * const Msg300302 = @"蝌蚪需要休息,明天再来吧";
static NSString * const Msg9999 = @"不知道咋回事,就是找不到哦";

static NSString * const MsgChangeMusci = @"街边的歌声我也能听到";
static NSString * const MsgChangeHumming = @"请靠近音乐源来辨别音乐";
static NSString * const MsgStop01 = @"新专辑我也没办法啊";
static NSString * const MsgStop02 = @"没准再大声点，就能找到呢";
static NSString * const MsgStop03 = @"找啊找啊找歌曲";

@end
