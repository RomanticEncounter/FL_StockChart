//
//  FLStockChartMainView.h
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLStockGroupModel;

@interface FLStockChartMainView : UIView

- (instancetype)initWithFrame:(CGRect)frame groupModels:(FLStockGroupModel *)groupModels ;

- (void)startDraw;

@end
