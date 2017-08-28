//
//  HummingModel.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/25.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HummingModel : NSObject
//识别度
@property (nonatomic,strong) NSNumber *score;
//歌名
@property (nonatomic, copy) NSString *title;
//艺术家
@property (nonatomic, copy) NSString *artist;
//专辑名
@property (nonatomic, copy) NSString *album;


-(instancetype)initWithDictionary:(NSDictionary *)dict;

+(instancetype)hummingInfoWithDict:(NSDictionary *)dict;
@end
