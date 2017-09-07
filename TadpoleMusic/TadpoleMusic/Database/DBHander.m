//
//  DBHander.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "DBHander.h"
#import "SongList+CoreDataClass.h"
#import "SongList+CoreDataProperties.h"
#import "SongModel.h"

@interface DBHander()
//声明AppDelegate对象属性，用于调用类中属性，管理存储上下文
@property(nonatomic,strong)AppDelegate *myAppDelegate;
@end

@implementation DBHander
-(instancetype)init{
    if (self = [super init]) {
        //初始化 myAppDelegate
        self.myAppDelegate = kAppDelegate;
    }
    return self;
}



#pragma mark - **************** 数据库操作
//收藏操作
-(void)followFun:(SongModel *)model{
    //判断是否已经有
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"SongList"];
    //设置条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"title == %@ AND artist == %@",model.title,model.artist];
    request.predicate = predicate;
    //执行查询请求
    NSError *error = nil;
    NSArray *arr = [self.myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"arr %@",arr);
    //修改状态
    if (arr.count==0) {//如果没有 新增一条
        [self insertSong:model];
    }else{//如果有的话就修改即可
        for (SongList * song in arr) {
            song.status = 1;
        }
        //保存
        [self.myAppDelegate saveContext];
    }

    
    
}

//插入一条歌曲数据到本地数据库
-(void)insertSong:(SongModel *)model{
    //1创建实体描述文件
    NSEntityDescription *description = [NSEntityDescription entityForName:@"SongList" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    //2创建模型对象
    SongList *songList = [[SongList alloc]initWithEntity:description insertIntoManagedObjectContext:self.myAppDelegate.managedObjectContext];
    //3模型对象赋值
    songList.label = model.label;
    songList.score = model.score.doubleValue;
    songList.title = model.title;
    songList.release_date = model.release_date;
    songList.artist = model.artist;
    songList.album = model.album;
    songList.status = 1;
    songList.searchTime =[NSDate date];
    //4保存数据
    [self.myAppDelegate saveContext];
}


//判断是否有收藏
-(BOOL)isFollowed:(NSString *)title artist:(NSString *)artist{
    BOOL isFollow;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"SongList"];
    //设置条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"title == %@ AND artist == %@",title,artist];
    request.predicate = predicate;
    //执行查询请求
    NSError *error = nil;
    NSArray *arr = [self.myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"arr %@",arr);
    
    if (arr.count!=0) {
        SongList *song = arr[0];
        isFollow =song.status?YES:NO;
    }else{
        isFollow = NO;
    }
   
    return isFollow;
}

//修改关注状态
-(void)unfollowSong:(SongModel *)model isFollw:(int)status{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"SongList"];
    //设置条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"title == %@ AND artist == %@",model.title,model.artist];
    request.predicate = predicate;
    //执行查询请求
    NSError *error = nil;
    NSArray *arr = [self.myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"arr %@",arr);
    //修改状态
    if (arr.count==0) {
        return;
    }
    for (SongList * song in arr) {
        song.status = status;
    }
    //保存
    [self.myAppDelegate saveContext];
}


//搜索缓存的数据
-(NSArray *)searchSong{
    //创建 NSFetchRequestd对象
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"SongList"];
    //设置排序
    NSSortDescriptor * sortFunc = [[NSSortDescriptor alloc]initWithKey:@"searchTime" ascending:YES];
    request.sortDescriptors = @[sortFunc];
    //设置条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"status == 1"];
        request.predicate = predicate;
    //执行查询请求
    NSError *error = nil;
    NSArray *songArr = [self.myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    return songArr;
}


@end
