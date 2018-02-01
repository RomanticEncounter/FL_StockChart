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
//        self.backgroundColor = [UIColor colorWithRed:40/255.0 green:43/255.0 blue:53/255.0 alpha:1];
        [self drawBorderLayer];
    }
    return self ;
}

- (void)startDraw {
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
//    if (ABS(maxValue - self.timeLinesModel.prevClose) >= ABS(self.timeLinesModel.prevClose - minValue)) {
//        maxValue = maxValue - self.timeLinesModel.prevClose + gapValue + self.timeLinesModel.prevClose;
//        minValue = self.timeLinesModel.prevClose - (maxValue - self.timeLinesModel.prevClose);
//
//    } else {
//        minValue = self.timeLinesModel.prevClose - (self.timeLinesModel.prevClose - minValue + gapValue);
//        maxValue = self.timeLinesModel.prevClose + (self.timeLinesModel.prevClose - minValue);
//    }
    
    
    self.maxValue = maxValue + gapValue;
    self.minValue = minValue - gapValue;
}

/**
 转换坐标点
 */
- (void)covertToPoint {
    //将View的宽度分成240
    CGFloat unitW = CGRectGetWidth(self.frame) / 240;
    CGFloat unitH = (self.maxValue - self.minValue) / (CGRectGetHeight(self.frame) - timePointH);
    
    [self.pointArray removeAllObjects];
    //遍历数据模型
    [self.timeLinesModel.trend enumerateObjectsUsingBlock:^(TLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * unitW;
        //生成分时线坐标点
        CGPoint linePoint = CGPointMake(x, (CGRectGetHeight(self.frame) - timePointH) - ((model.close - self.minValue) / unitH));
        //生成均线坐标点
        CGPoint avgPoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - timePointH) - (model.avg - self.minValue)/ unitH);
        
//        CGPoint yPoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - timePointH) - (self.timeLinesModel.prevClose - self.minValue)/ unitH);
        
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
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    UIBezierPath *timeLinePath = [UIBezierPath bezierPath];
    
    //绘制分时线
    FLTimePointModel *firstModel = self.pointArray.firstObject;
    [timeLinePath moveToPoint:firstModel.closePoint];
    for (int i = 1; i < self.pointArray.count; i++)
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
    
    //绘制均线
    [self drawAvgLineWithPointArray:self.pointArray];

    //绘制呼吸灯
//    [self drawBreathingLightWithPoint:lastModel.linePoint];
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
    for (int i = 1; i < avgPointArray.count; i++)
    {
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
 绘制x轴时间点
 */
- (void)drawTimePointLayer {
    //坐标点数组
    NSArray *timePointArr = @[@"09:30", @"10:10", @"10:50", @"11:30/13:00", @"13:40", @"14:20", @"15:00"];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    
    float unitW = CGRectGetWidth(self.frame) / 6;
    //循环绘制坐标点
    for (int idx = 0; idx < timePointArr.count; idx++) {
        CGRect strRect = [self rectOfNSString:timePointArr[idx] attribute:attribute];
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
 工具类:根据字符串和富文本属性来生成rect
 
 @param string 字符串
 @param attribute 富文本属性
 @return 返回生成的rect
 */
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
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
    CGRect priceRect = [self rectOfNSString:[NSString stringWithFormat:@"%.2f", self.timeLinesModel.prevClose] attribute:attribute];
    CGRect perRect   = [self rectOfNSString:@"-00.00%" attribute:attribute];
    
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
        NSString *rightStr = [NSString stringWithFormat:@"%.2f%%", (self.maxValue - idx * unitPrice - self.timeLinesModel.prevClose)/self.timeLinesModel.prevClose];
        
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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
