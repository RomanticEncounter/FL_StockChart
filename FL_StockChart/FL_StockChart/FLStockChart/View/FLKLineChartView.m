//
//  FLKLineChartView.m
//  FL_StockChart
//
//  Created by mac on 2018/3/8.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLKLineChartView.h"
#import "FLStockModel.h"
#import "FLStockChartPointModel.h"
#import "CAShapeLayer+FLCandleLayer.h"

@interface FLKLineChartView ()

@property (nonatomic, strong) CAShapeLayer *candleLayer;
/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*models;

/**
 转换成坐标点数组
 */
@property (nonatomic, strong) NSMutableArray *pointArray;

/**
 开始索引
 */
@property (nonatomic, assign) NSInteger startIndex;
/**
 结束索引
 */
@property (nonatomic, assign) NSInteger endIndex;

/**
 当前最大值
 */
@property (nonatomic, assign) float maxValue;
/**
 当前最小值
 */
@property (nonatomic, assign) float minValue;

@end

//x轴时间点高
static CGFloat timePointH = 20.f;
static NSInteger candleCount = 60;

@implementation FLKLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pointArray = [NSMutableArray array];
//        self.models = models;
        [self drawKLineChartBorderLayer];
    }
    return self;
}

- (void)setKLineChartWithModel:(NSArray <FLStockModel *>*)models {
    _models = models;
    //设置起始索引
    _startIndex = models.count - candleCount-1;
    _endIndex = models.count;
}

/**
 绘制K线图
 */
- (void)drawKLineChart {
    //求出最大最小值
    _minValue = (float)INT32_MAX;
    _maxValue = (float)INT32_MIN;
    for (NSInteger idx = _startIndex; idx < _endIndex; idx++) {
        FLStockModel *model = self.models[idx];
        if (_minValue > model.Low.floatValue) {
            _minValue = model.Low.floatValue;
        }
        if (_maxValue < model.High.floatValue) {
            _maxValue = model.High.floatValue;
        }
    }
    //高度
    CGFloat unitValue = (_maxValue - _minValue) / (CGRectGetHeight(self.frame) - timePointH);
    [self conversionCandlePointWithUnitValue:unitValue];
    [self drawCandleWithPointModels:self.pointArray];
}

/**
 转换蜡烛图坐标点
 
 @param unitValue 单位值
 */
- (void)conversionCandlePointWithUnitValue:(CGFloat)unitValue
{
    [self.pointArray removeAllObjects];
    
    CGFloat candleW = (CGRectGetWidth(self.frame) - timePointH) / candleCount;
    
    for (NSInteger idx = _startIndex; idx < _endIndex; idx ++) {
        FLStockModel *model = self.models[idx];
        CGFloat x = CGRectGetWidth(self.frame) + candleW * (idx - (_startIndex - 0));
        
        CGPoint highPoint = CGPointMake(x + candleW / 2,
                                     ABS((CGRectGetHeight(self.frame) - timePointH) - (model.High.floatValue - _minValue) / unitValue));
        CGPoint lowPoint = CGPointMake(x + candleW / 2,
                                     ABS((CGRectGetHeight(self.frame) - timePointH) - (model.Low.floatValue - _minValue) / unitValue));
        CGPoint openPoint = CGPointMake(x + candleW/2,
                                     ABS((CGRectGetHeight(self.frame) - timePointH) - (model.Open.floatValue - _minValue) / unitValue));
        CGPoint closePoint = CGPointMake(x + candleW/2,
                                     ABS((CGRectGetHeight(self.frame) - timePointH) - (model.Close.floatValue - _minValue) / unitValue));
        FLKLinePointModel *kLinePointModel = [self candlePointModelWithOpenPoint:openPoint HighPoint:highPoint LowPoint:lowPoint ClosePoint:closePoint];
        [self.pointArray addObject:kLinePointModel];
    }
}

/**
 绘制蜡烛线
 
 @param pointModelArr 坐标点模型数组
 */
- (void)drawCandleWithPointModels:(NSArray *)pointModelArr {
    
    CGFloat candleW = CGRectGetWidth(self.frame) / candleCount;
    
    for (int idx = 0; idx < candleCount; idx++) {
        FLKLinePointModel *model = self.pointArray[idx];
        CAShapeLayer *layer = [CAShapeLayer getCandleLayerWithPointModel:model CandleWidth:candleW];
        [self.candleLayer addSublayer:layer];
    }
    [self.layer addSublayer:self.candleLayer];
}



/**
 绘制边框
 */
- (void)drawKLineChartBorderLayer {
    //初始化坐标点
    CGFloat startFrameX = 0.f;
    CGFloat startFrameY = 0.f;
    CGFloat borderFrameW = CGRectGetWidth(self.frame);
    //减去底部时间的高度20
    CGFloat borderFrameH = CGRectGetHeight(self.frame) - timePointH;
    CGRect borderRect = CGRectMake(startFrameX, startFrameY, borderFrameW, borderFrameH);
    
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:borderRect];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGFloat unitW = borderFrameW / 4;
    CGFloat unitH = borderFrameH / 4;
    //绘制7条竖线
    for (NSInteger i = 0; i < 5; i ++) {
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
 创建蜡烛图坐标点Model

 @param openPoint 开
 @param highPoint 高
 @param lowPoint 低
 @param closePoint 收
 @return FLKLinePointModel
 */
- (FLKLinePointModel *)candlePointModelWithOpenPoint:(CGPoint)openPoint
                                           HighPoint:(CGPoint)highPoint
                                            LowPoint:(CGPoint)lowPoint
                                          ClosePoint:(CGPoint)closePoint {
    FLKLinePointModel *pointModel = [FLKLinePointModel new];
    pointModel.openPoint = openPoint;
    pointModel.highPoint = highPoint;
    pointModel.lowPoint = lowPoint;
    pointModel.closePoint = closePoint;
    return pointModel;
}

#pragma mark - Lazy
- (CAShapeLayer *)candleLayer {
    if (!_candleLayer) {
        _candleLayer = [CAShapeLayer layer];
    }
    return _candleLayer;
}

@end
