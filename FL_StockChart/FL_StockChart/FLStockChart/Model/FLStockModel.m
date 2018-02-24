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
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 4) {
            if (index > 4) {
                _MA5 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 5].SumOfLastClose.floatValue) / 5);
            } else {
                _MA5 = @(self.SumOfLastClose.floatValue / 5);
            }
        }
    }
    return _MA5;
}

- (NSNumber *)MA7 {
    if (!_MA7) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 6) {
            if (index > 6) {
                _MA7 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 7].SumOfLastClose.floatValue) / 7);
            } else {
                _MA7 = @(self.SumOfLastClose.floatValue / 7);
            }
        }
    }
    return _MA7;
}

- (NSNumber *)MA10 {
    if (!_MA10) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 9) {
            if (index > 9) {
                _MA10 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 10].SumOfLastClose.floatValue) / 10);
            } else {
                _MA10 = @(self.SumOfLastClose.floatValue / 10);
            }
        }
    }
    return _MA10;
}

- (NSNumber *)MA20 {
    if (!_MA20) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            if (index > 19) {
                _MA20 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 20].SumOfLastClose.floatValue) / 20);
            } else {
                _MA20 = @(self.SumOfLastClose.floatValue / 20);
            }
        }
    }
    return _MA20;
}

- (NSNumber *)MA30 {
    if (!_MA30) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 29) {
            if (index > 29) {
                _MA30 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 30].SumOfLastClose.floatValue) / 30);
            } else {
                _MA30 = @(self.SumOfLastClose.floatValue / 30);
            }
        }
    }
    return _MA30;
}

- (NSNumber *)MA12 {
    if (!_MA12) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 11) {
            if (index > 11) {
                _MA12 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 12].SumOfLastClose.floatValue) / 12);
            } else {
                _MA12 = @(self.SumOfLastClose.floatValue / 12);
            }
        }
    }
    return _MA12;
}

- (NSNumber *)MA26 {
    if (!_MA26) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 25) {
            if (index > 25) {
                _MA26 = @((self.SumOfLastClose.floatValue - self.parentGroupModel.models[index - 26].SumOfLastClose.floatValue) / 26);
            } else {
                _MA26 = @(self.SumOfLastClose.floatValue / 26);
            }
        }
    }
    return _MA26;
}

- (NSNumber *)Volume_MA7 {
    if (!_Volume_MA7) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 6) {
            if (index > 6) {
                _Volume_MA7 = @((self.SumOfLastVolume.floatValue - self.parentGroupModel.models[index - 7].SumOfLastVolume.floatValue) / 7);
            } else {
                _Volume_MA7 = @(self.SumOfLastVolume.floatValue / 7);
            }
        }
    }
    return _Volume_MA7;
}

- (NSNumber *)Volume_MA30 {
    if (!_Volume_MA30) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 29) {
            if (index > 29) {
                _Volume_MA30 = @((self.SumOfLastVolume.floatValue - self.parentGroupModel.models[index - 30].SumOfLastVolume.floatValue) / 30);
            } else {
                _Volume_MA30 = @(self.SumOfLastVolume.floatValue / 30);
            }
        }
    }
    return _Volume_MA30;
}

- (FLStockModel *)previousStockModel {
    if (!_previousStockModel) {
        _previousStockModel = [FLStockModel new];
        _previousStockModel.DIF = @(0);
        _previousStockModel.DEA = @(0);
        _previousStockModel.MACD = @(0);
        
        _previousStockModel.MA5 = @(0);
        _previousStockModel.MA7 = @(0);
        _previousStockModel.MA10 = @(0);
        _previousStockModel.MA20 = @(0);
        _previousStockModel.MA30 = @(0);
        
        _previousStockModel.MA12 = @(0);
        _previousStockModel.MA26 = @(0);
        
        _previousStockModel.EMA12 = @(0);
        _previousStockModel.EMA26 = @(0);
        
        _previousStockModel.Volume_MA7 = @(0);
        _previousStockModel.Volume_MA30 = @(0);
        _previousStockModel.Volume_EMA7 = @(0);
        _previousStockModel.Volume_EMA30 = @(0);
        
        _previousStockModel.SumOfLastClose = @(0);
        _previousStockModel.SumOfLastVolume = @(0);
        _previousStockModel.KDJ_K = @(50);
        _previousStockModel.KDJ_D = @(50);
        _previousStockModel.KDJ_J = @(50);
    }
    return _previousStockModel;
}

- (FLStockGroupModel *)parentGroupModel {
    if(!_parentGroupModel) {
        _parentGroupModel = [FLStockGroupModel new];
    }
    return _parentGroupModel;
}



@end
