//
//  CAShapeLayer+FLCandleLayer.m
//  FL_StockChart
//
//  Created by mac on 2018/3/9.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "CAShapeLayer+FLCandleLayer.h"
#import <UIKit/UIKit.h>
#import "FLStockChartPointModel.h"
#import "FLStockChartManager.h"

@implementation CAShapeLayer (FLCandleLayer)

+ (CAShapeLayer *)getCandleLayerWithPointModel:(FLKLinePointModel *)model CandleWidth:(CGFloat)candleWidth {
    //判断是否为涨跌
    BOOL isRed = model.openPoint.y >= model.closePoint.y ? YES : NO;
    
    CGPoint candlePoint = CGPointMake(isRed ? model.closePoint.x : model.openPoint.x, isRed ? model.closePoint.y : model.openPoint.y);
    
    CGRect candleFrame = CGRectMake(candlePoint.x, candlePoint.y, candleWidth, ABS(model.openPoint.y - model.closePoint.y));
//    NSLog(@"%@",NSStringFromCGRect(candleFrame));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:candleFrame];
    
//    //绘制上下影线
    [path moveToPoint:model.lowPoint];
    [path addLineToPoint:model.highPoint];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0f;
    
    //判断涨跌来设置颜色
    if (model.openPoint.y > model.closePoint.y) {
        //涨，设置红色
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.fillColor = [UIColor redColor].CGColor;
    } else if (model.openPoint.y < model.closePoint.y) {
        //跌，设置绿色
        layer.strokeColor = [UIColor greenColor].CGColor;
        layer.fillColor = [UIColor greenColor].CGColor;
    } else {
        //十字线，设置灰色
        layer.strokeColor = [UIColor blackColor].CGColor;
        layer.fillColor = [UIColor blackColor].CGColor;
    }
    return layer;
}

+ (CAShapeLayer *)getRectangleLayerWithPointModel:(FLAccessoryPointModel *)model RectangleWidth:(CGFloat)rectangleWidth {
    CGRect rectangleFrame = CGRectMake(model.VolumePoint.x, model.VolumePoint.y, rectangleWidth, ABS(model.VolumePoint.y - model.VolumePoint.y));
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rectangleFrame];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0f;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    return layer;
}
@end
