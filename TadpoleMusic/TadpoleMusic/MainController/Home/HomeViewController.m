//
//  HomeViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HomeViewController.h"
#import "CircleRippleView.h"
#import "ACRCloudConfig.h"
#import "ACRCloudRecognition.h"
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
/** 提示语label */
@property (nonatomic,strong) UILabel * tipsLabel;
/** 监听的Button */
@property (nonatomic,strong) UIButton * searchBtn;
/** 音乐类型button */
@property (nonatomic,strong) UIButton * musicTypeBtn;
/** 哼唱类型button */
@property (nonatomic,strong) UIButton * hummingTypeBtn;
/** 搜索波纹视图 */
@property (nonatomic,strong) CircleRippleView * rippleView;
/** 搜索类型 */
@property (nonatomic, assign) SearchType searchType;

@end

@implementation HomeViewController
#pragma mark - **************** 懒加载
//设置提示title
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = [UIFont systemFontOfSize:20];
        _tipsLabel.textColor = WHITE_COLOR;
        _tipsLabel.text = @"点击按钮开始识别";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
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
-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(searchMusic) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateHighlighted];
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
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.centerY);
        make.centerX.equalTo(self.view.centerX);
        make.width.height.equalTo(RATIO_W(BTN_WIDTH));
    }];
    //提示语
    [self.view addSubview:self.tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.centerY).offset(-RATIO_W(BTN_WIDTH)/2 -20);
    }];
   //选择按钮
    [self.view addSubview:self.musicTypeBtn];
    [_musicTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBtn.bottom).offset(20);
        make.right.equalTo(self.view.centerX).offset(-30);
        make.width.equalTo(RATIO_W(100));
        make.height.equalTo(RATIO_W(30));
    }];
    self.musicTypeBtn.selected = YES;
    //默认选择音乐识别
    [self.view addSubview:self.hummingTypeBtn];
    [_hummingTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBtn.bottom).offset(20);
            make.left.equalTo(self.view.centerX).offset(30);
            make.width.equalTo(RATIO_W(100));
            make.height.equalTo(RATIO_W(30));
    }];
    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeSystem];
    rightBt.frame=CGRectMake(0, 0, 42, 23);
    [rightBt setTitle:@"停止" forState:UIControlStateNormal];
    [rightBt addTarget:self action:@selector(stopSearchMusic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    self.navigationItem.rightBarButtonItem=rightItem;

  
}



#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerACR];
}


#pragma mark - **************** 交互方法
//搜索音乐
-(void)searchMusic{
    NSLog(@"搜索音乐");
    //如果已经正在识别了，直接返回
    if (_start) {
        return;
    }
    //开始动画
    [_rippleView startAnimation];
    
    //开始采集声纹
    [_client startRecordRec];
    //开始状态
    _start = YES;
    //开始时间
    startTime = [[NSDate date] timeIntervalSince1970];
}
//音乐搜索的类型：听歌
-(void)searchTypeMusic{
    //如果已经正在识别了，直接返回
    if (_start) {
        return;
    }
    NSLog(@"听音乐搜索模式");
    self.searchType=SearchTypeMusic;
    self.hummingTypeBtn.selected = NO;
    self.musicTypeBtn.selected=YES;
    _config.accessKey = ACR_ACCESS_KEY;
    _config.accessSecret = ACR_ACCESS_SECRET;
}

//音乐搜索的类型：哼唱
-(void)searchTypeHumming{
    //如果已经正在识别了，直接返回
    if (_start) {
        return;
    }
    NSLog(@"听音乐搜索模式");
    self.searchType=SearchTypeMusicHumming;
    self.hummingTypeBtn.selected = YES;
    self.musicTypeBtn.selected=NO;
    _config.accessKey = ACR_HUMMING_ACCESS_KEY;
    _config.accessSecret = ACR_HUMMING_ACCESS_SECRET;
}

//停止音乐识别
-(void)stopSearchMusic{
    //停止识别
    NSLog(@"停止");
    if(_client) {
        [_client stopRecordRec];
    }
    _start = NO;
    //停止动画
    //暂停动画
    [_rippleView stopAnimation];
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


-(void)handleResultFp:(NSString *)result
          fingerprint:(NSData*)fingerprint
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", result);
        
        // the fingerprint is nil when can't generate fingerprint from pcm data.
        if (fingerprint) {
            NSLog(@"fingerprint data length = %ld", fingerprint.length);
        }
        [_client stopRecordRec];
        _start = NO;
    });
}

-(void)handleResult:(NSString *)result
         resultType:(ACRCloudResultType)resType
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *r = nil;
        
        NSLog(@"%@", result);
        
        if ([[jsonObject valueForKeyPath: @"status.code"] integerValue] == 0) {
            if ([jsonObject valueForKeyPath: @"metadata.music"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.music"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *artist = [meta objectForKey:@"artists"][0][@"name"];
                NSString *album = [meta objectForKey:@"album"][@"name"];
                NSString *play_offset_ms = [meta objectForKey:@"play_offset_ms"];
                NSString *duration = [meta objectForKey:@"duration_ms"];
                
                NSArray *ra = @[[NSString stringWithFormat:@"title:%@", title],
                                [NSString stringWithFormat:@"artist:%@", artist],
                                [NSString stringWithFormat:@"album:%@", album],
                                [NSString stringWithFormat:@"play_offset_ms:%@", play_offset_ms],
                                [NSString stringWithFormat:@"duration_ms:%@", duration]];
                r = [ra componentsJoinedByString:@"\n"];
            }
            if ([jsonObject valueForKeyPath: @"metadata.custom_files"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.custom_files"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *audio_id = [meta objectForKey:@"audio_id"];
                
                r = [NSString stringWithFormat:@"title : %@\naudio_id : %@", title, audio_id];
            }
            if ([jsonObject valueForKeyPath: @"metadata.streams"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.streams"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *title_en = [meta objectForKey:@"title_en"];
                
                r = [NSString stringWithFormat:@"title : %@\ntitle_en : %@", title,title_en];
            }
            if ([jsonObject valueForKeyPath: @"metadata.custom_streams"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.custom_streams"][0];
                NSString *title = [meta objectForKey:@"title"];
                
                r = [NSString stringWithFormat:@"title : %@", title];
            }
            if ([jsonObject valueForKeyPath: @"metadata.humming"]) {
                NSArray *metas = [jsonObject valueForKeyPath: @"metadata.humming"];
                NSMutableArray *ra = [NSMutableArray arrayWithCapacity:6];
                for (id d in metas) {
                    NSString *title = [d objectForKey:@"title"];
                    NSString *score = [d objectForKey:@"score"];
                    NSString *sh = [NSString stringWithFormat:@"title : %@  score : %@", title, score];
                    
                    [ra addObject:sh];
                }
                r = [ra componentsJoinedByString:@"\n"];
            }
            
            //self.resultView.text = r;
        } else {
           // self.resultView.text = result;
        }
        
        [_client stopRecordRec];
        _start = NO;
        
        //        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        //        int cost = nowTime - startTime;
        //        self.costLabel.text = [NSString stringWithFormat:@"cost : %ds", cost];
        
    });
}

-(void)handleVolume:(float)volume
{
    dispatch_async(dispatch_get_main_queue(), ^{
       // self.volumeLabel.text = [NSString stringWithFormat:@"Volume : %f",volume];
        
    });
}

-(void)handleState:(NSString *)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.stateLabel.text = [NSString stringWithFormat:@"State : %@",state];
    });
}
@end
