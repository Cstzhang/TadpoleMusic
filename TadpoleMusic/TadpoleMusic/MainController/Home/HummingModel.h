//
//  HummingModel.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/25.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HummingModel : NSObject
//发行方 音乐标签信息
@property (nonatomic, copy) NSString *label;
//识别度
@property (nonatomic,strong) NSNumber *score;
//歌名
@property (nonatomic, copy) NSString *title;
//发行时间
@property (nonatomic, copy) NSString *release_date;
//艺术家
@property (nonatomic, copy) NSString *artist;
//专辑名
@property (nonatomic, copy) NSString *album;
//播放的音频/歌曲的时间位置(毫秒)
@property (nonatomic, strong) NSNumber *play_offset_ms;
//毫秒级的跟踪时间
@property (nonatomic, strong) NSNumber *duration_ms;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

+(instancetype)hummingInfoWithDict:(NSDictionary *)dict;
@end
