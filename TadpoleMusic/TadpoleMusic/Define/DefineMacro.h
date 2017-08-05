//
//  DefineMacro.h
//  
//
//  Created by zhangzb on 2017/4/5.
//  Copyright © 2017年 恒信永利. All rights reserved.
//

#ifndef DefineMacro_h
#define DefineMacro_h


//通知中心
#define KNotificationCenter [NSNotificationCenter defaultCenter]
//Appdelegate
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
//弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
//强引用
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
//判断是否是iPhone4s
#define IS_IPHONE4S (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
//判断是否是iPhone5
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
//判断是否是iPhone6、iPhone7
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
//判断是否是iPhone6plush、7plus
#define IS_IPHONE6_PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)
//当前设备的ios版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
                                  || [_object isKindOfClass:[NSNull class]] \
                                  || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
                                  || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/** 数据为空背景图 */
#define NETERR_BACKGROUND_IMAGE @"emptyBackground"
#define EMPTY_BACKGROUND_IMAGE @"emptyBackground"
/** 本地保密数据keychain存储 */
/** UUID用户设备标识 */
#define DEVICE_UUID [[UIDevice currentDevice].identifierForVendor UUIDString]

#pragma mark ——— 第三方平台相关

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#endif /* DefineMacro_h */



