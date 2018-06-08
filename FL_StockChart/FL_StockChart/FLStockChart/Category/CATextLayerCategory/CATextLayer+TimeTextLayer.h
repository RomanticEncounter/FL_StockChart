//
//  CATextLayer+TimeTextLayer.h
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CATextLayer (TimeTextLayer)

/**
 绘制文字
 
 @param text 字符串
 @param textColor 文字颜色
 @param bgColor 背景颜色
 @param frame 文字frame
 @return 返回CATextLayer
 */
+ (CATextLayer *)fl_getTextLayerWithString:(NSString *)text
                              textColor:(UIColor *)textColor
                               fontSize:(CGFloat)fontSize
                        backgroundColor:(UIColor *)bgColor
                                  frame:(CGRect)frame;
@end
