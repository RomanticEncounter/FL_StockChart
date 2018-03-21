//
//  CAShapeLayer+FLCandleLayer.h
//  FL_StockChart
//
//  Created by mac on 2018/3/9.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@class FLKLinePointModel;

@interface CAShapeLayer (FLCandleLayer)

/**
 生成蜡烛Layer
 
 @param model 蜡烛坐标模型
 @param candleWidth 宽度
 @return 返回Layer
 */
+ (CAShapeLayer *)getCandleLayerWithPointModel:(FLKLinePointModel *)model CandleWidth:(CGFloat)candleWidth;


/**
 生成矩形Layer

 @param rectangleFrame 矩形Fream
 @param bgColor 矩形颜色
 @return 返回Layer
 */
+ (CAShapeLayer *)getRectangleLayerWithFrame:(CGRect)rectangleFrame backgroundColor:(UIColor *)bgColor;

@end
