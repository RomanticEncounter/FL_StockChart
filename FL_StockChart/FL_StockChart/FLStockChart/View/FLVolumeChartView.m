//
//  FLVolumeChartView.m
//  FL_StockChart
//
//  Created by mac on 2018/3/6.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLVolumeChartView.h"
#import "FLStockModel.h"

@interface FLVolumeChartView ()
/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*models;
/**
 最大值
 */
@property (nonatomic, assign) double maxValue;
/**
 最小值
 */
@property (nonatomic, assign) double minValue;
/**
 转换成坐标点数组
 */
@property (nonatomic, strong) NSMutableArray *pointArray;
@end

//x轴时间点高
static CGFloat timePointH = 20.f;

@implementation FLVolumeChartView

- (instancetype)initWithFrame:(CGRect)frame StockGroupModel:(NSArray *)models {
    self = [super initWithFrame:frame];
    if (self) {
        self.pointArray = [NSMutableArray array];
        self.models = models;
        [self drawBorderLayer];
    }
    return self;
}

/**
 绘制边框
 */
- (void)drawBorderLayer {
    //初始化坐标点
    CGFloat startFrameX = 0.f;
    CGFloat startFrameY = 0.f;
    CGFloat borderFrameW = CGRectGetWidth(self.frame);
    //减去底部时间的高度20
    CGFloat borderFrameH = CGRectGetHeight(self.frame) - timePointH;
    CGRect borderRect = CGRectMake(startFrameX, startFrameY, borderFrameW, borderFrameH);
    
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:borderRect];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGFloat unitW = borderFrameW / 6;
    CGFloat unitH = borderFrameH / 2;
    //绘制7条竖线
    for (NSInteger i = 0; i < 7; i ++) {
        CGPoint startPoint = CGPointMake(startFrameX + unitW * i, startFrameY);
        CGPoint endPoint   = CGPointMake(startFrameX + unitW * i, startFrameY + borderFrameH);
        [framePath moveToPoint:startPoint];
        [framePath addLineToPoint:endPoint];
    }
    //绘制1条横线
    
    CGPoint startPoint = CGPointMake(startFrameX, startFrameY + unitH);
    CGPoint endPoint   = CGPointMake(startFrameX + CGRectGetWidth(self.frame), startFrameY);
    [framePath moveToPoint:startPoint];
    [framePath addLineToPoint:endPoint];
    
    //设置图层的属性
    layer.path = framePath.CGPath;
    //宽度
    layer.lineWidth = 0.5f;
    //颜色
    layer.strokeColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.f].CGColor;
    //填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
}

@end
