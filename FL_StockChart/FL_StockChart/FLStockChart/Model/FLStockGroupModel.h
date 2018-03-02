//
//  FLStockGroupModel.h
//  FL_StockChart
//
//  Created by mac on 2018/2/24.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLStockModel;

@interface FLStockGroupModel : NSObject

@property (nonatomic, copy) NSArray <FLStockModel *>*models;

+ (instancetype)objectWithArray:(NSArray *)arr;
@end
