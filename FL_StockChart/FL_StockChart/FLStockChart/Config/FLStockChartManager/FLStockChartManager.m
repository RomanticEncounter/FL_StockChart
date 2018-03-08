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


@end
