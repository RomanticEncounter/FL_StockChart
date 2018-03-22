//
//  CAShapeLayer+FLMALineLayer.h
//  FL_StockChart
//
//  Created by mac on 2018/3/12.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (FLMALineLayer)

/**
 画MA线

 @param pointArray 坐标点数组
 @param linesColor 线的颜色
 @return CAShapeLayer
 */
+ (CAShapeLayer *)getMALineLayerWithPointArray:(NSArray <NSValue *>*)pointArray
                                    LinesColor:(UIColor *)linesColor;

@end
