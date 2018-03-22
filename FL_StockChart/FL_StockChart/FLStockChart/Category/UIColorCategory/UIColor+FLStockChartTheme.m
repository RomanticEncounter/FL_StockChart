//
//  UIColor+FLStockChartTheme.m
//  FL_StockChart
//
//  Created by mac on 2018/3/22.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "UIColor+FLStockChartTheme.h"

@implementation UIColor (FLStockChartTheme)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBHexString:(NSString *)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:strtol([[hex substringWithRange:NSMakeRange(0, 2)]UTF8String], 0, 16)/255.0 green:strtol([[hex substringWithRange:NSMakeRange(2, 2)]UTF8String], 0, 16)/255.0 blue:strtol([[hex substringWithRange:NSMakeRange(4, 2)]UTF8String], 0, 16)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithRGBHexString:(NSString *)hex {
    return [UIColor colorWithRGBHexString:hex alpha:1.0f];
}


+ (UIColor *)mainChartBackgroundColor {
//    return [UIColor colorWithRGBHexString:@"1d2227"];
    return [UIColor groupTableViewBackgroundColor];
}

+ (UIColor *)borderColor {
//    return [UIColor colorWithRGBHexString:@"1d2227"];
    return [UIColor colorWithRGBHexString:@"DCDCDC"];
//    return [UIColor grayColor];
}

+ (UIColor *)increaseColor {
    return [UIColor colorWithRGBHexString:@"ff5353"];
}

+ (UIColor *)decreaseColor {
    return [UIColor colorWithRGBHexString:@"00b07c"];
}

+ (UIColor *)crossColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)longPressLineColor {
    return [UIColor colorWithRGBHexString:@"696969"];
}

+ (UIColor *)longPressPointColor {
    return [UIColor redColor];
}

+ (UIColor *)timeTextColor {
//    return [UIColor colorWithRGBHexString:@"e1e2e6"];
    return [UIColor grayColor];
}

+ (UIColor *)timeLineColor {
    return [UIColor colorWithRGBHexString:@"6495ED"];
}

+ (UIColor *)timeLineFillColor {
    return [UIColor colorWithRGBHexString:@"87CEFA" alpha:0.5];
}

+ (UIColor *)averageColor {
    return [UIColor colorWithRGBHexString:@"FFD700"];
}

+ (UIColor *)ma10Color {
    return [UIColor colorWithRGBHexString:@"18CCF6"];
}

+ (UIColor *)ma20Color {
    return [UIColor colorWithRGBHexString:@"FE5EDF"];
}

+ (UIColor *)ma30Color {
    return [UIColor colorWithRGBHexString:@"E7A520"];
}




@end
