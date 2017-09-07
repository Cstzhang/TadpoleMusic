//
//  ComFunc.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/10.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComFunc : NSObject
#pragma mark - **************** 图形相关
/**颜色转图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color;
#pragma mark ——— 时间相关
/** 获取当前时间 */
+(NSString *)getCurrentTime;
@end
