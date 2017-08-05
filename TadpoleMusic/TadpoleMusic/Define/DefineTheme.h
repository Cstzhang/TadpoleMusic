//
//  DefineTheme.h
//  
//
//  Created by zhangzb on 2017/4/5.
//  Copyright © 2017年 恒信永利. All rights reserved.
//

#ifndef DefineTheme_h
#define DefineTheme_h

//设计屏幕宽度 IPHONE 6 的尺寸作为基准
#define NORM_SCREEN_WIDTH 375

#define HEAD_TABBAR_HEIGHT 113
//屏幕宽度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//颜色
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//颜色+透明度
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
//随机颜色
#define KRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//RGB转UIColor（不带alpha值）
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB转UIColor（带alpha值）
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//颜色
//#define TITLE_COLOR [UIColor blackColor]//标题颜色
//#define TEXT_COLOR [UIColor grayColor]//正文颜色
//#define TIPTEXT_COLOR UIColorFromRGB(0x888888)//提示语文本颜色
//#define MAIN_GROUNDCOLOR UIColorFromRGB(0x2ab1e7)//主题景色
//#define BACKGROUNDCOLOR UIColorFromRGB(0xF7F7F7)//背景颜色
// main color
#define  MAIN_COLOR  [UIColor colorWithRed:244/255.0 green:190/255.0 blue:65/255.0 alpha:1.0]
# define TABBAR_SELECT_TINTCOLOR [UIColor colorWithRed:244/255.0 green:190/255.0 blue:65/255.0 alpha:1.0]
# define TABBAR_NORMAL_TINTCOLOR [UIColor grayColor]
//字体大小
#define TITLE_FONT [UIFont systemFontOfSize:18]
#define TEXT_FONT [UIFont systemFontOfSize:16]
#define TIP_TEXT_FONT [UIFont systemFontOfSize:12]
//app中统一的一些size定义
#define CELL_HEIGHT 50
#define LEFT_ORIGIN 20 //控件左边距
#define BUTTON_HEIGHT 45
#define BUTTON_WIDTH SCREEN_WIDTH - LEFT_ORIGIN * 2
#define BUTTON_LAYER_CORNER_RADIUS 2 //按钮圆角
#define LINE_COLOR UIColorFromRGB(0xCCCCCC) //线条颜色
#define LINE_WIDTH 0.5f //线条粗度

#define WHITE_COLOR [UIColor whiteColor]
#define CLEAR_COLOR [UIColor whiteColor]

/**根据6为标准适配*/
#define ADAPTATIONIPHONE(Height) [CommonMethods adaptationIphone6Height:Height]

#endif /* DefineTheme_h */
