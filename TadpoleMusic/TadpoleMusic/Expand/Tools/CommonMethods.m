//
//  CommonMethods.m
//  HXyxb
//
//  Created by 恒信永利 on 2017/5/12.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  

#import "CommonMethods.h"
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

@implementation CommonMethods
/**判断是否是第一次启动*/
+ (BOOL)isFirstLaunching
{
    BOOL firstLaunching = false;
    
//    NSString *lastAppVersion =  [UserDefaultTool valueForKey:@"LastAppVersion"];
//    
//    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSLog(@"currentAppVersion %@",currentAppVersion);
//    if ([lastAppVersion floatValue] < [currentAppVersion floatValue])
//    {
//        [UserDefaultTool setValue:currentAppVersion forKey:@"LastAppVersion"];
//        firstLaunching = true;
//    }
    
    return firstLaunching;
}

/** 根据iphone6进行获取适配高度 */
+ (CGFloat)adaptationIphone6Height:(CGFloat)height {
  
    return 1;

}

/**字符串转换成时间*/
+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [formatter dateFromString:string];
    return date;
}



/**去掉空格*/
+ (NSString *)deleteBlank:(NSString *)string
{
    NSString *newString= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}

/**去掉空格及空行*/
+ (NSString *)deleteBlankAndEnter:(NSString *)string
{
    NSString *newString= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString= [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return newString;
}

/**格式化浮点数*/
+(NSString *)formaterDoubleString:(double)doublevalue{
    NSString *doubleStr = [NSString stringWithFormat:@"%.2f",doublevalue];
    NSRange pointRange = [doubleStr rangeOfString:@"."];
    if (pointRange.length > 0) {
        //包含小数点
        if ([[doubleStr substringWithRange:NSMakeRange(pointRange.location+2, 1)] isEqualToString:@"0"]) {
            //最后一位为0
            if ([[doubleStr substringWithRange:NSMakeRange(pointRange.location+1, 1)] isEqualToString:@"0"]) {
                //小数点后一位为0
                doubleStr = [NSString stringWithFormat:@"%.f",doublevalue];
            }
            else{
                doubleStr = [NSString stringWithFormat:@"%.1f",doublevalue];
            }
        }
    }
    else{
        //整数
        doubleStr = [NSString stringWithFormat:@"%.f",doublevalue];
    }
    return doubleStr;
}

/**验证该字符串是否是6-16位字母和数字组合*/
+ (BOOL)checkIsDigitalAndLetter:(NSString *)string
{
    if (string.length < 6 || string.length > 16)
    {
        return NO;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:string]) {
        if ([self hasDigital:string] && [self hasLetter:string]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

/**
 *  是否有数字
 *
 *  @param string 字符串
 *
 *  @return YES 有数字 ，NO 没有数字
 */
+ (BOOL)hasDigital:(NSString *)string
{
    for(int i = 0; i < string.length ; i++){
        unichar a = [string characterAtIndex:i];
        if ((a >= '0' && a <= '9' )) {
            return YES;
        }
    }
    return NO;
}

/**
 *  是否有字母
 *
 *  @param string 字符串
 *
 *  @return YES 有字母 ，NO 没有字母
 */
+ (BOOL)hasLetter:(NSString *)string
{
    for(int i = 0; i < string.length ; i++){
        unichar a = [string characterAtIndex:i];
        if ((a >= 'A' && a <= 'Z' ) || (a >= 'a' && a <= 'z')) {
            return YES;
        }
    }
    return NO;
}

/**利用正则表达式验证手机号码*/
+ (BOOL)checkTel:(NSString *)str
{
    if (str.length==0) {
        return NO;
    }else{
        
        //    电信号段:133/153/180/181/189/177
        //    联通号段:130/131/132/155/156/185/186/145/176
        //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
        //    虚拟运营商:170

        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        
        return [regextestmobile evaluateWithObject:str];
        
    }
}

/**邮箱有效性检查*/
+ (BOOL)checkEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**利用正则表达式正整数或一位小数或者俩位小数的正则表达式*/
+ (BOOL)checkMoneyData:(NSString *)money{
    BOOL flag;
    if (money.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex = @"^[0-9]+([.]{1}[0-9]{1,2})?$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:money];

}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/**颜色转图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
/** 获取当前时间 */
+(NSString *)getCurrentTime:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (dateFormat==nil) {
         [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
         [formatter setDateFormat:dateFormat];
    }
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/**
 *  时间转成字符串转
 *  @param date
 *  @retrun NSString yyyy-MM-dd HH:mm:ss格式
 */
+ (NSString *)stringFromDate:(NSDate *)date{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return  currentDateString;

}
/**
 *  Chinese characters 25个字以内汉字
 *  @param str 要检查的字符串
 *  @retrun 符合返回yes
 */
+ (BOOL)checkChineseChar : (NSString*) str

{
    NSString *pattern =@"^[\u4E00-\u9FA5]{1,25}";
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch =[pred evaluateWithObject:str];
    return isMatch;
}


/**
 *  PHS固话校验
 *  @param str 固话
 */
+ (BOOL)checkPHSPhone: (NSString *)str{
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    BOOL isMatch =[regextestct evaluateWithObject:str];
    return isMatch;
}
/**
 *  是否有空格
 *  @param text 检查的字符串
 */
+(BOOL)containsEmptyCharacter:(NSString *)text{
    NSRange rangeName = [text rangeOfString:@" "];
    NSUInteger  blank = (NSUInteger)rangeName.length;
    return blank;

}

///对图片压缩处理完成
//+ (NSData *)imageCompressWithOldImages:(UIImage *)oldImage
//{
//    
//    
//    CGSize  oldSize = oldImage.size;
//    CGSize newSize;
//    newSize.width = oldSize.width / 2;
//    newSize.height = oldSize.height / 2;
//    
//    NSData *photoOldData = UIImageJPEGRepresentation(oldImage, 1);
//    
//    if (!photoOldData) {//图片有损,重新图片.
//        
//        oldImage = [oldImage resizedImage:newSize interpolationQuality:kCGInterpolationMedium];
//        photoOldData = UIImageJPEGRepresentation(oldImage, 1);
//        
//    }
//    
//    
//    UIImage* resizedImage;
//    
//    if ([photoOldData length]>500*1024) {
//        
//        resizedImage = [oldImage resizedImage:newSize interpolationQuality:kCGInterpolationMedium];
//    }else{
//        resizedImage=oldImage;
//    }
//    
//    
//    NSData *photoData;
//    if ([photoOldData length]<50*1024) {
//        
//        photoData = UIImageJPEGRepresentation(resizedImage, 1);
//        
//    }else if([photoOldData length]<200*1024){
//        
//        photoData = UIImageJPEGRepresentation(resizedImage, 0.8);
//        
//    }else{
//        
//        photoData = UIImageJPEGRepresentation(resizedImage, 0.5);
//        
//    }
//    
//    NSLog(@"photoData length == %lu",[photoData length]);
//    
//    return photoData;
//    
//}

@end
