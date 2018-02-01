//
//  ViewController.m
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "ViewController.h"
#import "FLStockChartMainView.h"
#import "FLTimeModel.h"
#import <YYModel/YYModel.h>


@interface ViewController ()

@property (nonatomic, strong) FLStockChartMainView *timeChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"tline" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    FLTimeModel *timeModel = [FLTimeModel yy_modelWithJSON:data];
    self.timeChartView.timeLinesModel = timeModel;
    [self.timeChartView startDraw];
//    self.timeChartView.backgroundColor = [UIColor whiteColor];
}

- (FLStockChartMainView *)timeChartView {
    if (!_timeChartView) {
        _timeChartView = [[FLStockChartMainView alloc]initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 40)];
        [self.view addSubview:_timeChartView];
    }
    return _timeChartView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
