//
//  DBHander.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SongModel;
@interface DBHander : NSObject
//收藏操作
-(void)followFun:(SongModel *)model headUrl:(NSString *)headUrl;
//插入一条歌曲数据到本地数据库
-(void)insertSong:(SongModel *)model headUrl:(NSString *)headurl;
//判断是否有收藏
-(BOOL)isFollowed:(NSString *)title artist:(NSString *)artist;
//修改关注状态
-(void)unfollowSongWithTitle:(NSString *)title artist:(NSString *)artist isFollw:(int)status;

/**
 搜索缓存的数据
 @param currentPage 当前的页页码
 @return 返回搜索到的歌曲数组
 */
-(NSArray *)searchSong:(int)currentPage;
@end
