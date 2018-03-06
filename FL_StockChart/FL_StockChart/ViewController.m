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
#import "FLNetworkingManager.h"
#import "FLStockGroupModel.h"


@interface ViewController ()

@property (nonatomic, strong) FLStockChartMainView *timeChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"tline" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
//    FLTimeModel *timeModel = [FLTimeModel yy_modelWithJSON:data];
//    self.timeChartView.timeLinesModel = timeModel;
//    [self.timeChartView startDraw];
//    self.timeChartView.backgroundColor = [UIColor whiteColor];
    [self requestWithTimeLinesData];
}

- (FLStockChartMainView *)timeChartView {
    if (!_timeChartView) {
        _timeChartView = [[FLStockChartMainView alloc]initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 20, 400)];
        [self.view addSubview:_timeChartView];
    }
    return _timeChartView;
}
/*(
20180302133000,
3688,
3688,
3688,
3689,
3686,
3156,
174548460
)
 */
- (void)requestWithTimeLinesData {
    NSDictionary *param = @{@"Market":@"SHFE",
                            @"Code":@"ag1806",
                            @"KLineType":@"1",
                            @"Count":@"1440",};
    [[FLNetworkingManager sharedManager] GET:@"http://wxapp.htzj66.com/App/Stock" Parameters:param Success:^(NSDictionary *responseObject) {
//        NSLog(@"%@",responseObject[@"Data"]);
        NSAssert([responseObject[@"Data"] isKindOfClass:[NSArray class]], @"dataArray不是一个数组");
        NSArray *dataArray = responseObject[@"Data"];
        NSMutableArray *allDataArray = [NSMutableArray arrayWithCapacity:0];
        if (dataArray.count >= 5) {
            //开始时间
            //NSNumber *beginTime = dataArray[1];
            //结束时间
            //NSNumber *endTime = dataArray[2];
            //价格倍数
            NSNumber *priceWeight = dataArray[4];
            
            if ([dataArray.firstObject isKindOfClass:[NSArray class]]) {
                NSArray *originalArray = dataArray.firstObject;
                for (NSInteger i = 0; i < originalArray.count; i ++) {
                    
                    NSArray *stockArray = [originalArray objectAtIndex:i];
                    NSMutableDictionary *stockDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
                    if (stockArray.count == 8) {
                        //价格/倍数 = 真实价格
                        NSNumber *yesterdayClose = @([stockArray[1] floatValue] / priceWeight.integerValue);
                        NSNumber *openPrice = @([stockArray[2] floatValue] / priceWeight.integerValue);
                        NSNumber *closePrice = @([stockArray[3] floatValue] / priceWeight.integerValue);
                        NSNumber *highPrice = @([stockArray[4] floatValue] / priceWeight.integerValue);
                        NSNumber *lowPrice = @([stockArray[5] floatValue] / priceWeight.integerValue);
                        NSNumber *volume = stockArray[6];
                        NSNumber *amount = stockArray.lastObject;
                        
                        [stockDictionary setValue:stockArray.firstObject forKey:@"Date"];
                        [stockDictionary setValue:yesterdayClose forKey:@"YesterdayClose"];
                        [stockDictionary setValue:openPrice forKey:@"Open"];
                        [stockDictionary setValue:closePrice forKey:@"Close"];
                        [stockDictionary setValue:highPrice forKey:@"High"];
                        [stockDictionary setValue:lowPrice forKey:@"Low"];
                        [stockDictionary setValue:volume forKey:@"Volume"];
                        [stockDictionary setValue:amount forKey:@"Amount"];
                    }
                    [allDataArray addObject:stockDictionary];
                }
                [self createStockChartView:allDataArray];
            }
        }
        
        
    } Fail:^{
        
    }];
}

- (void)createStockChartView:(NSArray *)allDataArray {
    FLStockGroupModel *groupModel = [FLStockGroupModel objectWithArray:allDataArray];
    FLStockChartMainView *testTimeChartView = [[FLStockChartMainView alloc]initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 20, 400)groupModels:groupModel];
    [self.view addSubview:testTimeChartView];
    [testTimeChartView startDraw];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
