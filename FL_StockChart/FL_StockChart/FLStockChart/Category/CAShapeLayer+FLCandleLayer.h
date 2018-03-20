//
//  CAShapeLayer+FLCandleLayer.h
//  FL_StockChart
//
//  Created by mac on 2018/3/9.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class FLKLinePointModel;
@class FLAccessoryPointModel;

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

 @param model 矩形坐标模型
 @param rectangleWidth 矩形宽度
 @return 返回Layer
 */
+ (CAShapeLayer *)getRectangleLayerWithPointModel:(FLAccessoryPointModel *)model RectangleWidth:(CGFloat)rectangleWidth;

@end
