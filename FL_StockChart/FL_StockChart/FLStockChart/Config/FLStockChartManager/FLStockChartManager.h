//
//  FLStockChartManager.h
//  FL_StockChart
//
//  Created by mac on 2018/3/7.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 主图类型

 - FLStockChartTypeTimeLine: 分时
 - FLStockChartTypeKLine: K线
 - FLStockChartTypeTypeOther: 其他
 */
typedef NS_ENUM(NSInteger, FLStockChartType) {
    FLStockChartTypeTimeLine,       ///<分时图
    FLStockChartTypeKLine,          ///<K线
    FLStockChartTypeTypeOther       ///<其他
};

/**
 附图指标类型

 - FLAccessoryChartTypeVolume: 成交量
 - FLAccessoryChartTypeMACD: MACD
 - FLAccessoryChartTypeKDJ: K.D.J
 - FLAccessoryChartTypeBOLL: 布林线
 - FLAccessoryChartTypeTypeOther: 其他
 */
typedef NS_ENUM(NSInteger, FLAccessoryChartType) {
    FLAccessoryChartTypeVolume,     ///<成交量
    FLAccessoryChartTypeMACD,       ///<MACD
    FLAccessoryChartTypeKDJ,        ///<KDJ线
    FLAccessoryChartTypeBOLL,       ///<布林线
    FLAccessoryChartTypeTypeOther   ///<其他
};

#define FLStockChartSharedManager [FLStockChartManager sharedManager]

#define FL_TimeLineMinutesCount 1440

#define FL_MALineWidth 1.0f

@interface FLStockChartManager : NSObject

+ (instancetype)sharedManager;

/**
 主图类型
 */
@property (nonatomic, assign) FLStockChartType mainChartType;

/**
 副图类型
 */
@property (nonatomic, assign) FLAccessoryChartType accessoryChartType;

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
