//
//  UIColor+FLStockChartTheme.h
//  FL_StockChart
//
//  Created by mac on 2018/3/22.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FLStockChartTheme)

/**
 16进制颜色

 @param hex 0x000000
 @return RGB颜色
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

/**
 16进制颜色字符串

 @param hex 16进制颜色字符串（不含#）
 @return RGB颜色
 */
+ (UIColor *)colorWithRGBHexString:(NSString *)hex;

/**
 16进制颜色字符串

 @param hex 16进制颜色字符串（不含#）
 @param alpha 透明度
 @return RGB颜色
 */
+ (UIColor *)colorWithRGBHexString:(NSString *)hex alpha:(CGFloat)alpha;

/**
 主图背景颜色
 */
+ (UIColor *)mainChartBackgroundColor;

/**
 边框颜色
 */
+ (UIColor *)borderColor;

/**
 涨的颜色
 */
+ (UIColor *)increaseColor;

/**
 跌的颜色
 */
+ (UIColor *)decreaseColor;

/**
 十字线的颜色
 */
+ (UIColor *)crossColor;

/**
 长按虚线的颜色
 */
+ (UIColor *)longPressLineColor;

/**
 长按交叉小点的颜色
 */
+ (UIColor *)longPressPointColor;

/**
 时间颜色
 */
+ (UIColor *)timeTextColor;

/**
 分时线颜色
 */
+ (UIColor *)timeLineColor;

/**
 分时线填充颜色
 */
+ (UIColor *)timeLineFillColor;

/**
 分时均线的颜色
 */
+ (UIColor *)averageColor;

/**
 MA10线的颜色
 */
+ (UIColor *)ma10Color;

/**
 MA20线的颜色
 */
+ (UIColor *)ma20Color;

/**
 MA30线的颜色
 */
+ (UIColor *)ma30Color;

@end
