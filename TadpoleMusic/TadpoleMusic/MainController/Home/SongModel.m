//
//  SongModel.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/16.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  音乐识别的歌曲模型

#import "SongModel.h"

@implementation SongModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        NSDictionary *meta = [dict valueForKeyPath: @"metadata.music"][0];
        //发行方 音乐标签信息
        if (kObjectIsEmpty(meta[@"label"])) {
            [self setValue:@"未知专辑名称" forKey:@"label"];
        }else{
            [self setValue:meta[@"label"] forKey:@"label"];
            
        }
        //识别度
        [self setValue:meta[@"score"] forKey:@"score"];
        //歌名
        if (kObjectIsEmpty(meta[@"title"])) {
            [self setValue:@"未知歌名" forKey:@"title"];
        }else{
            [self setValue:meta[@"title"] forKey:@"title"];
            
        }
        //发行时间
        if (kObjectIsEmpty([meta objectForKey:@"release_date"])) {
            [self setValue:@"无" forKey:@"release_date"];
        }else{
            [self setValue:[meta objectForKey:@"release_date"] forKey:@"release_date"];
            
        }
        //艺术家
        if (kObjectIsEmpty([meta objectForKey:@"artists"][0][@"name"])) {
            [self setValue:@"未知艺术家" forKey:@"artist"];
        }else{
            [self setValue:[meta objectForKey:@"artists"][0][@"name"] forKey:@"artist"];
            
        }
        //专辑名
        if (kObjectIsEmpty([meta objectForKey:@"album"][@"name"])) {
            [self setValue:@"未知专辑名" forKey:@"album"];
        }else{
            [self setValue:[meta objectForKey:@"album"][@"name"] forKey:@"album"];
            
        }
        //播放的音频/歌曲的时间位置(毫秒)
        if (kObjectIsEmpty([meta objectForKey:@"play_offset_ms"])) {
            [self setValue:@"0" forKey:@"play_offset_ms"];
        }else{
            [self setValue:[meta objectForKey:@"play_offset_ms"] forKey:@"play_offset_ms"];
            
        }
        //毫秒级的跟踪时间
        if (kObjectIsEmpty([meta objectForKey:@"duration_ms"])) {
            [self setValue:@"0" forKey:@"duration_ms"];
        }else{
            [self setValue:[meta objectForKey:@"duration_ms"] forKey:@"duration_ms"];
            
        }
    }
    return self;
    
};


+(instancetype)musicInfoWithDict:(NSDictionary *)dict{
    
    return [ [self alloc] initWithDictionary:dict];
    
};

@end
