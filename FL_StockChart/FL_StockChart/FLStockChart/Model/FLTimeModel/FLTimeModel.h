//
//  FLTimeModel.h
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLineModel : NSObject

/**
 成交额
 */
@property (nonatomic, assign) NSInteger amount;

/**
 均价
 */
@property (nonatomic, assign) float avg;

/**
 现价
 */
@property (nonatomic, assign) float close;

/**
 第几分钟
 */
@property (nonatomic, assign) NSInteger time;

/**
 成交额
 */
@property (nonatomic, assign) float volume;

@end

@interface FLTimeModel : NSObject
/**
 股票代码
 */
@property (nonatomic, strong) NSString *code;

/**
 市场代码
 */
@property (nonatomic, assign) NSString *market;

/**
 上次收盘
 */
@property (nonatomic, assign) float prevClose;

/**
 昨结
 */
@property (nonatomic, assign) float prevSettle;

@property (nonatomic, assign) NSInteger pushFlag;

@property (nonatomic, strong) NSMutableArray *trend;
@end
