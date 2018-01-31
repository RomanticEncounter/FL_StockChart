//
//  FLTimePointModel.h
//  FL_StockChart
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface FLTimePointModel : NSObject

/**
 最新价坐标点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 均线坐标点
 */
@property (nonatomic, assign) CGPoint avgPoint;
@end
