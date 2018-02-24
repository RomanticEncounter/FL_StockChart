//
//  FLStockGroupModel.m
//  FL_StockChart
//
//  Created by mac on 2018/2/24.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLStockGroupModel.h"
#import "FLStockModel.h"

@implementation FLStockGroupModel

+ (instancetype)objectWith:(NSArray *)arr {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    FLStockGroupModel *groupModel = [FLStockGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block FLStockModel *preModel = [[FLStockModel alloc]init];
    
    for (NSDictionary *valueDic in arr) {
        FLStockModel *model = [FLStockModel new];
        model.previousStockModel = preModel;
//        [model initWithDictionary:valueDic];
//        model.ParentGroupModel = groupModel;
        [mutableArr addObject:model];
        
        preModel = model;
    }
    groupModel.models = mutableArr;
    
    //初始化第一个Model的数据
    FLStockModel *firstModel = mutableArr.firstObject;
//    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(FLStockModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        [model initData];
    }];
    return groupModel;
}

@end
