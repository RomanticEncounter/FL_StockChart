//
//  FLStockChartMainView.h
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTimeModel.h"

@interface FLStockChartMainView : UIView

/**
 分时线数据模型
 */
@property (nonatomic, strong) FLTimeModel *timeLinesModel;

@end
