//
//  FLStockChartMainView.m
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "FLStockChartMainView.h"
#import "FLTimeChartView.h"
#import "FLStockGroupModel.h"
#import "FLAccessoryChartView.h"


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
/**
 十字线
 */
@property (nonatomic, strong) CAShapeLayer *crossLayer;

/**
 数据源数组
 */
@property (nonatomic, strong) NSArray <FLStockModel *>*stockModelArray;

/**
 分时图
 */
@property (nonatomic, strong) FLTimeChartView *timeChartView;

/**
 副图
 */
@property (nonatomic, strong) FLAccessoryChartView *accessoryChartView;

@end

@implementation FLStockChartMainView

- (instancetype)initWithFrame:(CGRect)frame groupModels:(FLStockGroupModel *)groupModels {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.stockModelArray = groupModels.models;
        self.timeChartView = [[FLTimeChartView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.75 - 20) StockGroupModel:self.stockModelArray];
        [self addSubview:self.timeChartView];
        self.accessoryChartView = [[FLAccessoryChartView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) * 0.75, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.25) StockGroupModel:self.stockModelArray];
        [self addSubview:self.accessoryChartView];
    }
    return self;
}

- (void)startDraw {
    [self.timeChartView startDrawTimeChart];
    [self.accessoryChartView startDrawAccessoryChart];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
