//
//  FLTimeChartView.h
//  FL_StockChart
//
//  Created by mac on 2018/3/5.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTimeChartView : UIView

/**
 初始化

 @param frame frame
 @param models 数据源
 @return 分时图
 */
- (instancetype)initWithFrame:(CGRect)frame StockGroupModel:(NSArray *)models;


/**
 开始绘制分时图
 */
- (void)startDrawTimeChart ;
@end
