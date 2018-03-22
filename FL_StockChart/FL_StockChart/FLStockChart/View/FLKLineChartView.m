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
#import "CAShapeLayer+FLMALineLayer.h"
#import "CATextLayer+TimeTextLayer.h"
#import "CAShapeLayer+FLCrossLayer.h"
#import "UIColor+FLStockChartTheme.h"
#import "FLStockChartManager.h"


@interface FLKLineChartView () <UIScrollViewDelegate>

/**
 蜡烛
 */
@property (nonatomic, strong) CAShapeLayer *candleLayer;
/**
 MA指标
 */
@property (nonatomic, strong) CAShapeLayer *maLineLayer;
/**
 时间
 */
@property (nonatomic, strong) CAShapeLayer *dateLayer;
/**
 左侧价格
 */
@property (nonatomic, strong) CAShapeLayer *leftPriceLayer;
/**
 十字叉
 */
@property (nonatomic, strong) CAShapeLayer *crossLayer;
/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*models;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <FLStockModel *> *needDrawKLineModels;

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
@property (nonatomic, assign) CGFloat maxValue;
/**
 当前最小值
 */
@property (nonatomic, assign) CGFloat minValue;
/**
 滑动视图
 */
@property (nonatomic, strong) UIScrollView *kLineScrollView;
/**
 *  捏合点
 */
@property (nonatomic, assign) NSInteger pinchStartIndex;
/**
 蜡烛图个数
 */
@property (nonatomic, assign) NSInteger candleCount;
@end

//x轴时间点高
static CGFloat timePointH = 20.f;

@implementation FLKLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pointArray = [NSMutableArray array];
        self.needDrawKLineModels = [NSMutableArray array];
        [self drawKLineChartBorderLayer];
        [self addKLineChartLongGestureAction];
    }
    return self;
}

/**
 更新K线图ScrollView的宽度
 */
- (void)updateKLineChartScrollViewContentWidth {
    //设置scrollView的总Contensize
    //补一个蜡烛图的宽度
    CGFloat scrollViewContentWidth = self.models.count * [FLStockChartSharedManager kLineWidth] + (self.models.count + 1) * [FLStockChartSharedManager kLineGap] + [FLStockChartSharedManager kLineWidth];
    self.kLineScrollView.contentSize = CGSizeMake(scrollViewContentWidth, CGRectGetHeight(self.frame) - timePointH);
    //设置偏移的位置
    [self.kLineScrollView setContentOffset:CGPointMake(scrollViewContentWidth - CGRectGetWidth(self.frame), 0)];
}

/**
 提取需要绘制的数组
 */
- (void)private_extractNeedDrawModels {
    CGFloat lineGap = [FLStockChartSharedManager kLineGap];
    CGFloat lineWidth = [FLStockChartSharedManager kLineWidth];
    CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
    //当前一屏幕能画多少个蜡烛
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap) / (lineGap + lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex;
    if (self.pinchStartIndex > 0) {
        needDrawKLineStartIndex = self.pinchStartIndex;
        _startIndex = self.pinchStartIndex;
        self.pinchStartIndex = -1;
    } else {
        needDrawKLineStartIndex = self.startIndex;
    }
    NSLog(@"这是模型开始的index-----------%ld",needDrawKLineStartIndex);
    [self.needDrawKLineModels removeAllObjects];
    //赋值数组
    if(needDrawKLineStartIndex < self.models.count) {
        if(needDrawKLineStartIndex + needDrawKLineCount < self.models.count) {
            [self.needDrawKLineModels addObjectsFromArray:[self.models subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
        } else {
            [self.needDrawKLineModels addObjectsFromArray:[self.models subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.models.count - needDrawKLineStartIndex)]];
        }
        //数据源传值
        if (self.delegate && [self.delegate respondsToSelector:@selector(FL_KLineCharExtractNeedDrawModels:)]) {
            [self.delegate FL_KLineCharExtractNeedDrawModels:self.needDrawKLineModels];
        }
    }
}

/**
 将model转化为Point模型
 */
- (void)private_converToKLinePointModels {
    if(!self.needDrawKLineModels) {
        return ;
    }
    NSArray *kLineModels = self.needDrawKLineModels;
    self.candleCount = kLineModels.count;
    //计算最小单位
    FLStockModel *firstModel = kLineModels.firstObject;
    __block CGFloat minAssert = firstModel.Low.floatValue;
    __block CGFloat maxAssert = firstModel.High.floatValue;
    [kLineModels enumerateObjectsUsingBlock:^(FLStockModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (minAssert > obj.Low.floatValue) {
            minAssert = obj.Low.floatValue;
        }
        if (maxAssert < obj.High.floatValue) {
            maxAssert = obj.High.floatValue;
        }
        if (obj.MA10) {
            if (minAssert > obj.MA10.floatValue) {
                minAssert = obj.MA10.floatValue;
            }
            if (maxAssert < obj.MA10.floatValue) {
                maxAssert = obj.MA10.floatValue;
            }
        }
        if (obj.MA20) {
            if (minAssert > obj.MA20.floatValue) {
                minAssert = obj.MA20.floatValue;
            }
            if (maxAssert < obj.MA20.floatValue) {
                maxAssert = obj.MA20.floatValue;
            }
        }
        if (obj.MA30) {
            if (minAssert > obj.MA30.floatValue) {
                minAssert = obj.MA30.floatValue;
            }
            if (maxAssert < obj.MA30.floatValue) {
                maxAssert = obj.MA30.floatValue;
            }
        }
    }];
    _minValue = minAssert;
    _maxValue = maxAssert;
    //高度差
    CGFloat unitValue = (maxAssert - minAssert) / (CGRectGetHeight(self.frame) - timePointH);
    [self.pointArray removeAllObjects];
    
    for (NSInteger idx = 0 ; idx < kLineModels.count; ++idx) {
        FLStockModel *model = kLineModels[idx];
        CGFloat x = CGRectGetMinX(self.frame) + (FLStockChartSharedManager.kLineGap + FLStockChartSharedManager.kLineWidth) * idx + FLStockChartSharedManager.kLineGap;
        
        CGPoint highPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.High.floatValue - _minValue) / unitValue));
        
        CGPoint lowPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.Low.floatValue - _minValue) / unitValue));
        
        CGPoint openPoint = CGPointMake(x, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.Open.floatValue - _minValue) / unitValue));
        
        CGPoint closePoint = CGPointMake(x, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.Close.floatValue - _minValue) / unitValue));
        
        CGPoint ma10Point = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.MA10.floatValue - _minValue) / unitValue));
        
        CGPoint ma20Point = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.MA20.floatValue - _minValue) / unitValue));
        CGPoint ma30Point = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - timePointH) - (model.MA30.floatValue - _minValue) / unitValue));
        
        FLKLinePointModel *kLinePointModel = [self candlePointModelWithOpenPoint:openPoint HighPoint:highPoint LowPoint:lowPoint ClosePoint:closePoint];
        kLinePointModel.ma10Point = ma10Point;
        kLinePointModel.ma20Point = ma20Point;
        kLinePointModel.ma30Point = ma30Point;
        [self.pointArray addObject:kLinePointModel];
    }
}

/**
 开始的位置

 @return 开始的位置
 */
- (NSInteger)startIndex {
    CGFloat scrollViewOffsetX = self.kLineScrollView.contentOffset.x < 0 ? 0 : self.kLineScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - [FLStockChartSharedManager kLineGap]) / ([FLStockChartSharedManager kLineGap] + [FLStockChartSharedManager kLineWidth]);
    _startIndex = leftArrCount;
    return _startIndex;
}

- (void)setKLineChartWithModel:(NSArray <FLStockModel *>*)models {
    _models = models;
    [self updateKLineChartScrollViewContentWidth];
}

/**
 绘制K线图
 */
- (void)drawKLineChart {
    
    [self clearLayer];
    [self private_extractNeedDrawModels];
    [self private_converToKLinePointModels];
    [self drawCandleWithPointModels:self.pointArray];
    [self drawMALineWithPointModels:self.pointArray];
    [self drawBottomDateValue];
    [self drawLeftValue];
}


/**
 绘制蜡烛线
 
 @param pointModelArr 坐标点模型数组
 */
- (void)drawCandleWithPointModels:(NSArray *)pointModelArr {
    
    for (int idx = 0; idx < pointModelArr.count; idx++) {
        FLKLinePointModel *model = self.pointArray[idx];
        CAShapeLayer *layer = [CAShapeLayer getCandleLayerWithPointModel:model CandleWidth:FLStockChartSharedManager.kLineWidth];
        [self.candleLayer addSublayer:layer];
    }
    [self.layer addSublayer:self.candleLayer];
}

/**
 绘制均线

 @param pointModelArr 坐标点模型数组
 */
- (void)drawMALineWithPointModels:(NSArray *)pointModelArr {
    NSArray *ma10PointArray = [pointModelArr valueForKey:@"ma10Point"];
    NSArray *ma20PointArray = [pointModelArr valueForKey:@"ma20Point"];
    NSArray *ma30PointArray = [pointModelArr valueForKey:@"ma30Point"];
    CAShapeLayer *ma10LineLayer = [CAShapeLayer getMALineLayerWithPointArray:ma10PointArray LinesColor:[UIColor orangeColor]];
    CAShapeLayer *ma20LineLayer = [CAShapeLayer getMALineLayerWithPointArray:ma20PointArray LinesColor:[UIColor blueColor]];
    CAShapeLayer *ma30LineLayer = [CAShapeLayer getMALineLayerWithPointArray:ma30PointArray LinesColor:[UIColor purpleColor]];
    [self.maLineLayer addSublayer:ma10LineLayer];
    [self.maLineLayer addSublayer:ma20LineLayer];
    [self.maLineLayer addSublayer:ma30LineLayer];
    [self.layer addSublayer:self.maLineLayer];
}

/**
 绘制日期
 */
- (void)drawBottomDateValue {
    NSMutableArray *kLineDateArr = [NSMutableArray array];
    
    NSInteger unitCount = self.candleCount / 4;
    for (int idx = 0; idx < 5; idx++) {
        FLStockModel *model = self.models[_startIndex + idx * unitCount];
        NSDate *detaildate = model.Date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:detaildate];
        
        [kLineDateArr addObject:dateStr];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect strRect = [FLStockChartSharedManager rectOfNSString:@"0000-00-00" attribute:attribute];
    CGFloat strW = CGRectGetWidth(strRect);
    CGFloat strH = CGRectGetHeight(strRect);
    
    CGFloat unitW = CGRectGetWidth(self.frame) / 4;
    //循环绘制坐标点
    for (int idx = 0; idx < kLineDateArr.count; idx++) {
        CATextLayer *textLayer = nil;
        if (idx == kLineDateArr.count - 1) {//最后一个
            CGRect rect = CGRectMake(idx * unitW - strW, CGRectGetMaxY(self.frame) - timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:kLineDateArr[idx] textColor:[UIColor timeTextColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        } else if(idx == 0) {//第一个
            CGRect rect = CGRectMake(idx * unitW, CGRectGetMaxY(self.frame) - timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:kLineDateArr[idx] textColor:[UIColor timeTextColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        } else {//中间
            CGRect rect = CGRectMake(idx * unitW - strW/2, CGRectGetMaxY(self.frame) - timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:kLineDateArr[idx] textColor:[UIColor timeTextColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }
        [self.dateLayer addSublayer:textLayer];
    }
    [self.layer addSublayer:self.dateLayer];
}

/**
 绘制左侧价格
 */
- (void)drawLeftValue {
    CGFloat unitPrice = (_maxValue - _minValue) / 4.f;
    CGFloat unitH = (CGRectGetHeight(self.frame) - timePointH) / 4.f;
    
    //求得价格rect
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect priceRect = [FLStockChartSharedManager rectOfNSString:[NSString stringWithFormat:@"%.2f", _maxValue] attribute:attribute];
    
    for (int idx = 0; idx < 5; idx ++) {
        CGFloat height = 0.f;
        if (idx == 0) {
            height = idx * unitH;
        } else if (idx == 4) {
            height = idx * unitH - CGRectGetHeight(priceRect);
        } else {
            height = idx * unitH - CGRectGetHeight(priceRect)/2;
        }
        CGRect rect = CGRectMake(CGRectGetMinX(self.frame),
                                 CGRectGetMinY(self.frame) + height,
                                 CGRectGetWidth(priceRect),
                                 CGRectGetHeight(priceRect));
        //计算价格
        NSString *str = [NSString stringWithFormat:@"%.2f", _maxValue - idx * unitPrice];
        CATextLayer *layer = [CATextLayer getTextLayerWithString:str
                                                       textColor:[UIColor timeTextColor]
                                                        fontSize:9.f
                                                 backgroundColor:[UIColor clearColor]
                                                           frame:rect];
        
        [self.leftPriceLayer addSublayer:layer];
    }
    
    [self.layer addSublayer:self.leftPriceLayer];
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
    layer.strokeColor = [UIColor borderColor].CGColor;
    //填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
}

/**
 添加K线图长按手势
 */
- (void)addKLineChartLongGestureAction {
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(kLineChartLongGestureAction:)];
    longGesture.minimumPressDuration = 0.5f;
    longGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:longGesture];
}

/**
 长按手势
 
 @param longGesture 长按
 */
- (void)kLineChartLongGestureAction:(UILongPressGestureRecognizer *)longGesture {
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
        } else if (point.y > (CGRectGetHeight(self.frame) - timePointH)) {
            y = CGRectGetHeight(self.frame) - timePointH;
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
 绘制十字叉
 
 @param point 长按时获取到的坐标点
 */
- (void)drawCrossWithPoint:(CGPoint)point {
    //先清理十字叉图层再添加
    [self clearCrossLayer];
    
    //根据坐标计算索引
    CGFloat unitW = CGRectGetWidth(self.frame) / self.candleCount;
    int index = (int)(point.x / unitW);
    if (index >= self.pointArray.count) {
        index = (int)self.pointArray.count - 1;
    }
    FLTimePointModel *pointModel = self.pointArray[index];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //竖线
    [path moveToPoint:CGPointMake(pointModel.closePoint.x + FLStockChartSharedManager.kLineWidth / 2, 0)];
    [path addLineToPoint:CGPointMake(pointModel.closePoint.x + FLStockChartSharedManager.kLineWidth / 2, CGRectGetHeight(self.frame) - timePointH)];
    //横线
    [path moveToPoint:CGPointMake(0, pointModel.closePoint.y)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), pointModel.closePoint.y)];
    //设置横竖线的属性
    self.crossLayer.path = path.CGPath;
    self.crossLayer.lineWidth = 0.5f;
    self.crossLayer.strokeColor = [UIColor longPressLineColor].CGColor;
    self.crossLayer.fillColor = [UIColor clearColor].CGColor;
    //画虚线
    self.crossLayer.lineCap = @"square";
    self.crossLayer.lineDashPattern = @[@9, @4];
    //交叉小红点
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pointModel.closePoint.x + FLStockChartSharedManager.kLineWidth / 2 - 1.5, pointModel.closePoint.y - 1.5, 3, 3) cornerRadius:1.5];
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.path = roundPath.CGPath;
    roundLayer.lineWidth = 0.5f;
    roundLayer.strokeColor = [UIColor longPressLineColor].CGColor;
    roundLayer.fillColor = [UIColor longPressPointColor].CGColor;
    
    
    //取出数据模型
    FLStockModel *model = self.models[index + _startIndex];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    //计算各种rect
    
    //    NSString *timeStr = [NSString stringWithFormat:@"%d:%d", model.min / 60, model.min % 60];
    NSString *timeStr = [FLStockChartSharedManager timeConversionToDate:model.Date];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", model.Close.floatValue];
//    NSString *perStr = [NSString stringWithFormat:@"%.2f%%",(model.Close.floatValue - model.YesterdayClose.floatValue) / model.YesterdayClose.floatValue];
    CGRect timeStrRect = [FLStockChartSharedManager rectOfNSString:timeStr attribute:attribute];
    CGRect priceStrRect = [FLStockChartSharedManager rectOfNSString:priceStr attribute:attribute];
//    CGRect perStrRect = [FLStockChartSharedManager rectOfNSString:perStr attribute:attribute];
    
    CGRect maskTimeRect = CGRectMake(pointModel.closePoint.x - CGRectGetWidth(timeStrRect)/2-5.f,
                                     CGRectGetHeight(self.frame) - timePointH,
                                     CGRectGetWidth(timeStrRect)+10.f,
                                     CGRectGetHeight(timeStrRect) + 5.f);
    CGRect maskPriceRect = CGRectMake(0,
                                      pointModel.closePoint.y - CGRectGetHeight(priceStrRect)/2 - 2.5f,
                                      CGRectGetWidth(priceStrRect) + 10.f,
                                      CGRectGetHeight(priceStrRect) + 5.f);
//    CGRect maskPerRect = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(perStrRect) - 10.f,
//                                    pointModel.closePoint.y - CGRectGetHeight(priceStrRect) / 2 - 2.5f,
//                                    CGRectGetWidth(perStrRect) + 10.f, CGRectGetHeight(perStrRect)+5.f);
    
    CGRect timeRect = CGRectMake(CGRectGetMinX(maskTimeRect) + 5.f, CGRectGetMinY(maskTimeRect)+2.5f, CGRectGetWidth(timeStrRect), CGRectGetHeight(timeStrRect));
    CGRect priceRect = CGRectMake(CGRectGetMinX(maskPriceRect)+5.f, CGRectGetMinY(maskPriceRect)+2.5f, CGRectGetWidth(priceStrRect), CGRectGetHeight(priceStrRect));
//    CGRect perRect = CGRectMake(CGRectGetMinX(maskPerRect)+5.f, CGRectGetMinY(maskPerRect)+2.5f, CGRectGetWidth(perStrRect), CGRectGetHeight(perStrRect));
    //生成时间方块图层
    CAShapeLayer *timeLayer = [CAShapeLayer getRectLayerWithRect:maskTimeRect dateRect:timeRect dateStr:timeStr fontSize:9.f textColor:[UIColor timeTextColor] backgroundColor:[UIColor blackColor]];
    //生成价格方块图层
    CAShapeLayer *priceLayer = [CAShapeLayer getRectLayerWithRect:maskPriceRect dateRect:priceRect dateStr:priceStr fontSize:9.f textColor:[UIColor timeTextColor] backgroundColor:[UIColor blackColor]];
//    //生成百分比方块图层
//    CAShapeLayer *perLayer = [CAShapeLayer getRectLayerWithRect:maskPerRect dataRect:perRect dataStr:perStr fontSize:9.f textColor:[UIColor whiteColor] backColor:[UIColor blackColor]];
    //把4个图层全部添加到十字叉图层中
    [self.crossLayer addSublayer:roundLayer];
    [self.crossLayer addSublayer:timeLayer];
    [self.crossLayer addSublayer:priceLayer];
//    [self.crossLayer addSublayer:perLayer];
    //再添加到分时图view的图层中
    [self.layer addSublayer:self.crossLayer];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x;
//    CGFloat scrollX = scrollView.contentSize.width - offsetX - CGRectGetWidth(scrollView.frame);
    [self drawKLineChart];
}


/**
 清理图层
 */
- (void)clearLayer {
    [self.candleLayer removeFromSuperlayer];
    self.candleLayer = nil;
    
    [self.maLineLayer removeFromSuperlayer];
    self.maLineLayer = nil;
    
    [self.leftPriceLayer removeFromSuperlayer];
    self.leftPriceLayer = nil;
    
    [self.dateLayer removeFromSuperlayer];
    self.dateLayer = nil;
}

/**
 清理长按响应图层
 */
- (void)clearCrossLayer {
    //清理十字叉图层
    [self.crossLayer removeFromSuperlayer];
    self.crossLayer = nil;
}

#pragma mark - Lazy
- (CAShapeLayer *)candleLayer {
    if (!_candleLayer) {
        _candleLayer = [CAShapeLayer layer];
    }
    return _candleLayer;
}

- (CAShapeLayer *)maLineLayer {
    if (!_maLineLayer) {
        _maLineLayer = [CAShapeLayer layer];
    }
    return _maLineLayer;
}

- (CAShapeLayer *)dateLayer {
    if (!_dateLayer) {
        _dateLayer = [CAShapeLayer layer];
    }
    return _dateLayer;
}

- (CAShapeLayer *)leftPriceLayer {
    if (!_leftPriceLayer) {
        _leftPriceLayer = [CAShapeLayer layer];
    }
    return _leftPriceLayer;
}

- (CAShapeLayer *)crossLayer {
    if (!_crossLayer) {
        _crossLayer = [CAShapeLayer layer];
    }
    return _crossLayer;
}

- (UIScrollView *)kLineScrollView {
    if (!_kLineScrollView) {
        _kLineScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - timePointH)];
        _kLineScrollView.bounces = NO;
        _kLineScrollView.showsHorizontalScrollIndicator = NO;
        _kLineScrollView.delegate = self;
        [self addSubview:_kLineScrollView];
    }
    return _kLineScrollView;
}

@end
