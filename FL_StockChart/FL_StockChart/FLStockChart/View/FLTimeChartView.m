//
//  FLTimeChartView.m
//  FL_StockChart
//
//  Created by mac on 2018/3/5.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLTimeChartView.h"
//#import "FLStockGroupModel.h"
#import "FLStockModel.h"
#import "FLStockChartPointModel.h"
#import "CATextLayer+TimeTextLayer.h"
#import "CAShapeLayer+FLCrossLayer.h"
#import "FLStockChartManager.h"



@interface FLTimeChartView ()
/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*models;
/**
 昨收
 */
@property (nonatomic, copy) NSNumber *yesterdayClose;
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
/**
 十字叉
 */
@property (nonatomic, strong) CAShapeLayer *crossLayer;
@end

//x轴时间点高
static CGFloat timePointH = 20.f;

@implementation FLTimeChartView

- (instancetype)initWithFrame:(CGRect)frame StockGroupModel:(NSArray *)models {
    self = [super initWithFrame:frame];
    if (self) {
        self.pointArray = [NSMutableArray array];
        self.models = models;
        FLStockModel *firstModel = models.firstObject;
        self.yesterdayClose = firstModel.YesterdayClose;
        [self drawTimeChartBorderLayer];
        [self addTimeChartLongGestureAction];
    }
    return self;
}

- (void)startDrawTimeChart {
     //获取极限值
     [self findMaxMinValue];
     //转换坐标点
     [self covertToPoint];
     //绘制时间点
     [self drawTimePointLayer];
     //绘制价格范围
     [self drawPriceRange];
     //绘制分时线、均线、呼吸灯
     [self drawTimeLine];
}

/**
 添加分时图长按手势
 */
- (void)addTimeChartLongGestureAction {
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timeChartLongGestureAction:)];
    longGesture.minimumPressDuration = 0.5f;
    longGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:longGesture];
}

/**
 绘制边框
 */
- (void)drawTimeChartBorderLayer {
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
 寻找极限值
 */
- (void)findMaxMinValue {
    
    double avgMax = [[[self.models valueForKeyPath:@"Avg"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double avgMin = [[[self.models valueForKeyPath:@"Avg"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
    double closeMax = [[[self.models valueForKeyPath:@"Close"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double closeMin = [[[self.models valueForKeyPath:@"Close"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
    
    double maxValue = avgMax == 0 ? closeMax : fmax(avgMax, closeMax);
    double minValue = avgMin == 0 ? closeMin :fmin(avgMin, closeMin);
    
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
    /*
     if (ABS(maxValue - self.timeLinesModel.prevClose) >= ABS(self.timeLinesModel.prevClose - minValue)) {
     maxValue = maxValue - self.timeLinesModel.prevClose + gapValue + self.timeLinesModel.prevClose;
     minValue = self.timeLinesModel.prevClose - (maxValue - self.timeLinesModel.prevClose);
     
     } else {
     minValue = self.timeLinesModel.prevClose - (self.timeLinesModel.prevClose - minValue + gapValue);
     maxValue = self.timeLinesModel.prevClose + (self.timeLinesModel.prevClose - minValue);
     }
     */
    if (ABS(maxValue - self.yesterdayClose.floatValue) >= ABS(self.yesterdayClose.floatValue - minValue)) {
        maxValue = maxValue + gapValue;
        minValue = self.yesterdayClose.floatValue - (maxValue -self.yesterdayClose.floatValue);
    } else {
        minValue = minValue - gapValue;
        maxValue = self.yesterdayClose.floatValue + (self.yesterdayClose.floatValue - minValue);
    }
    self.maxValue = maxValue;
    self.minValue = minValue;
    //    self.maxValue = maxValue + gapValue;
    //    self.minValue = minValue - gapValue;
}

/**
 转换坐标点
 */
- (void)covertToPoint {
    //将View的宽度分成1440
    CGFloat unitW = CGRectGetWidth(self.frame) / minutesCount;
    CGFloat unitH = (self.maxValue - self.minValue) / (CGRectGetHeight(self.frame) - timePointH);
    
    [self.pointArray removeAllObjects];
    //遍历数据模型
    [self.models enumerateObjectsUsingBlock:^(FLStockModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * unitW;
        //生成分时线坐标点
        CGPoint linePoint = CGPointMake(x, (CGRectGetHeight(self.frame) - timePointH) - ((model.Close.floatValue - self.minValue) / unitH));
        //生成均线坐标点
        CGPoint avgPoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - timePointH) - (model.Avg.floatValue - self.minValue)/ unitH);
        
        //        CGPoint yPoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - timePointH) - (self.timeLinesModel.prevClose - self.minValue)/ unitH);
        
        FLTimePointModel *pointModel = [FLTimePointModel new];
        pointModel.closePoint = linePoint;
        pointModel.avgPoint = avgPoint;
        [self.pointArray addObject:pointModel];
    }];
}

/**
 绘制x轴时间点
 */
- (void)drawTimePointLayer {
    //坐标点数组
    NSArray *timePointArr = @[@"09:30", @"10:30", @"11:30", @"13:30", @"15:00"];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    
    float unitW = CGRectGetWidth(self.frame) / 4;
    //循环绘制坐标点
    for (int idx = 0; idx < timePointArr.count; idx++) {
        CGRect strRect = [FLStockChartSharedManager rectOfNSString:timePointArr[idx] attribute:attribute];
        CGFloat strW = CGRectGetWidth(strRect);
        CGFloat strH = CGRectGetHeight(strRect);
        CATextLayer *textLayer = nil;
        
        if(idx == 0) {//第一个
            CGRect rect = CGRectMake(idx * unitW, CGRectGetHeight(self.frame)-timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:timePointArr[idx] textColor:[UIColor grayColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        } else if (idx == timePointArr.count - 1) {//最后一个
            CGRect rect = CGRectMake(idx * unitW - strW, CGRectGetHeight(self.frame)-timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:timePointArr[idx] textColor:[UIColor grayColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        } else {//中间
            CGRect rect = CGRectMake(idx * unitW - strW/2, CGRectGetHeight(self.frame)-timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:timePointArr[idx] textColor:[UIColor grayColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }
        
        [self.layer addSublayer:textLayer];
    }
}

/**
 绘制价格区间
 */
- (void)drawPriceRange {
    //生成单位单价  和 单位高
    double unitPrice = (self.maxValue - self.minValue) / 4.f;
    double unitH = (CGRectGetHeight(self.frame) - timePointH) / 4.f;
    
    //求得价格和百分比的rect
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect priceRect = [FLStockChartSharedManager rectOfNSString:[NSString stringWithFormat:@"%.2f", self.yesterdayClose.floatValue] attribute:attribute];
    CGRect perRect   = [FLStockChartSharedManager rectOfNSString:@"-00.00%" attribute:attribute];
    
    //循环绘制5行数据
    //左边是价格  右边是百分比
    for (int idx = 0; idx < 5; idx ++) {
        CGFloat rectY = 0.f;
        if (idx == 0) {
            rectY = idx * unitH;
        } else if (idx == 4) {
            rectY = idx * unitH - CGRectGetHeight(priceRect);
        } else {
            rectY = idx * unitH - CGRectGetHeight(priceRect) / 2;
        }
        CGRect leftRect = CGRectMake(0,
                                     rectY,
                                     CGRectGetWidth(priceRect),
                                     CGRectGetHeight(priceRect));
        CGRect rightRect = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(perRect),
                                      rectY,
                                      CGRectGetWidth(perRect),
                                      CGRectGetHeight(perRect));
        //计算价格和百分比
        NSString *leftStr = [NSString stringWithFormat:@"%.2f", self.maxValue - idx * unitPrice];
        NSString *rightStr = [NSString stringWithFormat:@"%.2f%%", (self.maxValue - idx * unitPrice - self.yesterdayClose.floatValue)/self.yesterdayClose.floatValue];
        
        CATextLayer *leftLayer = [CATextLayer getTextLayerWithString:leftStr
                                                           textColor:[UIColor grayColor]
                                                            fontSize:9.f
                                                     backgroundColor:[UIColor clearColor]
                                                               frame:leftRect];
        CATextLayer *rightLayer = [CATextLayer getTextLayerWithString:rightStr
                                                            textColor:[UIColor grayColor]
                                                             fontSize:9.f
                                                      backgroundColor:[UIColor clearColor]
                                                                frame:rightRect];
        
        [self.layer addSublayer:leftLayer];
        [self.layer addSublayer:rightLayer];
    }
}

/**
 绘制分时线和背景区域
 */
- (void)drawTimeLine {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    UIBezierPath *timeLinePath = [UIBezierPath bezierPath];
    
    //绘制分时线
    FLTimePointModel *firstModel = self.pointArray.firstObject;
    [timeLinePath moveToPoint:firstModel.closePoint];
    for (int i = 1; i < self.pointArray.count; i ++) {
        FLTimePointModel *model = self.pointArray[i];
        [timeLinePath addLineToPoint:model.closePoint];
    }
    lineLayer.path = timeLinePath.CGPath;
    lineLayer.lineWidth = 0.4f;
    lineLayer.strokeColor = [UIColor colorWithRed:100.f/255.f green:149.f/255.f blue:237.f/255.f alpha:1.f].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    //绘制背景区域
    FLTimePointModel *lastModel = self.pointArray.lastObject;
    [timeLinePath addLineToPoint:CGPointMake(lastModel.closePoint.x, CGRectGetHeight(self.frame) - timePointH)];
    [timeLinePath addLineToPoint:CGPointMake(firstModel.closePoint.x, CGRectGetHeight(self.frame)- timePointH)];
    fillLayer.path = timeLinePath.CGPath;
    fillLayer.fillColor = [UIColor colorWithRed:135.f/255.f green:206.f/255.f blue:250.f/255.f alpha:0.5f].CGColor;
    fillLayer.strokeColor = [UIColor clearColor].CGColor;
    fillLayer.zPosition -= 1;
    
    [self.layer addSublayer:lineLayer];
    [self.layer addSublayer:fillLayer];
    
    //绘制均线
    [self drawAvgLineWithPointArray:self.pointArray];
    
    //绘制呼吸灯
    [self drawBreathingLightWithPoint:lastModel.closePoint];
}

/**
 绘制均价线
 
 @param avgPointArray 均价位置数组
 */
- (void)drawAvgLineWithPointArray:(NSArray *)avgPointArray {
    CAShapeLayer *avgLineLayer = [CAShapeLayer layer];
    UIBezierPath *avgLinePath = [UIBezierPath bezierPath];
    
    FLTimePointModel *firstPointModel = avgPointArray.firstObject;
    [avgLinePath moveToPoint:firstPointModel.avgPoint];
    for (int i = 1; i < avgPointArray.count; i ++) {
        FLTimePointModel *model = avgPointArray[i];
        [avgLinePath addLineToPoint:model.avgPoint];
    }
    avgLineLayer.path = avgLinePath.CGPath;
    avgLineLayer.lineWidth = 1.f;
    avgLineLayer.strokeColor = [UIColor colorWithRed:255.f/255.f green:215.f/255.f blue:0.f/255.f alpha:1.f].CGColor;
    avgLineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:avgLineLayer];
}

/**
 绘制呼吸灯
 */
- (void)drawBreathingLightWithPoint:(CGPoint)point {
    CALayer *layer = [CALayer layer];
    //设置任意位置
    layer.frame = CGRectMake(point.x, point.y, 3, 3);
    //设置呼吸灯的颜色
    layer.backgroundColor = [UIColor blueColor].CGColor;
    //设置好半径
    layer.cornerRadius = 1.5;
    //给当前图层添加动画组
    [layer addAnimation:[self createBreathingLightAnimationWithTime:2] forKey:nil];
    
    [self.layer addSublayer:layer];
}

/**
 生成动画
 
 @param time 动画单词持续时间
 @return 返回动画组
 */
- (CAAnimationGroup *)createBreathingLightAnimationWithTime:(double)time {
    //实例化CABasicAnimation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //从1开始
    scaleAnimation.fromValue = @1;
    //到3.5
    scaleAnimation.toValue = @3.5;
    //结束后不执行逆动画
    scaleAnimation.autoreverses = NO;
    //无限循环
    scaleAnimation.repeatCount = HUGE_VALF;
    //一次执行time秒
    scaleAnimation.duration = time;
    //结束后从渲染树删除，变回初始状态
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0;
    opacityAnimation.toValue = @0;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.duration = time;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = time;
    group.autoreverses = NO;
    group.animations = @[scaleAnimation, opacityAnimation];
    group.repeatCount = HUGE_VALF;
    //这里也应该设置removedOnCompletion和fillMode属性，以具体情况而定
    
    return group;
}


/**
 绘制十字叉
 
 @param point 长按时获取到的坐标点
 */
- (void)drawCrossWithPoint:(CGPoint)point {
    //先清理十字叉图层再添加
    [self clearCrossLayer];
    
    //根据坐标计算索引
    float unitW = CGRectGetWidth(self.frame) / minutesCount;
    int index = (int)(point.x / unitW);
    if (index >= self.models.count) {
        index = (int)self.models.count - 1;
    }
    FLTimePointModel *pointModel = self.pointArray[index];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //竖线
    [path moveToPoint:CGPointMake(pointModel.closePoint.x, 0)];
    [path addLineToPoint:CGPointMake(pointModel.closePoint.x, CGRectGetHeight(self.frame)-timePointH)];
    //横线
    [path moveToPoint:CGPointMake(0, pointModel.closePoint.y)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), pointModel.closePoint.y)];
    //设置横竖线的属性
    self.crossLayer.path = path.CGPath;
    self.crossLayer.lineWidth = 0.5f;
    self.crossLayer.strokeColor = [UIColor blackColor].CGColor;
    self.crossLayer.fillColor = [UIColor clearColor].CGColor;
    //画虚线
    self.crossLayer.lineCap = @"square";
    self.crossLayer.lineDashPattern = @[@9, @4];
    //交叉小红点
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pointModel.closePoint.x - 1.5, pointModel.closePoint.y - 1.5, 3, 3) cornerRadius:1.5];
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.path = roundPath.CGPath;
    roundLayer.lineWidth = 0.5f;
    roundLayer.strokeColor = [UIColor grayColor].CGColor;
    roundLayer.fillColor = [UIColor redColor].CGColor;
    
    
    //取出数据模型
    FLStockModel *model = self.models[index];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    //计算各种rect
    
    //    NSString *timeStr = [NSString stringWithFormat:@"%d:%d", model.min / 60, model.min % 60];
    NSString *timeStr = [FLStockChartSharedManager timeConversionToDate:model.Date];//[NSString stringWithFormat:@"时间:%@",[self dateConversionToString:model.Date]];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", model.Close.floatValue];
    //    NSString *perStr = [NSString stringWithFormat:@"%.2f%%", (self.maxValue - model.close - self.timeLinesModel.prevClose) / self.timeLinesModel.prevClose];
    NSString *perStr = [NSString stringWithFormat:@"%.2f%%", (model.Close.floatValue - self.yesterdayClose.floatValue) / self.yesterdayClose.floatValue];
    CGRect timeStrRect = [FLStockChartSharedManager rectOfNSString:timeStr attribute:attribute];
    CGRect priceStrRect = [FLStockChartSharedManager rectOfNSString:priceStr attribute:attribute];
    CGRect perStrRect = [FLStockChartSharedManager rectOfNSString:perStr attribute:attribute];
    
    CGRect maskTimeRect = CGRectMake(pointModel.closePoint.x - CGRectGetWidth(timeStrRect)/2-5.f,
                                     CGRectGetHeight(self.frame) - timePointH,
                                     CGRectGetWidth(timeStrRect)+10.f,
                                     CGRectGetHeight(timeStrRect) + 5.f);
    CGRect maskPriceRect = CGRectMake(0,
                                      pointModel.closePoint.y - CGRectGetHeight(priceStrRect)/2 - 2.5f,
                                      CGRectGetWidth(priceStrRect) + 10.f,
                                      CGRectGetHeight(priceStrRect) + 5.f);
    CGRect maskPerRect = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(perStrRect) - 10.f,
                                    pointModel.closePoint.y - CGRectGetHeight(priceStrRect) / 2 - 2.5f,
                                    CGRectGetWidth(perStrRect) + 10.f, CGRectGetHeight(perStrRect)+5.f);
    
    CGRect timeRect = CGRectMake(CGRectGetMinX(maskTimeRect) + 5.f, CGRectGetMinY(maskTimeRect)+2.5f, CGRectGetWidth(timeStrRect), CGRectGetHeight(timeStrRect));
    CGRect priceRect = CGRectMake(CGRectGetMinX(maskPriceRect)+5.f, CGRectGetMinY(maskPriceRect)+2.5f, CGRectGetWidth(priceStrRect), CGRectGetHeight(priceStrRect));
    CGRect perRect = CGRectMake(CGRectGetMinX(maskPerRect)+5.f, CGRectGetMinY(maskPerRect)+2.5f, CGRectGetWidth(perStrRect), CGRectGetHeight(perStrRect));
    //生成时间方块图层
    CAShapeLayer *timeLayer = [CAShapeLayer getRectLayerWithRect:maskTimeRect dateRect:timeRect dateStr:timeStr fontSize:9.f textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]];
    //生成价格方块图层
    CAShapeLayer *priceLayer = [CAShapeLayer getRectLayerWithRect:maskPriceRect dateRect:priceRect dateStr:priceStr fontSize:9.f textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]];
    //生成百分比方块图层
    CAShapeLayer *perLayer = [CAShapeLayer getRectLayerWithRect:maskPerRect dateRect:perRect dateStr:perStr fontSize:9.f textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]];
    //把4个图层全部添加到十字叉图层中
    [self.crossLayer addSublayer:roundLayer];
    [self.crossLayer addSublayer:timeLayer];
    [self.crossLayer addSublayer:priceLayer];
    [self.crossLayer addSublayer:perLayer];
    //再添加到分时图view的图层中
    [self.layer addSublayer:self.crossLayer];
    
}


/**
 长按手势
 
 @param longGesture 长按
 */
- (void)timeChartLongGestureAction:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateBegan || longGesture.state == UIGestureRecognizerStateChanged) {
        //第一次长按获取 或者 长按然后变化坐标点
        //获取坐标
        CGPoint point = [longGesture locationInView:self];
        
        CGFloat x = 0.f;
        CGFloat y = 0.f;
        //判断临界情况
        if (point.x < 0) {
            x = 0.f;
        } else if (point.x == CGRectGetWidth(self.frame)) {
            x = CGRectGetWidth(self.frame);
        } else {
            x = point.x;
        }
        if (point.y < 0) {
            y = 0.f;
        } else if (point.y > (CGRectGetHeight(self.frame) - 20.f)) {
            y = CGRectGetHeight(self.frame) - 20.f;
        } else {
            y = point.y;
        }
        //开始绘制十字叉
        [self drawCrossWithPoint:CGPointMake(x, y)];
    } else {
        //事件取消
        //当抬起头后，清理十字叉
        [self clearCrossLayer];
    }
}

/**
 清理长按响应图层
 */
- (void)clearCrossLayer {
    //清理十字叉图层
    [self.crossLayer removeFromSuperlayer];
    self.crossLayer = nil;
    //    self.ticksLayer.sublayers = nil;
}

- (CAShapeLayer *)crossLayer {
    if (!_crossLayer) {
        _crossLayer = [CAShapeLayer layer];
    }
    return _crossLayer;
}



@end
