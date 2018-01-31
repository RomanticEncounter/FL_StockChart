//
//  FLStockChartMainView.m
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "FLStockChartMainView.h"
#import "FLTimePointModel.h"
#import "CATextLayer+TimeTextLayer.h"

@interface FLStockChartMainView ()
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

@implementation FLStockChartMainView

//x轴时间点高
static CGFloat timePointH = 20.f;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pointArray = [NSMutableArray array];
        [self drawBorderLayer];
    }
    return self ;
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
    
    CGFloat unitW = borderFrameW/6;
    CGFloat unitH = borderFrameH/4;
    //绘制7条竖线
    for (NSInteger i = 0; i < 7; i ++) {
        CGPoint startPoint = CGPointMake(startFrameX + unitW * i, startFrameY);
        CGPoint endPoint   = CGPointMake(startFrameX + unitW * i, startFrameY + borderFrameH);
        [framePath moveToPoint:startPoint];
        [framePath addLineToPoint:endPoint];
    }
    //绘制5条横线
    for (NSInteger i = 0; i < 5; i ++) {
        CGPoint startPoint = CGPointMake(startFrameX, startFrameY + unitH * i);
        CGPoint endPoint   = CGPointMake(startFrameX + borderFrameW, startFrameY + unitH * i);
        [framePath moveToPoint:startPoint];
        [framePath addLineToPoint:endPoint];
    }
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

/**
 寻找极限值
 */
- (void)findMaxMinValue {
    double avgMax = [[[self.timeLinesModel.trend valueForKeyPath:@"avg"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double avgMin = [[[self.timeLinesModel.trend valueForKeyPath:@"avg"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
    double closeMax = [[[self.timeLinesModel.trend valueForKeyPath:@"close"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double closeMin = [[[self.timeLinesModel.trend valueForKeyPath:@"close"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
    double maxValue = fmax(avgMax, closeMax);
    double minValue = fmin(avgMin, closeMin);
    
    float gapValue = 0.01f;
    /*
    if(ABS(当前分时线中最大值 - 昨日收盘价)) >= (ABS(昨日收盘价-当前分时线中最小值)) {
        最上侧价格 = 当前分时线中最大值；
        最下侧价格 = 昨日收盘价 - ABS(当前分时线中最大值 - 昨日收盘价);
    } else {
        最上侧价格 = 昨日收盘价 + ABS(昨日收盘价-当前分时线中最小值);
        最下侧价格 = 当前分时线中最小值；
    }
     */
    if (ABS(maxValue - self.timeLinesModel.prevClose) >= ABS(self.timeLinesModel.prevClose - minValue)) {
        maxValue = maxValue - self.timeLinesModel.prevClose + gapValue + self.timeLinesModel.prevClose;
        minValue = self.timeLinesModel.prevClose - (maxValue - self.timeLinesModel.prevClose);
        
    } else {
        minValue = self.timeLinesModel.prevClose - (self.timeLinesModel.prevClose - minValue + gapValue);
        maxValue = self.timeLinesModel.prevClose + (self.timeLinesModel.prevClose - minValue);
    }
    
    self.maxValue = maxValue;
    self.minValue = minValue;
}

/**
 转换坐标点
 */
- (void)covertToPoint {
    //将View的宽度分成1440
    CGFloat unitW = CGRectGetWidth(self.frame) / 1440;
    CGFloat unitValue = (self.maxValue - self.minValue) / (CGRectGetHeight(self.frame) - timePointH);
    
    [self.pointArray removeAllObjects];
    //遍历数据模型
    [self.timeLinesModel.trend enumerateObjectsUsingBlock:^(TLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * unitW;
        //生成分时线坐标点
        CGPoint linePoint = CGPointMake(x, ABS(CGRectGetMaxY(self.frame) - timePointH) - (model.close - self.minValue)/ unitValue);
        //生成均线坐标点
        CGPoint avgPoint = CGPointMake(x, ABS(CGRectGetMaxY(self.frame) - timePointH) - (model.avg - self.minValue)/ unitValue);
        
        FLTimePointModel *pointModel = [FLTimePointModel new];
        pointModel.closePoint = linePoint;
        pointModel.avgPoint = avgPoint;
        [self.pointArray addObject:pointModel];
    }];
}

/**
 绘制分时线和背景区域
 */
- (void)drawTimeLine {
    [self covertToPoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    UIBezierPath *timeLinePath = [UIBezierPath bezierPath];
    
    //绘制分时线
    FLTimePointModel *firstModel = self.pointArray.firstObject;
    [timeLinePath moveToPoint:firstModel.closePoint];
    for (int i = 1; i< self.pointArray.count; i++)
    {
        FLTimePointModel *model = self.pointArray[i];
        [timeLinePath addLineToPoint:model.closePoint];
    }
    lineLayer.path = timeLinePath.CGPath;
    lineLayer.lineWidth = 0.4f;
    lineLayer.strokeColor = [UIColor colorWithRed:100.f/255.f green:149.f/255.f blue:237.f/255.f alpha:1.f].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    //绘制背景区域
    FLTimePointModel *lastModel = [self.pointArray lastObject];
    [timeLinePath addLineToPoint:CGPointMake(lastModel.closePoint.x, CGRectGetHeight(self.frame) - timePointH)];
    [timeLinePath addLineToPoint:CGPointMake(firstModel.closePoint.x, CGRectGetHeight(self.frame)- timePointH)];
    fillLayer.path = timeLinePath.CGPath;
    fillLayer.fillColor = [UIColor colorWithRed:135.f/255.f green:206.f/255.f blue:250.f/255.f alpha:0.5f].CGColor;
    fillLayer.strokeColor = [UIColor clearColor].CGColor;
    fillLayer.zPosition -= 1;
    
    [self.layer addSublayer:lineLayer];
    [self.layer addSublayer:fillLayer];
    
//    //绘制均线
//    [self drawAvgLineWithPointArr:self.pointArray];
//    
//    //绘制呼吸灯
//    [self drawBreathingLightWithPoint:lastModel.linePoint];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
