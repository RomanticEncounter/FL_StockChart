//
//  FLNetworkingManager.h
//  FL_StockChart
//
//  Created by mac on 2018/3/1.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLNetworkingManager : NSObject

+ (FLNetworkingManager *)sharedManager;

- (void)POST:(NSString *)url Parameters:(NSDictionary *)param Success:(void (^)(NSDictionary *responseObject))success Fail:(void (^)(void))fail;

- (void)GET:(NSString *)url Parameters:(NSDictionary *)param Success:(void (^)(NSDictionary *responseObject))success Fail:(void (^)(void))fail;

@end
