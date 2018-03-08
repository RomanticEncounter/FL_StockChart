//
//  FLStockChartManager.h
//  FL_StockChart
//
//  Created by mac on 2018/3/7.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
