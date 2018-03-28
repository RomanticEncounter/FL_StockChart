//
//  FLStockModel.m
//  FL_StockChart
//
//  Created by mac on 2018/2/6.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLStockModel.h"

@implementation FLStockModel

- (NSNumber *)MA5 {
    if (!_MA5) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 4) {
            if (index > 4) {
                _MA5 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 5].SumOfLastClose.floatValue) / 5);
            } else {
                _MA5 = @(self.SumOfLastClose.floatValue / 5);
            }
        }
    }
    return _MA5;
}

- (NSNumber *)MA7 {
    if (!_MA7) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 6) {
            if (index > 6) {
                _MA7 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 7].SumOfLastClose.floatValue) / 7);
            } else {
                _MA7 = @(self.SumOfLastClose.floatValue / 7);
            }
        }
    }
    return _MA7;
}

- (NSNumber *)MA10 {
    if (!_MA10) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 9) {
            if (index > 9) {
                _MA10 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 10].SumOfLastClose.floatValue) / 10);
            } else {
                _MA10 = @(self.SumOfLastClose.floatValue / 10);
            }
        }
    }
    return _MA10;
}

- (NSNumber *)MA20 {
    if (!_MA20) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            if (index > 19) {
                _MA20 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 20].SumOfLastClose.floatValue) / 20);
            } else {
                _MA20 = @(self.SumOfLastClose.floatValue / 20);
            }
        }
    }
    return _MA20;
}

- (NSNumber *)MA30 {
    if (!_MA30) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 29) {
            if (index > 29) {
                _MA30 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 30].SumOfLastClose.floatValue) / 30);
            } else {
                _MA30 = @(self.SumOfLastClose.floatValue / 30);
            }
        }
    }
    return _MA30;
}

- (NSNumber *)MA12 {
    if (!_MA12) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 11) {
            if (index > 11) {
                _MA12 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 12].SumOfLastClose.floatValue) / 12);
            } else {
                _MA12 = _EMA12 = @(self.SumOfLastClose.floatValue / 12);
            }
        }
    }
    return _MA12;
}

- (NSNumber *)MA26 {
    if (!_MA26) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 25) {
            if (index > 25) {
                _MA26 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 26].SumOfLastClose.floatValue) / 26);
            } else {
                _MA26 = _EMA26 = @(self.SumOfLastClose.floatValue / 26);
            }
        }
    }
    return _MA26;
}

- (NSNumber *)Volume_MA7 {
    if (!_Volume_MA7) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 6) {
            if (index > 6) {
                _Volume_MA7 = @((self.SumOfLastVolume.floatValue - self.ParentGroupModel.models[index - 7].SumOfLastVolume.floatValue) / 7);
            } else {
                _Volume_MA7 = @(self.SumOfLastVolume.floatValue / 7);
            }
        }
    }
    return _Volume_MA7;
}

- (NSNumber *)Volume_MA30 {
    if (!_Volume_MA30) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 29) {
            if (index > 29) {
                _Volume_MA30 = @((self.SumOfLastVolume.floatValue - self.ParentGroupModel.models[index - 30].SumOfLastVolume.floatValue) / 30);
            } else {
                _Volume_MA30 = @(self.SumOfLastVolume.floatValue / 30);
            }
        }
    }
    return _Volume_MA30;
}


- (NSNumber *)EMA5 {
    if (!_EMA5) {
        _EMA5 = @(2 / 6 * (self.Close.floatValue - self.PreviousStockModel.EMA5.floatValue) + self.PreviousStockModel.EMA5.floatValue);
    }
    return _EMA5;
}

- (NSNumber *)EMA7 {
    if (!_EMA7) {
        _EMA7 = @(2 / 8 * (self.Close.floatValue - self.PreviousStockModel.EMA7.floatValue) + self.PreviousStockModel.EMA7.floatValue);
    }
    return _EMA7;
}

- (NSNumber *)EMA10 {
    if (!_EMA10) {
        _EMA10 = @(2 / 11 * (self.Close.floatValue - self.PreviousStockModel.EMA10.floatValue) + self.PreviousStockModel.EMA10.floatValue);
    }
    return _EMA10;
}

- (NSNumber *)EMA20 {
    if (!_EMA20) {
        _EMA20 = @(2 / 21 * (self.Close.floatValue - self.PreviousStockModel.EMA20.floatValue) + self.PreviousStockModel.EMA20.floatValue);
    }
    return _EMA20;
}

- (NSNumber *)EMA30 {
    if (!_EMA30) {
        _EMA30 = @(2 / 31 * (self.Close.floatValue - self.PreviousStockModel.EMA30.floatValue) + self.PreviousStockModel.EMA30.floatValue);
    }
    return _EMA30;
}

- (NSNumber *)EMA12 {
    if (!_EMA12) {
//        _EMA12 = @(2 / 13 * (self.Close.floatValue - self.PreviousStockModel.EMA12.floatValue) + self.PreviousStockModel.EMA12.floatValue);
        _EMA12 = @((2 * self.Close.floatValue + 11 * self.PreviousStockModel.EMA12.floatValue)/13);
    }
    return _EMA12;
}

- (NSNumber *)EMA26 {
    if (!_EMA26) {
//        _EMA26 = @(2 / 27 * (self.Close.floatValue - self.PreviousStockModel.EMA26.floatValue) + self.PreviousStockModel.EMA26.floatValue);
        _EMA26 = @((2 * self.Close.floatValue + 25 * self.PreviousStockModel.EMA26.floatValue)/27);
    }
    return _EMA26;
}

- (NSNumber *)Volume_EMA7 {
    if (!_Volume_EMA7) {
        //        _Volume_EMA7 = @((self.Volume.floatValue + 3 * self.PreviousStockModel.Volume_EMA7.floatValue) / 4);
        //        _Volume_EMA7 = @((2 * self.Volume.floatValue + 6 * self.PreviousStockModel.Volume_EMA7.floatValue) / 8);
        _Volume_EMA7 = @((2 / (7 + 1)) * (self.Volume.floatValue - self.PreviousStockModel.Volume_EMA7.floatValue) + self.PreviousStockModel.Volume_EMA7.floatValue);
    }
    return _Volume_EMA7;
}

- (NSNumber *)Volume_EMA30 {
    if(!_Volume_EMA30) {
        //        _Volume_EMA30 = @((2 * self.Volume.floatValue + 29 * self.PreviousStockModel.Volume_EMA30.floatValue)/31);
        _Volume_EMA30 = @((2 / (30 + 1)) * (self.Volume.floatValue - self.PreviousStockModel.Volume_EMA30.floatValue) + self.PreviousStockModel.Volume_EMA30.floatValue);
    }
    return _Volume_EMA30;
}

- (NSNumber *)DIF {
    if (!_DIF) {
        _DIF = @(self.EMA12.floatValue - self.EMA26.floatValue);
    }
    return _DIF;
}

- (NSNumber *)DEA {
    if (!_DEA) {
        _DEA = @(self.PreviousStockModel.DEA.floatValue * 0.8 + 0.2 * self.DIF.floatValue);
    }
    return _DEA;
}

- (NSNumber *)MACD {
    if (!_MACD) {
        _MACD = @(2 * (self.DIF.floatValue - self.DEA.floatValue));
    }
    return _MACD;
}

- (NSNumber *)SumOfLastClose {
    if (!_SumOfLastClose) {
        _SumOfLastClose = @(self.PreviousStockModel.SumOfLastClose.floatValue + self.Close.floatValue);
    }
    return _SumOfLastClose;
}

- (NSNumber *)SumOfLastVolume {
    if (!_SumOfLastVolume) {
        _SumOfLastVolume = @(self.PreviousStockModel.SumOfLastVolume.floatValue + self.Volume.floatValue);
    }
    return _SumOfLastVolume;
}

- (NSNumber *)NineClocksMinPrice {
    if (!_NineClocksMinPrice) {
        [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
    }
    return _NineClocksMinPrice;
}

- (NSNumber *)NineClocksMaxPrice {
    if (!_NineClocksMaxPrice) {
        if ([self.ParentGroupModel.models indexOfObject:self] >= 8) {
            [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
        } else {
            _NineClocksMaxPrice = @0;
        }
    }
    return _NineClocksMaxPrice;
}

- (NSNumber *)RSV_9 {
    if (!_RSV_9) {
        if (self.NineClocksMaxPrice.floatValue == self.NineClocksMinPrice.floatValue) {
            _RSV_9 = @100;
        } else {
            _RSV_9 = @((self.Close.floatValue - self.NineClocksMinPrice.floatValue) * 100 / (self.NineClocksMaxPrice.floatValue - self.NineClocksMinPrice.floatValue));
        }
    }
    return _RSV_9;
}

- (NSNumber *)KDJ_K {
    if (!_KDJ_K) {
        _KDJ_K = @((self.RSV_9.floatValue + 2 * (self.PreviousStockModel.KDJ_K.floatValue ? self.PreviousStockModel.KDJ_K.floatValue : 50))/3);
    }
    return _KDJ_K;
}

- (NSNumber *)KDJ_D {
    if(!_KDJ_D) {
        _KDJ_D = @((self.KDJ_K.floatValue + 2 * (self.PreviousStockModel.KDJ_D.floatValue ? self.PreviousStockModel.KDJ_D.floatValue : 50))/3);
    }
    return _KDJ_D;
}

- (NSNumber *)KDJ_J {
    if(!_KDJ_J) {
        _KDJ_J = @(3 * self.KDJ_K.floatValue - 2 * self.KDJ_D.floatValue);
    }
    return _KDJ_J;
}

- (FLStockModel *)PreviousStockModel {
    if (!_PreviousStockModel) {
        _PreviousStockModel = [FLStockModel new];
        _PreviousStockModel.DIF = @(0);
        _PreviousStockModel.DEA = @(0);
        _PreviousStockModel.MACD = @(0);
        
        _PreviousStockModel.MA5 = @(0);
        _PreviousStockModel.MA7 = @(0);
        _PreviousStockModel.MA10 = @(0);
        _PreviousStockModel.MA20 = @(0);
        _PreviousStockModel.MA30 = @(0);
        
        _PreviousStockModel.MA12 = @(0);
        _PreviousStockModel.MA26 = @(0);
        
        _PreviousStockModel.EMA12 = @(0);
        _PreviousStockModel.EMA26 = @(0);
        
        _PreviousStockModel.Volume_MA7 = @(0);
        _PreviousStockModel.Volume_MA30 = @(0);
        _PreviousStockModel.Volume_EMA7 = @(0);
        _PreviousStockModel.Volume_EMA30 = @(0);
        
        _PreviousStockModel.SumOfLastClose = @(0);
        _PreviousStockModel.SumOfLastVolume = @(0);
        _PreviousStockModel.KDJ_K = @(50);
        _PreviousStockModel.KDJ_D = @(50);
        _PreviousStockModel.KDJ_J = @(50);
    }
    return _PreviousStockModel;
}

- (FLStockGroupModel *)ParentGroupModel {
    if(!_ParentGroupModel) {
        _ParentGroupModel = [FLStockGroupModel new];
    }
    return _ParentGroupModel;
}

//对Model数组进行排序，初始化每个Model的最新9Clock的最低价和最高价
- (void)rangeLastNinePriceByArray:(NSArray <FLStockModel *>*)models condition:(NSComparisonResult)cond
{
    if (models.count < 7) {
        return ;
    }
    switch (cond) {
            //最高价
        case NSOrderedAscending:
        {
            dispatch_queue_t ascendQueue = dispatch_queue_create("Ascending.queue", DISPATCH_QUEUE_SERIAL);
            dispatch_async(ascendQueue, ^{
                //第一个循环结束后，ClockFirstValue为最小值
                for (NSInteger j = 7; j >= 1; j --) {
                    NSNumber *emMaxValue = @0;
                    NSInteger em = j;
                    
                    while (em >= 0) {
                        if([emMaxValue compare:models[em].High] == cond) {
                            emMaxValue = models[em].High;
                        }
                        em --;
                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                    });
                    models[j].NineClocksMaxPrice = emMaxValue;
                }
            });
            
            
            dispatch_async(ascendQueue, ^{
                //第一个循环结束后，ClockFirstValue为最小值
                for (NSInteger i = 0, j = 8; j < models.count; i ++,j ++) {
                    NSNumber *emMaxValue = @0;
                    NSInteger em = j;
                    
                    while ( em >= i) {
                        if([emMaxValue compare:models[em].High] == cond) {
                            emMaxValue = models[em].High;
                        }
                        em --;
                    }
                    models[j].NineClocksMaxPrice = emMaxValue;
                }
            });
        }
            break;
        case NSOrderedDescending:
        {
            //异步串行
            dispatch_queue_t descendQueue = dispatch_queue_create("Descending.queue", DISPATCH_QUEUE_SERIAL);
            dispatch_async(descendQueue, ^{
                //第一个循环结束后，ClockFirstValue为最小值
                for (NSInteger j = 7; j >= 1; j --) {
                    NSNumber *emMinValue = @(10000000000);
                    
                    NSInteger em = j;
                    
                    while (em >= 0) {
                        if([emMinValue compare:models[em].Low] == cond) {
                            emMinValue = models[em].Low;
                        }
                        em --;
                    }
                    models[j].NineClocksMinPrice = emMinValue;
                }
            });
            
            dispatch_async(descendQueue, ^{
                for (NSInteger i = 0, j = 8; j < models.count; i ++,j ++) {
                    NSNumber *emMinValue = @(10000000000);
                    NSInteger em = j;
                    while ( em >= i) {
                        if([emMinValue compare:models[em].Low] == cond) {
                            emMinValue = models[em].Low;
                        }
                        em --;
                    }
                    models[j].NineClocksMinPrice = emMinValue;
                }
            });
        }
            break;
        default:
            break;
    }
}

- (void)initWithDictionary:(NSDictionary *)dic {
    if (self) {
        _Date = [self dateConversionToTimeString:[NSString stringWithFormat:@"%@",dic[@"Date"]]];
        _YesterdayClose = @([dic[@"YesterdayClose"] floatValue]);
        _Open = @([dic[@"Open"] floatValue]);
        _High = @([dic[@"High"] floatValue]);
        _Low = @([dic[@"Low"] floatValue]);
        _Close = @([dic[@"Close"] floatValue]);
        _Volume = @([dic[@"Volume"] integerValue]);
        _Amount = @([dic[@"Amount"] integerValue]);
        _Avg = @([dic[@"Avg"] floatValue]);
        self.SumOfLastClose = @(_Close.floatValue + self.PreviousStockModel.SumOfLastClose.floatValue);
        self.SumOfLastVolume = @(_Volume.floatValue + self.PreviousStockModel.SumOfLastVolume.floatValue);
    }
}

- (void)initFirstModel {
    _KDJ_K = @(55.27);
    _KDJ_D = @(55.27);
    _KDJ_J = @(55.27);
    
    _MA5 = _Close;
    _MA7 = _Close;
    _MA10 = _Close;
    _MA20 = _Close;
    _MA30 = _Close;
    _MA12 = _Close;
    _MA26 = _Close;

    
    _EMA5 = _Close ;
    _EMA7 = _Close;
    _EMA10 = _Close;
    _EMA20 = _Close;
    _EMA30 = _Close;
    _EMA12 = _Close;
    _EMA26 = _Close;
    
    _NineClocksMinPrice = _Low;
    _NineClocksMaxPrice = _High;
    
    [self DIF];
    [self DEA];
    [self MACD];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
    
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
}

- (void)initData {
    [self MA5];
    [self MA7];
    [self MA10];
    [self MA20];
    [self MA30];
    [self MA12];
    [self MA26];
    
    [self EMA5];
    [self EMA7];
    [self EMA10];
    [self EMA20];
    [self EMA30];
    [self EMA12];
    [self EMA26];
    
    [self DIF];
    [self DEA];
    [self MACD];
    
    [self NineClocksMaxPrice];
    [self NineClocksMinPrice];
    
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
}

/**
 时间字符串转时间

 @param timeString 时间
 @return 时间
 */
- (NSDate *)dateConversionToTimeString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *timeDate = [formatter dateFromString:timeString];
    return timeDate;//[NSDate dateWithTimeIntervalSince1970:timeStamp];
}


@end
