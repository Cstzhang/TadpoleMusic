//
//  CommonMethods.h
//  HXyxb
//
//  Created by 恒信永利 on 2017/5/12.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  公用方法

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonMethods : NSObject
#pragma mark ——— 系统方法
/**判断是否是第一次启动*/
+ (BOOL)isFirstLaunching;
/**根据iPhone6大小适配*/
+ (CGFloat)adaptationIphone6Height:(CGFloat)height;
#pragma mark ——— 字符串相关
/**去掉空格*/
+ (NSString *)deleteBlank:(NSString *)string;
/**去掉回车和空格*/
+ (NSString *)deleteBlankAndEnter:(NSString *)string;
/**格式化浮点数（若有一位小数，显示一位；若有两位小数，则显示两位）*/
+(NSString *)formaterDoubleString:(double)doublevalue;

#pragma mark ——— 验证相关
/**验证该字符串是否是6-16位字母和数字组合*/
+ (BOOL)checkIsDigitalAndLetter:(NSString *)string;
/**利用正则表达式验证手机号码*/
+ (BOOL)checkTel:(NSString *)str;
/**利用正则表达式验证邮箱*/
+ (BOOL)checkEmail:(NSString *)email;
/**利用正则表达式正整数或一位小数或者俩位小数的正则表达式*/
+ (BOOL)checkMoneyData:(NSString *)money;
/** 校验身份证号 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
/** Chinese characters 25个字以内汉字 */
+ (BOOL)checkChineseChar : (NSString*) str;
/** PHS固话校验 */
+ (BOOL)checkPHSPhone: (NSString *)str;
//是否有空字符
+(BOOL)containsEmptyCharacter:(NSString *)text;
#pragma mark ——— UI图形相关
/**颜色转图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *  压缩图片
 *
 */
//+ (NSData *)imageCompressWithOldImages:(UIImage *)oldImage;


#pragma mark ——— 时间相关
/** 获取当前时间 */
+(NSString *)getCurrentTime:(NSString *)dateFormat;

/**
 *  字符串转换成时间
 *  @param string
 *  @retrun NSDate yyyy-MM-dd HH:mm:ss格式
 */
+ (NSDate *)dateFromString:(NSString *)string;
/**
 *  时间转成字符串转
 *  @param date
 *  @retrun NSString yyyy-MM-dd HH:mm:ss格式
 */
+ (NSString *)stringFromDate:(NSDate *)date;

@end
