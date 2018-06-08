//
//  CAShapeLayer+FLKLineLayer.h
//  FL_StockChart
//
//  Created by LingPin on 2018/6/8.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@class FLKLinePointModel;


@interface CAShapeLayer (FLKLineLayer)
/**
 生成长按时间layer

 @param frameRect 时间坐标
 @param dateRect 时间frame
 @param dateText 时间
 @param fontSize 字体大小
 @param textColor 字体颜色
 @param backgroundColor 背景颜色
 @return 返回layer
 */
+ (CAShapeLayer *)fl_getCrossDateRectLayerWithRect:(CGRect)frameRect
                                          dateRect:(CGRect)dateRect
                                          dateText:(NSString *)dateText
                                          fontSize:(CGFloat)fontSize
                                         textColor:(UIColor *)textColor
                                   backgroundColor:(UIColor *)backgroundColor;

/**
 生成蜡烛Layer
 
 @param model 蜡烛坐标模型
 @param candleWidth 宽度
 @return 返回Layer
 */
+ (CAShapeLayer *)fl_getCandleLayerWithPointModel:(FLKLinePointModel *)model
                                   candleWidth:(CGFloat)candleWidth;


/**
 生成矩形Layer
 
 @param rectangleFrame 矩形Fream
 @param bgColor 矩形颜色
 @return 返回Layer
 */
+ (CAShapeLayer *)fl_getRectangleLayerWithFrame:(CGRect)rectangleFrame
                             backgroundColor:(UIColor *)bgColor;

/**
 画MA线
 
 @param pointArray 坐标点数组
 @param linesColor 线的颜色
 @return CAShapeLayer
 */
+ (CAShapeLayer *)fl_getMALineLayerWithPointArray:(NSArray <NSValue *>*)pointArray
                                    LinesColor:(UIColor *)linesColor;
@end
