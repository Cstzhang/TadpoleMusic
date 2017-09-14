//
//  UserDefaultTool.h
//  HXyxb
//
//  Created by 恒信永利 on 2017/5/12.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  封装NSUserDefaults的几个主要方法，用类方法进行调用

#import <Foundation/Foundation.h>

@interface UserDefaultTool : NSObject

/**
 *  setObject方法
 *
 *  @param value     设置的value
 *  @param defaultName  key名字
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

/**
 *  objectForKey方法
 *
 *  @param defaultName     获取key对于的值
 */
+ (id)objectForKey:(NSString *)defaultName;

/**
 *  setValue方法
 *
 *  @param value     设置的value
 *  @param defaultName  key名字
 */
+ (void)setValue:(id)value forKey:(NSString *)defaultName;

/**
 *  valueForKey方法
 *
 *  @param defaultName     获取key对于的值
 */
+ (id)valueForKey:(NSString *)defaultName;

/**
 *  removeObjectForKey方法
 *
 *  @param key     要移除的key
 */
+(void)removeObjectForKey:(NSString*)key;

/**
 *  清除所有的存储信息
 *
 */
+(void)clearAll;
@end
