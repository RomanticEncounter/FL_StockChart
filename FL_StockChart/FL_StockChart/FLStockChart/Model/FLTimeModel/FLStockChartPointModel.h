//
//  FLStockChartTimePointModel.h
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface FLTimePointModel : NSObject

/**
 最新价坐标点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 均线坐标点
 */
@property (nonatomic, assign) CGPoint avgPoint;
@end

@interface FLAccessoryPointModel : NSObject

/**
 成交量坐标点
 */
@property (nonatomic, assign) CGPoint VolumePoint;

/**
 成交量MA7
 */
@property (nonatomic, assign) CGPoint Volume_MA7Point;

/**
 成交量MA30
 */
@property (nonatomic, assign) CGPoint Volume_MA30Point;

/**
 MACD坐标点
 */
@property (nonatomic, assign) CGPoint MACDPoint;

/**
 DIF坐标点
 */
@property (nonatomic, assign) CGPoint DIFPoint;

/**
 DEA坐标点
 */
@property (nonatomic, assign) CGPoint DEAPoint;

/**
 KDJ_K坐标点
 */
@property (nonatomic, assign) CGPoint KDJ_K_Point;

/**
 KDJ_D坐标点
 */
@property (nonatomic, assign) CGPoint KDJ_D_Point;

/**
 KDJ_J坐标点
 */
@property (nonatomic, assign) CGPoint KDJ_J_Point;
@end
