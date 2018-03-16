//
//  FLStockChartManager.h
//  FL_StockChart
//
//  Created by mac on 2018/3/7.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FL_StockChartType) {
    FL_StockChartTypeTimeLine,  //分时图
    FL_StockChartTypeKLine, //K线
    FL_StockChartTypeTypeOther
};

typedef NS_ENUM(NSInteger, FL_AccessoryChartType) {
    FL_AccessoryChartTypeVolume,    //成交量
    FL_AccessoryChartTypeMACD,      //MACD
    FL_AccessoryChartTypeTypeKDJ,   //KDJ线
    FL_AccessoryChartTypeTypeOther  
};

#define FLStockChartSharedManager [FLStockChartManager sharedManager]

#define minutesCount 1440

#define maxCandleCount 80
#define minCandleCount 20
#define FL_MALineWidth 1.0f

@interface FLStockChartManager : NSObject

+ (instancetype)sharedManager;

/**
 主图类型
 */
@property (nonatomic, assign) FL_StockChartType mainChartType;

/**
 副图类型
 */
@property (nonatomic, assign) FL_AccessoryChartType accessoryChartType;

/**
 K线间隔
 */
- (CGFloat)kLineGap;

/**
 K线宽度
 */
- (CGFloat)kLineWidth;


/**
 工具类:根据字符串和富文本属性来生成rect
 
 @param string 字符串
 @param attribute 富文本属性
 @return 返回生成的rect
 */
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute;

/**
 工具类:时间转字符串
 
 @param date 时间
 @return 时间字符串
 */
- (NSString *)timeConversionToDate:(NSDate *)date;

@end
