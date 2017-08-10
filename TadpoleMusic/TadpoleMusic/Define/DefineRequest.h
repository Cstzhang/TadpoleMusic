//
//  DefineRequest.h
//  
//
//  Created by zhangzb on 2017/4/5.
//  Copyright © 2017年 恒信永利. All rights reserved.
//

#ifndef DefineRequest_h
#define DefineRequest_h

//列表一页请求数量
#define REQUEST_MIN_PAGE_NUM 10
//连接超时时间
#define  REQUEST_TIME_OUT 10.f

//请求失败提示语句
#define NETERR @"请检查网络连接"
#define NETFAIL @"请求失败，请重试"

//系统Notification定义
//通知中心
#define KNotificationCenter [NSNotificationCenter defaultCenter]
#define TNCancelFavoriteProductNotification     @"TNCancelFavoriteProductNotification"      //取消收藏时
#define TNMarkFavoriteProductNotification       @"TNMarkFavoriteProductNotification"        //标记收藏时

#define kNotficationDownloadProgressChanged     @"kNotficationDownloadProgressChanged"      //下载进度变化
#define kNotificationPauseDownload              @"kNotificationPauseDownload"               //暂停下载
#define kNotificationStartDownload              @"kNotificationStartDownload"               //开始下载

#define kNotificationDownloadSuccess            @"kNotificationDownloadSuccess"             //下载成功
#define kNotificationDownloadFailed             @"kNotificationDownloadFailed"              //下载失败
#define kNotificationDownloadNewMagazine        @"kNotificationDownloadNewMagazine"




//***************发布环境*************
#ifdef DEBUG
//Debug状态下的测试API
#define API_BASE_URL_STRING     @""

#else
//Release状态下的线上API
#define API_BASE_URL_STRING     @""

#endif



//****************接口说明************

/** 登录 
 地址：api/Account/Login
 参数：
 
 */



#endif /* DefineRequest_h */
