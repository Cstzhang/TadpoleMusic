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
        if ((NSNull *)dict[@"songImageUrl"] ==[NSNull null]) {
            [self setValue:@"" forKey:@"songImageUrl"];
        }else{
            [self setValue:dict[@"songImageUrl"] forKey:@"songImageUrl"];
            
        }
        if ((NSNull *)dict[@"musicPlatform"] ==[NSNull null]) {
            [self setValue:@"" forKey:@"musicPlatform"];
        }else{
            [self setValue:dict[@"musicPlatform"] forKey:@"musicPlatform"];
            
        }
        
    }
    return self;
}


+(instancetype)musicInfoWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
