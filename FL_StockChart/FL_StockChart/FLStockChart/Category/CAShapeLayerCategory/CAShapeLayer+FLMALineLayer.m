//
//  CAShapeLayer+FLMALineLayer.m
//  FL_StockChart
//
//  Created by mac on 2018/3/12.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "CAShapeLayer+FLMALineLayer.h"
#import "FLStockChartManager.h"

@implementation CAShapeLayer (FLMALineLayer)

+ (CAShapeLayer *)getMALineLayerWithPointArray:(NSArray <NSValue *>*)pointArray
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
