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
#import "CAShapeLayer+FLCrossLayer.h"
#import "FLTimeChartView.h"
#import "FLStockGroupModel.h"

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

@property (nonatomic, strong) NSArray <FLStockModel *>*stockModelArray;

@property (nonatomic, strong) FLTimeChartView *timeChartView;

@end

@implementation FLStockChartMainView

//x轴时间点高
static CGFloat timePointH = 20.f;

- (instancetype)initWithFrame:(CGRect)frame groupModels:(FLStockGroupModel *)groupModels {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.stockModelArray = groupModels.models;
        self.timeChartView = [[FLTimeChartView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) StockGroupModel:self.stockModelArray];
        [self addSubview:self.timeChartView];
    }
    return self ;
}

- (void)startDraw {
    [self.timeChartView startDrawTimeChart];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
