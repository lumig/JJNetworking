//
//  JJBaseAPIManager.h
//  WowTemplate
//
//  Created by luming on 2018/4/25.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

//#import "AFHTTPRequestOperation"

@class JJBaseAPIManager;

@protocol JJBaseAPIManagerDelegate<NSObject>

@optional
//获取网络状况
- (void)httpClient:(JJBaseAPIManager *)client statusChanged:(AFNetworkReachabilityStatus) status;
//请求成功或者失败的
- (BOOL)httpClient:(JJBaseAPIManager *)client filterResponse:(NSDictionary *)dic error:(NSError *)error;
//请求失败重新发起请求
- (BOOL)httpClient:(JJBaseAPIManager *)client filterRetryFailureSessionManager:(AFHTTPSessionManager *)sessionManager error:(NSError *)error;

@end
@interface JJBaseAPIManager : NSObject
@property (nonatomic, weak) id <JJBaseAPIManagerDelegate>delegate;

+ (instancetype)shareInstance;



#pragma mark - 网络请求队列操作
- (void)cancelOperations;


#pragma mark - 设置网络请求头中需要的属性等
- (void)setRequestHeaderField:(NSDictionary *)dict;

#pragma mark - get请求
//不需要单独处理异常，直接在basecontroller的代理方法中处理
- (NSURLSessionDataTask *)getUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion  error : (void (^)(NSError *))failure;
//需要单独处理异常
- (NSURLSessionDataTask *)getUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))failure;
#pragma mark - post请求
//加载数据调用
//返回NSURLSessionDataTask 请求任务的post请求 为了取消当个网络请求 ,要是有需要直接拿到当前任务实现[task cancel]
//不需要单独处理异常，直接在basecontroller的代理方法中处理
- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion error : (void (^)(NSError *))failure;
//是否有缓存
- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls isCache:(BOOL)isCache completion : (void (^)(id))completion error : (void (^)(NSError *))failure;


//需要单独处理异常
- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))failure;
//是否有缓存
- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls isCache:(BOOL)isCache completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))failure;


@end
