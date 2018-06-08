//
//  FLStockChartMainView.m
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "FLStockChartMainView.h"
#import "FLStockGroupModel.h"
#import "FLTimeChartView.h"
#import "FLKLineChartView.h"
#import "FLAccessoryChartView.h"
#import "UIColor+FLStockChartTheme.h"
#import "FLStockChartManager.h"


@interface FLStockChartMainView () <FLKLineChartViewDelegate>
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
 指标按钮
 */
@property (nonatomic, strong) NSMutableArray *indicatorButtonArray;
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
 K线图
 */
@property (nonatomic, strong) FLKLineChartView *kLineChartView;

/**
 副图
 */
@property (nonatomic, strong) FLAccessoryChartView *accessoryChartView;
/**
 记录上次点击的按钮
 */
@property (nonatomic, strong) UIButton *lastSelectedButton;

@end

@implementation FLStockChartMainView

- (instancetype)initWithFrame:(CGRect)frame groupModels:(FLStockGroupModel *)groupModels {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor mainChartBackgroundColor];
        
        self.stockModelArray = groupModels.models;
        //分时线的创建方法
        /*
        self.timeChartView = [[FLTimeChartView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.75 - 20) StockGroupModel:self.stockModelArray];
        [self addSubview:self.timeChartView];
         */
        
        //k线的创建方法
        self.kLineChartView = [[FLKLineChartView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.75 - 20)];
        self.kLineChartView.delegate = self;
        [self addSubview:self.kLineChartView];
        [self.kLineChartView setKLineChartWithModel:self.stockModelArray];
        
        [self createIndicatorButton];
        
        self.accessoryChartView = [[FLAccessoryChartView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) * 0.75, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.25)];
        [self addSubview:self.accessoryChartView];
        
    }
    return self;
}

- (void)startDraw {
    //分时线开始绘制
//    [self.timeChartView startDrawTimeChart];
    //k线开始绘制
    [self.kLineChartView drawKLineChart];
//    [self.accessoryChartView startDrawAccessoryChart];
}

- (void)createIndicatorButton {
    NSArray *strArray = @[@"Volume",@"MACD",@"KDJ"];
    for (NSInteger i = 0; i < strArray.count; i ++) {
        NSString *str = [strArray objectAtIndex:i];
        UIButton *indicatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [indicatorBtn setTitle:str forState:UIControlStateNormal];
        [indicatorBtn setTitleColor:[UIColor timeTextColor] forState:UIControlStateNormal];
        [indicatorBtn setTitleColor:[UIColor increaseColor] forState:UIControlStateSelected];
        indicatorBtn.tag = i;
        indicatorBtn.frame = CGRectMake(5 + i * 55, CGRectGetHeight(self.frame) * 0.75 - 20, 50, 20);
        indicatorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        indicatorBtn.layer.cornerRadius = 3;
        indicatorBtn.layer.masksToBounds = YES;
        indicatorBtn.layer.borderWidth = 1;
        indicatorBtn.layer.borderColor = [UIColor timeTextColor].CGColor;
        [indicatorBtn addTarget:self action:@selector(indicatorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:indicatorBtn];
        if (i == 0) {
            self.lastSelectedButton = indicatorBtn;
            indicatorBtn.selected = YES;
            indicatorBtn.layer.borderColor = [UIColor increaseColor].CGColor;
        }
    }
}

- (void)indicatorBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            FLStockChartSharedManager.accessoryChartType = FL_AccessoryChartTypeVolume;
        }
            break;
        case 1:
        {
            FLStockChartSharedManager.accessoryChartType = FL_AccessoryChartTypeMACD;
        }
            break;
        case 2:
        {
            FLStockChartSharedManager.accessoryChartType = FL_AccessoryChartTypeTypeKDJ;
        }
            break;
            
        default:
            break;
    }
    btn.selected = YES;
    btn.layer.borderColor = [UIColor increaseColor].CGColor;
    self.lastSelectedButton.selected = !btn.selected;
    self.lastSelectedButton.layer.borderColor = [UIColor timeTextColor].CGColor;
    self.lastSelectedButton = btn;
    [self.accessoryChartView reDrawAccessoryChart];
}



#pragma mark - FLKLineChartViewDelegate
- (void)FL_KLineCharExtractNeedDrawModels:(NSArray <FLStockModel *>*)needDrawModels {
    [self.accessoryChartView setAccessoryChartDataSource:needDrawModels];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
