//
//  SearchHandle.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  搜索音乐

#import <Foundation/Foundation.h>
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@protocol SearchMusicHandleDelegate <NSObject>

//准备一个搜索完成的回调方法


@end

@interface SearchHandle : NSObject
/** 代理 */
@property (nonatomic,weak) id <SearchMusicHandleDelegate> delegate;

/**
 在百度里面搜索歌曲

 @param songName 歌曲名字
 */
+(NSMutableDictionary *)searchMusicInBD:(NSString *)songName;
@end
