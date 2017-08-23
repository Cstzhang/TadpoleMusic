//
//  SearchHandle.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/14.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SearchHandle.h"

@implementation SearchHandle
/**
 在百度里面搜索歌曲
 
 @param songName 歌曲名字
 */
+(void)searchMusicInBD:(NSString *)songName{
    NSLog(@"songName : %@",songName);
    
//   NSString *key = [NSString stringWithCString:songName encoding:NSUTF8StringEncoding];
    NSMutableArray *stringArray =[[NSMutableArray alloc]init];
    if ([songName containsString:@"("]) {
        [stringArray addObjectsFromArray:[songName componentsSeparatedByString:@"("]];
    }
    if ([songName containsString:@"-"]) {
        [stringArray addObjectsFromArray:[songName componentsSeparatedByString:@"-"]];
    }
    
    NSString *url= [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",songName];
    if (stringArray.count!=0) {
        url= [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",stringArray[0]];
    }

    
//    NSString *key = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    NSLog(@"key ===========%@",url);
    NSURL *xcfURL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:xcfURL encoding:NSUTF8StringEncoding error:&error];
    if (htmlString==nil||htmlString.length==0) {
        NSLog(@"没有搜索出歌曲");
        return;
    }
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    NSLog(@"htmlString :%@",htmlString);
    //尝试第一种关键词搜索
    OCGumboNode *element1 = document.Query(@"body").find(@".c-icon-play-circle").first();
    if (element1 != nil && element1.attr(@"href") !=nil &&element1.attr(@"href").length !=0) {
         NSLog(@"text = %@", element1.attr(@"href"));
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:element1.attr(@"href")]];
    }else{
        OCGumboNode *element2 = document.Query(@"body").find(@".op-musicsong-songname").first();
        if (element2 != nil && element2.attr(@"href") !=nil &&element2.attr(@"href").length !=0) {
             NSLog(@"text = %@", element2.attr(@"href"));
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:element2.attr(@"href")]];
        }
    
    }
    //  抓取图片 op-musicsong-img
    //  MV wa-se-st-image_single_video
    
    
//    OCQueryObject *element1 = document.Query(@"body").find(@".c-icon-play-circle");
//    NSLog(@"element.count %lu",(unsigned long)element1.count);
//    if ((unsigned long)element1.count>0) {
//        NSMutableString * musicUrl = [[NSMutableString alloc]init];
//        for (OCGumboElement *ele in element1) {
//            NSLog(@"text = %@", ele.attr(@"href"));
//            [musicUrl stringByAppendingString:ele.attr(@"href")];
//        }
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.abt.com"]];
//    }else{//尝试第二种搜索
//        OCQueryObject *element2 = document.Query(@"body").find(@".c-btn");
//        NSLog(@"element.count %lu",(unsigned long)element2.count);
//        for (OCGumboElement *ele in element2) {
//                NSLog(@"text = %@", ele.attr(@"href"));
//            }
//    }
   
    

}
#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

}

@end
