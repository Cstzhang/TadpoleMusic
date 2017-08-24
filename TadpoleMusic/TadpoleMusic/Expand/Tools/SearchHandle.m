//
//  SearchHandle.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SearchHandle.h"
#import "SearchModel.h"
@interface SearchHandle()
/** 搜索数据*/


@end
@implementation SearchHandle
#pragma mark - **************** 懒加载

#pragma mark - **************** 搜索部分
/**
 在百度里面搜索歌曲
 
 @param songName 歌曲名字
 */
+(NSArray *)searchMusicInBD:(NSString *)songName{
     NSMutableArray * result = [NSMutableArray array];
    //判断Url中是否有特殊符号（ - 排除干扰
    NSMutableArray *stringArray =[[NSMutableArray alloc]init];
    if ([songName containsString:@"("]) {
        [stringArray addObjectsFromArray:[songName componentsSeparatedByString:@"("]];
    }
    if ([songName containsString:@"-"]) {
        [stringArray addObjectsFromArray:[songName componentsSeparatedByString:@"-"]];
    }
    //确认正确的url
    NSString *url= [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",songName];
    if (stringArray.count!=0) {
        url= [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",stringArray[0]];
    }
    NSLog(@"key ===========%@",url);
    
    //获取网页HTML
    NSURL *xcfURL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:xcfURL encoding:NSUTF8StringEncoding error:&error];
    if (htmlString==nil||htmlString.length==0) {
        #warning 待处理
        NSLog(@"没有搜索出歌曲");
        return result;
    }
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    
    #pragma mark - **************** 抓取平台名称
    OCQueryObject *musicPlatformElement = document.Query(@"body").find(@".c-tabs").find(@".c-tabs-nav-li");
    if ((unsigned long)musicPlatformElement.count>0) {
        //  NSMutableString * musicUrl =ß[[NSMutableString alloc]init];
        for (OCGumboElement *ele in musicPlatformElement) {
            NSLog(@"songName = %@", ele.text());
        }
       
    }
    #pragma mark - **************** 抓取专辑封面
    OCGumboNode *songImageGumboNode = document.Query(@"body").find(@".op-musicsong-img").first();
    if (songImageGumboNode != nil && songImageGumboNode.attr(@"src") !=nil &&songImageGumboNode.attr(@"src").length !=0) {
             NSLog(@"songImage = %@", songImageGumboNode.attr(@"src"));
        }
    #pragma mark - **************** 抓取歌曲URL
    OCQueryObject *getElement = document.Query(@"body").find(@".c-icon-play-circle");
    OCQueryObject *songUrlElement = document.Query(@"body").find(@".c-tabs").find(@".c-tabs-content");
    if ((unsigned long)getElement.count>0 && songUrlElement.count>0) {
        for (OCGumboElement *ele in songUrlElement) {
           OCGumboNode *firstSong =ele.Query(@".c-icon-play-circle").first();
            NSLog(@"firstSong %@",firstSong.attr(@"href"));
        }
    }else{//尝试第二种搜索
        for (OCGumboElement *ele in songUrlElement) {
            OCGumboNode *firstSong =ele.Query(@".op-musicsong-songname").first();
            if (firstSong == nil) {
                return result;
            }
            NSLog(@"firstSong %@",firstSong.attr(@"href"));
        }
    }
   
    #pragma mark - **************** 准备返回数据
   
//    for ( int i=0; i<musicPlatformElement.count; i++) {
//        NSDictionary * tmpMusic = [NSDictionary dictionary];
//        OCGumboElement *elePlatform = musicPlatformElement[i];
//        OCGumboElement *eleSong = songUrlElement[i];
//        OCGumboNode *firstSong =eleSong.Query(@".c-icon-play-circle").first();
//        [tmpMusic setValue:elePlatform.text() forKey:@"musicPlatform"];
//        [tmpMusic setValue:songImageGumboNode.attr(@"src") forKey:@"songImageUrl"];
//        [tmpMusic setValue:firstSong.attr(@"href") forKey:@"musicPlatform"];
//        SearchModel *oneModel = [[SearchModel alloc]initWithDict:tmpMusic];
//        [result addObject:oneModel];
//    }
    return result;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

}

@end
