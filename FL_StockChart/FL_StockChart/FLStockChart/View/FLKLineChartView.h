//
//  FLKLineChartView.h
//  FL_StockChart
//
//  Created by mac on 2018/3/8.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLStockModel;

@interface FLKLineChartView : UIView

- (void)setKLineChartWithModel:(NSArray <FLStockModel *>*)models;

- (void)drawKLineChart;

@end
