//
//  SearchModel.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/23.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

/** 播放URL */
@property (nonatomic,copy) NSString * songUrl;


/** 平台名称 */
@property (nonatomic,copy) NSString * musicPlatform;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)musicInfoWithDict:(NSDictionary *)dict;

@end
