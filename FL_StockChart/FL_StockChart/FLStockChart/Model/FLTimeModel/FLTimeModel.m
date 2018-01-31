//
//  FLTimeModel.m
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "FLTimeModel.h"

@implementation TLineModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"time" : @"Time",
             @"close" : @"Price",
             @"avg" : @"Avg",
             @"volume" : @"Volume",
             @"amount" : @"Amount",};
}

@end

@implementation FLTimeModel
- (void)setTrend:(NSMutableArray *)trend {
    _trend = [[NSMutableArray alloc] initWithArray:trend];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"trend" : TLineModel.class};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"market" : @"Market",
             @"code" : @"Code",
             @"pushFlag" : @"PushFlag",
             @"prevClose" : @"PrevClose",
             @"prevSettle" : @"PrevSettle",
             @"trend" : @"Trend"};
}
@end
