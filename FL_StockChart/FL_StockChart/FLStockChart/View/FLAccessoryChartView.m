//
//  FLAccessryChartView.m
//  FL_StockChart
//
//  Created by mac on 2018/3/7.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLAccessoryChartView.h"
#import "FLStockModel.h"
#import "FLStockChartManager.h"
#import "FLStockChartPointModel.h"
#import "CAShapeLayer+FLCrossLayer.h"
#import "CATextLayer+TimeTextLayer.h"
#import "CAShapeLayer+FLCandleLayer.h"
#import "UIColor+FLStockChartTheme.h"

@interface FLAccessoryChartView ()
/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*models;
/**
 需要绘制的颜色数组
 */
@property (nonatomic, strong) NSMutableArray <UIColor *>*colors;
/**
 最大值
 */
@property (nonatomic, assign) CGFloat accessoryMaxValue;
/**
 最小值
 */
@property (nonatomic, assign) CGFloat accessoryMinValue;
/**
 转换成坐标点数组
 */
@property (nonatomic, strong) NSMutableArray *accessoryPointArray;
/**
 成交量Layer
 */
@property (nonatomic, strong) CAShapeLayer *volumeLayer;
/**
 MACDLayer
 */
@property (nonatomic, strong) CAShapeLayer *macdLayer;
/**
 KDJLayer
 */
@property (nonatomic, strong) CAShapeLayer *kdjLayer;

@end

//副图信息高度
static CGFloat accessoryInfoH = 20.f;

@implementation FLAccessoryChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.accessoryPointArray = [NSMutableArray array];
        self.colors = [NSMutableArray array];
        [self drawAccessoryChartBorderLayer];
    }
    return self;
}

/**
 重绘副图
 */
- (void)reDrawAccessoryChart {
    [self clearAccessoryLayer];
    [self private_converToAccessoryPointModels];
    [self startDrawAccessoryChart];
}

/**
 设置副图数据源

 @param needDrawModels 需要绘制的数据源
 */
- (void)setAccessoryChartDataSource:(NSArray <FLStockModel *>*)needDrawModels {
    _models = needDrawModels;
    [self reDrawAccessoryChart];
}


/**
 转换副图坐标点
 */
- (void)private_converToAccessoryPointModels {
    if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeVolume) {
        [self private_converToVolumePoint];
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeMACD) {
        [self private_converToMACDPoint];
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeTypeKDJ) {
        [self private_converToKDJPoint];
    }
}

/**
 开始绘制
 */
- (void)startDrawAccessoryChart {
    if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeVolume) {
        [self drawVolumeLine];
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeMACD) {
        [self drawMACDLine];
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeTypeKDJ) {
        [self drawKDJLine];
    }
}

/**
 转换成交量坐标点
 */
- (void)private_converToVolumePoint {
    if(!self.models) {
        return ;
    }
    NSArray *needDrawModels = self.models;
    //计算最小单位
    CGFloat Volume_Max = [[[self.models valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat Volume_Min = [[[self.models valueForKeyPath:@"Volume"] valueForKeyPath:@"@min.floatValue"] floatValue];
    _accessoryMinValue = Volume_Min;
    _accessoryMaxValue = Volume_Max;
    //高度差
    CGFloat unitValue = (_accessoryMaxValue - _accessoryMinValue) / (CGRectGetHeight(self.frame) - accessoryInfoH);
    
    [self.accessoryPointArray removeAllObjects];
    [self.colors removeAllObjects];
    
    for (NSInteger idx = 0 ; idx < needDrawModels.count; ++idx) {
        FLStockModel *model = needDrawModels[idx];
        CGFloat x = CGRectGetMinX(self.frame) + (FLStockChartSharedManager.kLineGap + FLStockChartSharedManager.kLineWidth) * idx + FLStockChartSharedManager.kLineGap;
        CGPoint volumePoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - (model.Volume.floatValue - _accessoryMinValue) / unitValue));
        CGPoint volume_MA7Point = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS(CGRectGetHeight(self.frame) - (model.Volume_MA7.floatValue - _accessoryMinValue) / unitValue));
        CGPoint volume_MA30Point = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2,  ABS(CGRectGetHeight(self.frame) - (model.Volume_MA30.floatValue - _accessoryMinValue) / unitValue));
        if (model.Open.floatValue < model.Close.floatValue) {
            [self.colors addObject:[UIColor increaseColor]];
        } else if (model.Open.floatValue > model.Close.floatValue) {
            [self.colors addObject:[UIColor decreaseColor]];
        } else {
            [self.colors addObject:[UIColor crossColor]];
        }
        /*
        CGPoint highPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - accessoryInfoH) - (model.High.floatValue - _minValue) / unitValue));
        
        CGPoint lowPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS((CGRectGetHeight(self.frame) - accessoryInfoH) - (model.Low.floatValue - _minValue) / unitValue));
        
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
         */
        FLAccessoryPointModel * accessoryPointModel = [FLAccessoryPointModel new];
        accessoryPointModel.VolumePoint = volumePoint;
        accessoryPointModel.Volume_MA7Point = volume_MA7Point;
        accessoryPointModel.Volume_MA30Point = volume_MA30Point;
        [self.accessoryPointArray addObject:accessoryPointModel];
    }
}

/**
 转换MACD坐标点
 */
- (void)private_converToMACDPoint {
    if(!self.models) {
        return ;
    }
    NSArray *needDrawModels = self.models;
    //计算最小单位
    CGFloat MACD_Max = [[[self.models valueForKeyPath:@"MACD"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat MACD_Min = [[[self.models valueForKeyPath:@"MACD"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat DEA_Max = [[[self.models valueForKeyPath:@"DEA"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat DEA_Min = [[[self.models valueForKeyPath:@"DEA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat DIF_Max = [[[self.models valueForKeyPath:@"DIF"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat DIF_Min = [[[self.models valueForKeyPath:@"DIF"] valueForKeyPath:@"@min.floatValue"] floatValue];
    _accessoryMaxValue = fmaxf(fmaxf(DIF_Max, DEA_Max), MACD_Max);
    _accessoryMinValue = fminf(fminf(DIF_Min, DEA_Min), MACD_Min);
    //高度差
    CGFloat unitValue = (_accessoryMaxValue - _accessoryMinValue) / (CGRectGetHeight(self.frame) - accessoryInfoH);
    
    [self.accessoryPointArray removeAllObjects];
    [self.colors removeAllObjects];
    
    for (NSInteger idx = 0 ; idx < needDrawModels.count; ++idx) {
        FLStockModel *model = needDrawModels[idx];
        CGFloat x = CGRectGetMinX(self.frame) + (FLStockChartSharedManager.kLineGap + FLStockChartSharedManager.kLineWidth) * idx + FLStockChartSharedManager.kLineGap;
        
        CGPoint MACDPoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - (model.MACD.floatValue - self.accessoryMinValue) / unitValue));
        
        CGPoint DIFPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS(CGRectGetHeight(self.frame) - (model.DIF.floatValue - _accessoryMinValue) / unitValue));
        
        CGPoint DEAPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS(CGRectGetHeight(self.frame) - (model.DEA.floatValue - _accessoryMinValue) / unitValue));
        
        if (model.MACD.floatValue >= 0) {
            [self.colors addObject:[UIColor increaseColor]];
        } else {
            [self.colors addObject:[UIColor decreaseColor]];
        }
        
        FLAccessoryPointModel * accessoryPointModel = [FLAccessoryPointModel new];
        accessoryPointModel.MACDPoint = MACDPoint;
        accessoryPointModel.DIFPoint = DIFPoint;
        accessoryPointModel.DEAPoint = DEAPoint;
        [self.accessoryPointArray addObject:accessoryPointModel];
        
    }
    
}

/**
 转换K_D_J坐标点
 */
- (void)private_converToKDJPoint {
    if(!self.models) {
        return ;
    }
    NSArray *needDrawModels = self.models;
    //计算最小单位
    CGFloat K_Max = [[[self.models valueForKeyPath:@"KDJ_K"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat K_Min = [[[self.models valueForKeyPath:@"KDJ_K"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat D_Max = [[[self.models valueForKeyPath:@"KDJ_D"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat D_Min = [[[self.models valueForKeyPath:@"KDJ_D"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat J_Max = [[[self.models valueForKeyPath:@"KDJ_J"] valueForKeyPath:@"@max.floatValue"] doubleValue];
    CGFloat J_Min = [[[self.models valueForKeyPath:@"KDJ_J"] valueForKeyPath:@"@min.floatValue"] floatValue];
    _accessoryMaxValue = fmaxf(fmaxf(K_Max, D_Max), J_Max);
    _accessoryMinValue = fminf(fminf(K_Min, D_Min), J_Min);
    //高度差
    CGFloat unitValue = (_accessoryMaxValue - _accessoryMinValue) / (CGRectGetHeight(self.frame) - accessoryInfoH);
    
    [self.accessoryPointArray removeAllObjects];
    [self.colors removeAllObjects];
    
    for (NSInteger idx = 0 ; idx < needDrawModels.count; ++idx) {
        FLStockModel *model = needDrawModels[idx];
        CGFloat x = CGRectGetMinX(self.frame) + (FLStockChartSharedManager.kLineGap + FLStockChartSharedManager.kLineWidth) * idx + FLStockChartSharedManager.kLineGap;
        
        
        CGPoint KDJ_KPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS(CGRectGetHeight(self.frame) - (model.KDJ_K.floatValue - _accessoryMinValue) / unitValue));
        
        CGPoint KDJ_DPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS(CGRectGetHeight(self.frame) - (model.KDJ_D.floatValue - _accessoryMinValue) / unitValue));
        
        CGPoint KDJ_JPoint = CGPointMake(x + FLStockChartSharedManager.kLineWidth / 2, ABS(CGRectGetHeight(self.frame) - (model.KDJ_J.floatValue - _accessoryMinValue) / unitValue));
        
        
        FLAccessoryPointModel * accessoryPointModel = [FLAccessoryPointModel new];
        accessoryPointModel.KDJ_K_Point = KDJ_KPoint;
        accessoryPointModel.KDJ_D_Point = KDJ_DPoint;
        accessoryPointModel.KDJ_J_Point = KDJ_JPoint;
        [self.accessoryPointArray addObject:accessoryPointModel];
        
    }
}



//- (void)startDrawAccessoryChart {
//    [self findAccessoryMaxMinValue];
//    [self conversionToAccessoryChartPoint];
//    [self drawVolumeLine];
//}

/**
 绘制副图边框
 */
- (void)drawAccessoryChartBorderLayer {
    //初始化坐标点
    CGFloat startFrameX = 0.f;
    CGFloat startFrameY = accessoryInfoH;
    CGFloat borderFrameW = CGRectGetWidth(self.frame);
    //减去底部时间的高度20
    CGFloat borderFrameH = CGRectGetHeight(self.frame) - accessoryInfoH;
    CGRect borderRect = CGRectMake(startFrameX, startFrameY, borderFrameW, borderFrameH);
    
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:borderRect];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGFloat unitW = borderFrameW / 4;
    CGFloat unitH = borderFrameH / 2;
    //绘制4条竖线
    for (NSInteger i = 0; i < 5; i ++) {
        CGPoint vertical_startPoint = CGPointMake(startFrameX + unitW * i, startFrameY);
        CGPoint vertical_endPoint   = CGPointMake(startFrameX + unitW * i, startFrameY + borderFrameH);
        [framePath moveToPoint:vertical_startPoint];
        [framePath addLineToPoint:vertical_endPoint];
    }
    //绘制1条横线
    CGPoint horizontal_startPoint = CGPointMake(startFrameX, startFrameY + unitH);
    CGPoint horizontal_endPoint   = CGPointMake(startFrameX + CGRectGetWidth(self.frame), startFrameY + unitH);
    [framePath moveToPoint:horizontal_startPoint];
    [framePath addLineToPoint:horizontal_endPoint];
    
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
- (void)findAccessoryMaxMinValue {
    float gapValue = 0.01f;
    if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeVolume) {
        double Volume_Max = [[[self.models valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double Volume_Min = [[[self.models valueForKeyPath:@"Volume"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        self.accessoryMaxValue = Volume_Max;
        self.accessoryMinValue = Volume_Min;
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeMACD) {
        double DIF_Max = [[[self.models valueForKeyPath:@"DIF"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double DIF_Min = [[[self.models valueForKeyPath:@"DIF"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        double DEA_Max = [[[self.models valueForKeyPath:@"DEA"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double DEA_Min = [[[self.models valueForKeyPath:@"DEA"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        double MACD_Max = [[[self.models valueForKeyPath:@"MACD"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double MACD_Min = [[[self.models valueForKeyPath:@"MADC"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        self.accessoryMaxValue = fmax(fmax(DIF_Max, DEA_Max), MACD_Max) + gapValue;
        self.accessoryMinValue = fmin(fmin(DIF_Min, DEA_Min), MACD_Min) - gapValue;
        
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeTypeKDJ) {
        double K_Max = [[[self.models valueForKeyPath:@"KDJ_K"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double K_Min = [[[self.models valueForKeyPath:@"KDJ_K"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        double D_Max = [[[self.models valueForKeyPath:@"KDJ_D"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double D_Min = [[[self.models valueForKeyPath:@"KDJ_D"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        double J_Max = [[[self.models valueForKeyPath:@"KDJ_J"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        double J_Min = [[[self.models valueForKeyPath:@"KDJ_J"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
        self.accessoryMaxValue = fmax(fmax(K_Max, D_Max), J_Max) + gapValue;
        self.accessoryMinValue = fmin(fmin(K_Min, D_Min), J_Min) - gapValue;
    } else {
        
    }
}

/**
 转换副图坐标点
 */
- (void)conversionToAccessoryChartPoint {
    if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeVolume) {
        [self conversionToVolumePoint];
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeMACD) {
        
    } else if (FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeTypeKDJ) {
        
    } else {
        
    }
}

/**
 转换成交量坐标点
 */
- (void)conversionToVolumePoint {
    if (FLStockChartSharedManager.mainChartType == FL_StockChartTypeTimeLine) {
        [self conversionToOnlyVolumePoint];
    } else if (FLStockChartSharedManager.mainChartType == FL_StockChartTypeKLine) {
        [self conversionToVolumeAndMALinePoint];
    }
}

/**
 转换只有成交量坐标点
 */
- (void)conversionToOnlyVolumePoint {
    //将View的宽度分成1440
    CGFloat unitW = CGRectGetWidth(self.frame) / minutesCount;
    CGFloat unitH = (self.accessoryMaxValue - self.accessoryMinValue) / (CGRectGetHeight(self.frame) - accessoryInfoH);
    
    [self.accessoryPointArray removeAllObjects];
    //遍历数据模型
    [self.models enumerateObjectsUsingBlock:^(FLStockModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * unitW;
        //生成成交量坐标点
        CGPoint volumePoint = CGPointMake(x, accessoryInfoH + ABS(CGRectGetHeight(self.frame) - accessoryInfoH) - ((model.Volume.floatValue - self.accessoryMinValue) / unitH));
        
        FLAccessoryPointModel *pointModel = [FLAccessoryPointModel new];
        pointModel.VolumePoint = volumePoint;
        [self.accessoryPointArray addObject:pointModel];
    }];
}



/**
 转换成交量和MA线坐标点
 */
- (void)conversionToVolumeAndMALinePoint {
    //将View的宽度分成1440
    CGFloat unitW = CGRectGetWidth(self.frame) / minutesCount;
    CGFloat unitH = (self.accessoryMaxValue - self.accessoryMinValue) / (CGRectGetHeight(self.frame) - accessoryInfoH);
    
    [self.accessoryPointArray removeAllObjects];
    //遍历数据模型
    [self.models enumerateObjectsUsingBlock:^(FLStockModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * unitW;
        //生成成交量坐标点
        CGPoint volumePoint = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - accessoryInfoH) - ((model.Volume.floatValue - self.accessoryMinValue) / unitH));
        //生成成交量坐标点
        CGPoint volume_MA7Point = CGPointZero;
        if (idx >= 6) {
            volume_MA7Point = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - accessoryInfoH) - ((model.Volume_MA7.floatValue - self.accessoryMinValue) / unitH));
        }
        CGPoint volume_MA30Point = CGPointZero;
        if (idx >= 29) {
            volume_MA30Point = CGPointMake(x, ABS(CGRectGetHeight(self.frame) - accessoryInfoH) - ((model.Volume_MA30.floatValue - self.accessoryMinValue) / unitH));
        }
        
        FLAccessoryPointModel *pointModel = [FLAccessoryPointModel new];
        pointModel.VolumePoint = volumePoint;
        pointModel.Volume_MA7Point = volume_MA7Point;
        pointModel.Volume_MA30Point = volume_MA30Point;
        [self.accessoryPointArray addObject:pointModel];
    }];
}


/**
 绘制成交量
 */
- (void)drawVolumeLine {
    
    for (int i = 0; i < self.accessoryPointArray.count; i ++) {
        FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
        UIColor *volumeColor = self.colors[i];
        CGRect volumeFrame = CGRectMake(pointModel.VolumePoint.x, pointModel.VolumePoint.y, FLStockChartSharedManager.kLineWidth, CGRectGetHeight(self.frame) - pointModel.VolumePoint.y);
        CAShapeLayer *layer = [CAShapeLayer getRectangleLayerWithFrame:volumeFrame backgroundColor:volumeColor];
        [self.volumeLayer addSublayer:layer];
    }
    //成交量MA线
    [self drawVolumeMALine];
    [self.layer addSublayer:self.volumeLayer];
}

/**
 绘制成交量MA线
 */
- (void)drawVolumeMALine {
    CAShapeLayer *volume_MA7LineLayer = [CAShapeLayer layer];
    CAShapeLayer *volume_MA30LineLayer = [CAShapeLayer layer];
    UIBezierPath *volume_MA7LinePath = [UIBezierPath bezierPath];
    UIBezierPath *volume_MA30LinePath = [UIBezierPath bezierPath];
    
    FLAccessoryPointModel *firstPointModel = self.accessoryPointArray.firstObject;
    [volume_MA7LinePath moveToPoint:firstPointModel.Volume_MA7Point];
    [volume_MA30LinePath moveToPoint:firstPointModel.Volume_MA30Point];
    for (int i = 1; i < self.accessoryPointArray.count; i ++) {
        //均线
        FLAccessoryPointModel *MAPointModel = self.accessoryPointArray[i];
        [volume_MA7LinePath addLineToPoint:MAPointModel.Volume_MA7Point];
        [volume_MA30LinePath addLineToPoint:MAPointModel.Volume_MA30Point];
        /*
        if (i < 6) {
            FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
            [volume_MA7LinePath moveToPoint:pointModel.Volume_MA7Point];
            continue;
        } else {
            [volume_MA7LinePath addLineToPoint:MAPointModel.Volume_MA7Point];
        }
        if (i < 29) {
            FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
            [volume_MA30LinePath moveToPoint:pointModel.Volume_MA30Point];
            continue;
        } else {
            [volume_MA30LinePath addLineToPoint:MAPointModel.Volume_MA30Point];
        }
         */
    }
    volume_MA7LineLayer.path = volume_MA7LinePath.CGPath;
    volume_MA7LineLayer.lineWidth = 1.f;
    volume_MA7LineLayer.strokeColor = [UIColor orangeColor].CGColor;
    volume_MA7LineLayer.fillColor = [UIColor clearColor].CGColor;
    
    volume_MA30LineLayer.path = volume_MA30LinePath.CGPath;
    volume_MA30LineLayer.lineWidth = 1.f;
    volume_MA30LineLayer.strokeColor = [UIColor purpleColor].CGColor;
    volume_MA30LineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.volumeLayer addSublayer:volume_MA7LineLayer];
    [self.volumeLayer addSublayer:volume_MA30LineLayer];
}

/**
 绘制MACD线
 */
- (void)drawMACDLine {
    CAShapeLayer *DIfLayer = [CAShapeLayer layer];
    CAShapeLayer *DEALayer = [CAShapeLayer layer];
    
    UIBezierPath *DIfPath = [UIBezierPath bezierPath];
    UIBezierPath *DEAPath = [UIBezierPath bezierPath];
    
    CGFloat unitValue = (self.accessoryMaxValue - self.accessoryMinValue) / (CGRectGetHeight(self.frame) - accessoryInfoH);
    for (int i = 0; i < self.accessoryPointArray.count; i ++) {
        FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
        UIColor *MADCColor = self.colors[i];
        //计算零的坐标点
        CGFloat MACD_ZeroY = ABS(CGRectGetHeight(self.frame) - (0 - self.accessoryMinValue) / unitValue);
        CGFloat MACD_EndY = pointModel.MACDPoint.y;
        //判断MACD_EndY > MACD_ZeroY = MACD_ZeroY MACD_EndY <= MACD_ZeroY = MACD_EndY
        CGRect MACDFrame = CGRectMake(pointModel.MACDPoint.x, MACD_EndY > MACD_ZeroY ? MACD_ZeroY : MACD_EndY, FLStockChartSharedManager.kLineWidth, ABS(MACD_EndY - MACD_ZeroY));
        CAShapeLayer *layer = [CAShapeLayer getRectangleLayerWithFrame:MACDFrame backgroundColor:MADCColor];
        
        if (i) {
            [DIfPath addLineToPoint:pointModel.DIFPoint];
            [DEAPath addLineToPoint:pointModel.DEAPoint];
        } else {
            [DIfPath moveToPoint:pointModel.DIFPoint];
            [DEAPath moveToPoint:pointModel.DEAPoint];
        }
        [self.macdLayer addSublayer:layer];
    }
    DIfLayer.path = DIfPath.CGPath;
    DIfLayer.lineWidth = 1.f;
    DIfLayer.strokeColor = [UIColor orangeColor].CGColor;
    DIfLayer.fillColor = [UIColor clearColor].CGColor;
    
    DEALayer.path = DEAPath.CGPath;
    DEALayer.lineWidth = 1.f;
    DEALayer.strokeColor = [UIColor purpleColor].CGColor;
    DEALayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.macdLayer addSublayer:DIfLayer];
    [self.macdLayer addSublayer:DEALayer];
    
    [self.layer addSublayer:self.macdLayer];
}

/**
 绘制KDJ线
 */
- (void)drawKDJLine {
    CAShapeLayer *KDJ_KLayer = [CAShapeLayer layer];
    CAShapeLayer *KDJ_DLayer = [CAShapeLayer layer];
    CAShapeLayer *KDJ_JLayer = [CAShapeLayer layer];
    
    UIBezierPath *KDJ_KPath = [UIBezierPath bezierPath];
    UIBezierPath *KDJ_DPath = [UIBezierPath bezierPath];
    UIBezierPath *KDJ_JPath = [UIBezierPath bezierPath];
    for (int i = 0; i < self.accessoryPointArray.count; i ++) {
        FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
        if (i) {
            [KDJ_KPath addLineToPoint:pointModel.KDJ_K_Point];
            [KDJ_DPath addLineToPoint:pointModel.KDJ_D_Point];
            [KDJ_JPath addLineToPoint:pointModel.KDJ_J_Point];
        } else {
            [KDJ_KPath moveToPoint:pointModel.KDJ_K_Point];
            [KDJ_DPath moveToPoint:pointModel.KDJ_D_Point];
            [KDJ_JPath moveToPoint:pointModel.KDJ_J_Point];
        }
    }
    KDJ_KLayer.path = KDJ_KPath.CGPath;
    KDJ_KLayer.lineWidth = 1.f;
    KDJ_KLayer.strokeColor = [UIColor purpleColor].CGColor;
    KDJ_KLayer.fillColor = [UIColor clearColor].CGColor;
    
    KDJ_DLayer.path = KDJ_DPath.CGPath;
    KDJ_DLayer.lineWidth = 1.f;
    KDJ_DLayer.strokeColor = [UIColor orangeColor].CGColor;
    KDJ_DLayer.fillColor = [UIColor clearColor].CGColor;
    
    KDJ_JLayer.path = KDJ_JPath.CGPath;
    KDJ_JLayer.lineWidth = 1.f;
    KDJ_JLayer.strokeColor = [UIColor blueColor].CGColor;
    KDJ_JLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.kdjLayer addSublayer:KDJ_KLayer];
    [self.kdjLayer addSublayer:KDJ_DLayer];
    [self.kdjLayer addSublayer:KDJ_JLayer];
    
    [self.layer addSublayer:self.kdjLayer];
}


- (void)clearAccessoryLayer {
    if (_volumeLayer) {
        [self.volumeLayer removeFromSuperlayer];
        self.volumeLayer = nil;
    }
    
    if (_macdLayer) {
        [self.macdLayer removeFromSuperlayer];
        self.macdLayer = nil;
    }
    
    if (_kdjLayer) {
        [self.kdjLayer removeFromSuperlayer];
        self.kdjLayer = nil;
    }
}

#pragma mark - Lazy
- (CAShapeLayer *)volumeLayer {
    if (!_volumeLayer) {
        _volumeLayer = [CAShapeLayer layer];
    }
    return _volumeLayer;
}

- (CAShapeLayer *)macdLayer {
    if (!_macdLayer) {
        _macdLayer = [CAShapeLayer layer];
    }
    return _macdLayer;
}

- (CAShapeLayer *)kdjLayer {
    if (!_kdjLayer) {
        _kdjLayer = [CAShapeLayer layer];
    }
    return _kdjLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
