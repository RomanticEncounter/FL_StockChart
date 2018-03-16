//
//  FLStockChartManager.m
//  FL_StockChart
//
//  Created by mac on 2018/3/7.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLStockChartManager.h"


@implementation FLStockChartManager

+ (instancetype)sharedManager {
    static FLStockChartManager *stockChartManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stockChartManager = [[self alloc]init];
    });
    return stockChartManager;
}

- (CGFloat)kLineGap {
    return 1.5f;
}

- (CGFloat)kLineWidth {
    return 5.0f;
}



/**
 工具类:根据字符串和富文本属性来生成rect
 
 @param string 字符串
 @param attribute 富文本属性
 @return 返回生成的rect
 */
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

/**
 工具类:时间转字符串
 
 @param date 时间
 @return 时间字符串
 */
- (NSString *)timeConversionToDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeSp = [formatter stringFromDate:date];
    return timeSp;
}


@end
