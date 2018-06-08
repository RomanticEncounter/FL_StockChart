//
//  CAShapeLayer+FLKLineLayer.m
//  FL_StockChart
//
//  Created by LingPin on 2018/6/8.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "CAShapeLayer+FLKLineLayer.h"
#import "UIColor+FLStockChartTheme.h"
#import "FLStockChartPointModel.h"
#import "FLStockChartManager.h"


@implementation CAShapeLayer (FLKLineLayer)

+ (CAShapeLayer *)fl_getCrossDateRectLayerWithRect:(CGRect)frameRect dateRect:(CGRect)dateRect dateText:(NSString *)dateText fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frameRect];
    layer.path = path.CGPath;
    layer.strokeColor = textColor.CGColor;
    layer.fillColor = backgroundColor.CGColor;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = dateRect;
    textLayer.string = dateText;
    textLayer.fontSize = fontSize;
    textLayer.foregroundColor = textColor.CGColor;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layer addSublayer:textLayer];
    return layer;
}

+ (CAShapeLayer *)fl_getCandleLayerWithPointModel:(FLKLinePointModel *)model candleWidth:(CGFloat)candleWidth {
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
        layer.strokeColor = [UIColor increaseColor].CGColor;
        layer.fillColor = [UIColor increaseColor].CGColor;
    } else if (model.openPoint.y < model.closePoint.y) {
        //跌，设置绿色
        layer.strokeColor = [UIColor decreaseColor].CGColor;
        layer.fillColor = [UIColor decreaseColor].CGColor;
    } else {
        //十字线，设置灰色
        layer.strokeColor = [UIColor crossColor].CGColor;
        layer.fillColor = [UIColor crossColor].CGColor;
    }
    return layer;
}

+ (CAShapeLayer *)fl_getRectangleLayerWithFrame:(CGRect)rectangleFrame backgroundColor:(UIColor *)bgColor {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rectangleFrame];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0f;
    layer.strokeColor = bgColor.CGColor;
    layer.fillColor = bgColor.CGColor;
    return layer;
}

+ (CAShapeLayer *)fl_getMALineLayerWithPointArray:(NSArray <NSValue *>*)pointArray
                                    LinesColor:(UIColor *)linesColor {
    CAShapeLayer *maLineLayer = [CAShapeLayer layer];
    UIBezierPath *maLinePath = [UIBezierPath bezierPath];
    
    CGPoint firstPoint = pointArray.firstObject.CGPointValue;
    [maLinePath moveToPoint:firstPoint];
    for (int idx = 1; idx < pointArray.count; idx ++) {
        CGPoint model = [pointArray[idx] CGPointValue];
        [maLinePath addLineToPoint:model];
    }
    maLineLayer.path = maLinePath.CGPath;
    maLineLayer.lineWidth = FL_MALineWidth;
    maLineLayer.strokeColor = linesColor.CGColor;
    maLineLayer.fillColor = [UIColor clearColor].CGColor;
    
    return maLineLayer;
}

@end
