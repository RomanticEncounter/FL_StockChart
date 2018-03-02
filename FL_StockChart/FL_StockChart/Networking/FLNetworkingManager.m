//
//  FLNetworkingManager.m
//  FL_StockChart
//
//  Created by mac on 2018/3/1.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import "FLNetworkingManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation FLNetworkingManager

+ (FLNetworkingManager *)sharedManager {
    static FLNetworkingManager *flNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flNetworkManager = [[self alloc]init];
    });
    return flNetworkManager;
}

/**
 AFN单例
 
 @return AFHTTPSessionManager
 */
- (AFHTTPSessionManager *)defaultNetManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@""]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //请求超时
        manager.requestSerializer.timeoutInterval = 20;
//        manager.baseURL = [NSURL URLWithString:"(nonnull NSString *)"];
    });
    return manager;
}

#pragma mark - POST
- (void)POST:(NSString *)url Parameters:(NSDictionary *)param Success:(void (^)(NSDictionary *responseObject))success Fail:(void (^)(void))fail {
    //断言
    NSAssert(url != nil, @"url不能为空");
    AFHTTPSessionManager *manager = [self defaultNetManager];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *successDic = [self conversionDictionaryWithJSONString:dataStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ? : success(successDic);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            !fail ? : fail();
        });
    }];
}

#pragma mark - GET
- (void)GET:(NSString *)url Parameters:(NSDictionary *)param Success:(void (^)(NSDictionary *responseObject))success Fail:(void (^)(void))fail {
    //断言
    NSAssert(url != nil, @"url不能为空");
    //使用AFNetworking进行网络请求
    AFHTTPSessionManager *manager = [self defaultNetManager];
    //发起get请求
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *successDic = [self conversionDictionaryWithJSONString:dataStr];
        //通过block，将数据回掉给用户
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ? : success(successDic);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            !fail ? : fail();
        });
    }];
}

#pragma mark JSON转字典
- (NSDictionary *)conversionDictionaryWithJSONString:(NSString *)jsonString {
    if (!jsonString) return nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

@end
