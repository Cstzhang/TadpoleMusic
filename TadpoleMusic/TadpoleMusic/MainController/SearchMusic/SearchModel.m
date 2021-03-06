//
//  SearchModel.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/23.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        if ((NSNull *)dict[@"songUrl"] ==[NSNull null]) {
            [self setValue:@"" forKey:@"songUrl"];
        }else{
            [self setValue:dict[@"songUrl"] forKey:@"songUrl"];
            
        }

        if ((NSNull *)dict[@"musicPlatform"] ==[NSNull null]) {
            [self setValue:@"" forKey:@"musicPlatform"];
        }else{
            [self setValue:dict[@"musicPlatform"] forKey:@"musicPlatform"];
            
        }
        if ((NSNull *)dict[@"artist"] ==[NSNull null]) {
            [self setValue:@"" forKey:@"artist"];
        }else{
            [self setValue:dict[@"artist"] forKey:@"artist"];
            
        }
    }
    return self;
}


+(instancetype)musicInfoWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
