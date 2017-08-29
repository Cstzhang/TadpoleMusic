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
        //识别度
        [self setValue:dict[@"score"] forKey:@"score"];
        //歌名
        if (kObjectIsEmpty(dict[@"title"])) {
            [self setValue:@"未知歌名" forKey:@"title"];
        }else{
            [self setValue:dict[@"title"] forKey:@"title"];
            
        }
        //艺术家
        if (kObjectIsEmpty([dict objectForKey:@"artists"][0][@"name"])) {
            [self setValue:@"未知艺术家" forKey:@"artist"];
        }else{
            [self setValue:[dict objectForKey:@"artists"][0][@"name"] forKey:@"artist"];
            
        }
        //专辑名
        if (kObjectIsEmpty([dict objectForKey:@"album"][@"name"])) {
            [self setValue:@"未知专辑名" forKey:@"album"];
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
