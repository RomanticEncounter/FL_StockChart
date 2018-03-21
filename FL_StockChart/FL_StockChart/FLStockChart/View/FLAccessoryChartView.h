//
//  FLAccessryChartView.h
//  FL_StockChart
//
//  Created by mac on 2018/3/7.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLStockModel;

@interface FLAccessoryChartView : UIView

//- (instancetype)initWithFrame:(CGRect)frame StockGroupModel:(NSArray *)models;

/**
 设置副图数据源

 @param needDrawModels 需要绘制的Model数组
 */
- (void)setAccessoryChartDataSource:(NSArray <FLStockModel *>*)needDrawModels;

/**
 开始绘制副图
 */
- (void)startDrawAccessoryChart;
@end
