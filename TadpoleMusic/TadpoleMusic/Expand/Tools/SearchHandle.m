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
+(NSMutableDictionary *)searchMusicInBD:(NSString *)songName{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
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
//    NSLog(@"key ===========%@",url);
    
    //获取网页HTML
    NSURL *xcfURL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:xcfURL encoding:NSUTF8StringEncoding error:&error];
    if (htmlString==nil||htmlString.length==0) {
        NSLog(@"没有搜索出歌曲");
        return result;
    }
//    NSLog(@"htmlString  %@",htmlString);
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];

    #pragma mark - **************** 抓取平台名称
    OCQueryObject *musicPlatformElement = document.Query(@"body").find(@".c-tabs-nav-view").find(@".c-tabs-nav-li");
    #pragma mark - **************** 抓取专辑封面
    OCQueryObject *songImageGumboNode = document.Query(@"body").find(@".op-bk-polysemy-album");
    #pragma mark - **************** 抓取歌曲URL
    OCQueryObject *getElement = document.Query(@"body").find(@".c-icon-play-circle");
    OCQueryObject *songUrlElement = document.Query(@"body").find(@"#content_left").find(@".result-op").find(@".c-tabs-content");
    //准备返回的封面图
    NSString * imageUrl = @"-";
    if (songImageGumboNode != nil ) {
        OCGumboNode * imgNode = songImageGumboNode.find(@".c-img").first();
        if (imgNode!=nil) {
            imageUrl = imgNode.attr(@"src");
//            NSLog(@"songImage %@",imageUrl);
        }else{
          //尝试另外一种获取方式
           OCGumboNode *songImageGumboNode = document.Query(@"body").find(@".op-musicsong-img").first();
            if (songImageGumboNode != nil && songImageGumboNode.attr(@"src") !=nil &&songImageGumboNode.attr(@"src").length !=0) {
                imageUrl = songImageGumboNode.attr(@"src");
//                NSLog(@"songImage %@",imageUrl);
            }
        
        }
        
    }
    [result setValue:imageUrl forKey:@"songImageUrl"];
    #pragma mark - **************** 准备返回数据
    if ((unsigned long)musicPlatformElement.count>0&&(unsigned long)songUrlElement.count>0) {//搜取的歌曲必须平台数大于1
        //
        //歌曲封面
        NSMutableArray *tmpArr = [NSMutableArray array];
        for ( int i=0; i<musicPlatformElement.count; i++) {
            NSDictionary * tmpMusic = [NSMutableDictionary dictionary];
            OCGumboElement *elePlatform = musicPlatformElement[i];
            OCGumboElement *eleSong = songUrlElement[i];
                      NSString * platform = @"-";
            NSString * songUrl = @"-";
            //平台名称
            platform = elePlatform.text();
            
            //歌曲URL
            if ((unsigned long)getElement.count>0 && songUrlElement.count>0) {//情况1
                    OCGumboNode *firstSong =eleSong.Query(@".c-icon-play-circle").first();
                    if (firstSong != nil) {
                       songUrl =  firstSong.attr(@"href");
                    }

            }else{//尝试第二种搜索
                    OCGumboNode *firstSong =eleSong.Query(@".op-musicsong-songname").first();
                    if (firstSong != nil) {
                        songUrl =  firstSong.attr(@"href");
                    }
            }

            [tmpMusic setValue:platform forKey:@"musicPlatform"];
            [tmpMusic setValue:songUrl  forKey:@"songUrl"];
            SearchModel *oneModel = [[SearchModel alloc]initWithDict:tmpMusic];
            [tmpArr addObject:oneModel];
            
        }
        [result setObject:tmpArr forKey:@"musicPlatform"];
    }
    return result;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

}

@end
