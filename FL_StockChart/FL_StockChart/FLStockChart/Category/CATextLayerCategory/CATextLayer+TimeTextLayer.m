//
//  CATextLayer+TimeTextLayer.m
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "CATextLayer+TimeTextLayer.h"

@implementation CATextLayer (TimeTextLayer)
/**
 绘制文字
 
 @param text 字符串
 @param textColor 文字颜色
 @param bgColor 背景颜色
 @param frame 文字frame
 @return 返回textLayer
 */
+ (CATextLayer *)fl_getTextLayerWithString:(NSString *)text
                              textColor:(UIColor *)textColor
                               fontSize:(CGFloat)fontSize
                        backgroundColor:(UIColor *)bgColor
                                  frame:(CGRect)frame
{
    //初始化一个CATextLayer
    CATextLayer *textLayer = [CATextLayer layer];
    //设置文字frame
    textLayer.frame = frame;
    //设置文字
    textLayer.string = text;
    //设置文字大小
    textLayer.fontSize = fontSize;
    //设置文字颜色
    textLayer.foregroundColor = textColor.CGColor;
    //设置背景颜色
    textLayer.backgroundColor = bgColor.CGColor;
    //设置对齐方式
    textLayer.alignmentMode = kCAAlignmentCenter;
    //设置分辨率
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    return textLayer;
}
@end
