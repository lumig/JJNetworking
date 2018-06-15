//
//  JJ_NetworkingBaseConfig.h
//  WowTemplate
//
//  Created by luming on 2018/5/16.
//  Copyright © 2018年 luming. All rights reserved.
//
//配置网络请求设置
#import <Foundation/Foundation.h>
extern NSString *const kBaseConfig_JJHostUrl;
extern NSString *const kBaseConfig_JJHostApi;

@interface JJ_NetworkingBaseConfig : NSObject


+ (instancetype)jj_shareInstance;


/**
 修改默认api

 @param api 新api
 */
- (void)setAPI:(NSString *)api;


/**
 修改默认的host

 @param host 新的host
 */
- (void)setHostUrl:(NSString *)host;

/**
 返回请求地址

 @param urlStr 添加需要拼接的地址
 @return 返回完整的请求地址
 */
- (NSString *)assembledUrl:(NSString *)urlStr;


//是否有网络
- (BOOL)networkStatus;

//显示状态看上的菊花轮
-(void)setNetworkActivityIndicator;

//不显示状态看上的菊花轮
- (void)cancelNetworkActivityIndicator;
@end


