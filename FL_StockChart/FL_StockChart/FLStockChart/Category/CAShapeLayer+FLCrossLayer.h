//
//  CAShapeLayer+FLCrossLayer.h
//  FL_StockChart
//
//  Created by mac on 2018/2/2.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (FLCrossLayer)

+ (CAShapeLayer *)getRectLayerWithRect:(CGRect)frameRect
                              dataRect:(CGRect)dataRect
                               dataStr:(NSString *)dataStr
                              fontSize:(CGFloat)fontSize
                             textColor:(UIColor *)textColor
                             backColor:(UIColor *)backColor;
@end
