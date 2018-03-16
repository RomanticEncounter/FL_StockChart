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

@interface FLAccessoryChartView ()
/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*models;
/**
 最大值
 */
@property (nonatomic, assign) double accessoryMaxValue;
/**
 最小值
 */
@property (nonatomic, assign) double accessoryMinValue;
/**
 转换成坐标点数组
 */
@property (nonatomic, strong) NSMutableArray *accessoryPointArray;

@property (nonatomic, strong) CAShapeLayer *volumeLayer;
@end

//副图信息高度
static CGFloat accessoryInfoH = 20.f;

@implementation FLAccessoryChartView

- (instancetype)initWithFrame:(CGRect)frame StockGroupModel:(NSArray *)models {
    self = [super initWithFrame:frame];
    if (self) {
        self.accessoryPointArray = [NSMutableArray array];
        self.models = models;
        [self drawAccessoryChartBorderLayer];
    }
    return self;
}

- (void)startDrawAccessoryChart {
    [self findAccessoryMaxMinValue];
    [self conversionToAccessoryChartPoint];
    [self drawVolumeLine];
}

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
        CGFloat unitW = CGRectGetWidth(self.frame) / minutesCount;
        FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
        CGRect volumeRect = CGRectMake(pointModel.VolumePoint.x, pointModel.VolumePoint.y, unitW/2, ABS(CGRectGetHeight(self.frame) - pointModel.VolumePoint.y));
        
        UIBezierPath *volumePath = [UIBezierPath bezierPathWithRect:volumeRect];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = volumePath.CGPath;
        FLStockModel *stockModel = self.models[i];
        if (stockModel.Close.floatValue > stockModel.YesterdayClose.floatValue) {
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.fillColor = [UIColor redColor].CGColor;
        } else if (stockModel.Close.floatValue < stockModel.YesterdayClose.floatValue) {
            layer.strokeColor = [UIColor greenColor].CGColor;
            layer.fillColor = [UIColor greenColor].CGColor;
        } else {
            layer.strokeColor = [UIColor grayColor].CGColor;
            layer.fillColor = [UIColor grayColor].CGColor;
        }
        [self.volumeLayer addSublayer:layer];
    }
    [self.layer addSublayer:self.volumeLayer];
    if (FLStockChartSharedManager.mainChartType == FL_StockChartTypeKLine && FLStockChartSharedManager.accessoryChartType == FL_AccessoryChartTypeVolume) {
        [self drawVolumeMALine];
    }
}

/**
 绘制成交量MA线
 */
- (void)drawVolumeMALine {
    CAShapeLayer *volume_MA7LineLayer = [CAShapeLayer layer];
    CAShapeLayer *volume_MA30LineLayer = [CAShapeLayer layer];
    UIBezierPath *volume_MA7LinePath = [UIBezierPath bezierPath];
    UIBezierPath *volume_MA30LinePath = [UIBezierPath bezierPath];
    
//    FLAccessoryPointModel *firstPointModel = self.accessoryPointArray.firstObject;
//    [volume_MA7LinePath moveToPoint:firstPointModel.Volume_MA7Point];
//    [volume_MA30LinePath moveToPoint:firstPointModel.Volume_MA30Point];
    for (int i = 1; i < self.accessoryPointArray.count; i ++) {
        //均线
        FLAccessoryPointModel *MAPointModel = self.accessoryPointArray[i];
        if (i <= 6) {
            FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
            [volume_MA7LinePath moveToPoint:pointModel.Volume_MA7Point];
            continue;
        } else {
            [volume_MA7LinePath addLineToPoint:MAPointModel.Volume_MA7Point];
        }
        if (i <= 29) {
            FLAccessoryPointModel *pointModel = self.accessoryPointArray[i];
            [volume_MA30LinePath moveToPoint:pointModel.Volume_MA30Point];
            continue;
        } else {
            [volume_MA30LinePath addLineToPoint:MAPointModel.Volume_MA30Point];
        }
    }
    volume_MA7LineLayer.path = volume_MA7LinePath.CGPath;
    volume_MA7LineLayer.lineWidth = 1.f;
    volume_MA7LineLayer.strokeColor = [UIColor orangeColor].CGColor;
    volume_MA7LineLayer.fillColor = [UIColor clearColor].CGColor;
    
    volume_MA30LineLayer.path = volume_MA30LinePath.CGPath;
    volume_MA30LineLayer.lineWidth = 1.f;
    volume_MA30LineLayer.strokeColor = [UIColor purpleColor].CGColor;
    volume_MA30LineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:volume_MA7LineLayer];
    [self.layer addSublayer:volume_MA30LineLayer];
}

#pragma mark - Lazy
- (CAShapeLayer *)volumeLayer {
    if (!_volumeLayer) {
        _volumeLayer = [CAShapeLayer layer];
    }
    return _volumeLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
