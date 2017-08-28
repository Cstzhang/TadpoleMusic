//
//  HummingModel.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/25.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HummingModel.h"

@implementation HummingModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
       // NSDictionary *meta = [dict valueForKeyPath: @"metadata.music"][0];
        //识别度
        if ((NSNull *)dict[@"score"] ==[NSNull null]) {
            [self setValue:@"0" forKey:@"score"];
        }else{
            [self setValue:dict[@"score"] forKey:@"score"];
            
        }
        //歌名
        if ((NSNull *)dict[@"title"] ==[NSNull null]) {
            [self setValue:@"未知歌名" forKey:@"title"];
        }else{
            [self setValue:dict[@"title"] forKey:@"title"];
            
        }
        //艺术家
        if ((NSNull *)[dict objectForKey:@"artists"][0]==[NSNull null]) {
            [self setValue:@"" forKey:@"artist"];
        }else{
            [self setValue:[dict objectForKey:@"artists"][0] forKey:@"artist"];
            
        }
        //专辑名
        if ((NSNull *)[dict objectForKey:@"album"][@"name"]==[NSNull null]) {
            [self setValue:@"" forKey:@"album"];
        }else{
            [self setValue:[dict objectForKey:@"album"][@"name"] forKey:@"album"];
            
        }
    }
    return self;
    
};


+(instancetype)hummingInfoWithDict:(NSDictionary *)dict{
    
    return [ [self alloc] initWithDictionary:dict];
    
};
@end
