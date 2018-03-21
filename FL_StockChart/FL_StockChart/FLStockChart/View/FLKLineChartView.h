//
//  FLKLineChartView.h
//  FL_StockChart
//
//  Created by mac on 2018/3/8.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLStockModel;

@protocol FLKLineChartViewDataSource <NSObject>

@required


@end

@protocol FLKLineChartViewDelegate <NSObject>
@optional
/**
 K线主图提取出的数据源数组
 
 @param needDrawModels 需要绘制的K线数据源数组
 */
- (void)FL_KLineCharExtractNeedDrawModels:(NSArray <FLStockModel *>*)needDrawModels;


@end

@interface FLKLineChartView : UIView

@property (nonatomic, weak) id <FLKLineChartViewDataSource> dataSource;
@property (nonatomic, weak) id <FLKLineChartViewDelegate> delegate;

- (void)setKLineChartWithModel:(NSArray <FLStockModel *>*)models;

- (void)drawKLineChart;

@end
