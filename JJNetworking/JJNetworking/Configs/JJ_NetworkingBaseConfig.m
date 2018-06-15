//
//  JJ_NetworkingBaseConfig.m
//  WowTemplate
//
//  Created by luming on 2018/5/16.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJ_NetworkingBaseConfig.h"

#ifdef DEBUG
NSString *const kBaseConfig_JJHostUrl = @"http://10.138.60.143:10000";
#else
NSString *const kBaseConfig_JJHostUrl = @"http://api.creditcat.cn"
#endif

NSString *const kBaseConfig_JJHostApi = @"/app";

@interface JJ_NetworkingBaseConfig()
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *api;
@end
@implementation JJ_NetworkingBaseConfig

+ (instancetype)jj_shareInstance
{
    static JJ_NetworkingBaseConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)setAPI:(NSString *)api {
    self.baseUrl = [NSString stringWithFormat:@"%@%@", self.host, api];
}
- (void)setHostUrl:(NSString *)host {
    self.baseUrl = [NSString stringWithFormat:@"%@%@", host, self.api];
}


- (NSString *)assembledUrl:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url.host && url.scheme)
        return urlStr;
    else
        return [NSString stringWithFormat:@"%@%@", self.baseUrl, url];
}


//设置显示状态栏上的菊花轮
-(void)setNetworkActivityIndicator{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

//不显示状态看上的菊花轮
- (void)cancelNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//检验网络状态
- (BOOL)networkStatus{
    
    RealReachability *reachablity = [RealReachability sharedInstance];
    [reachablity startNotifier];
    ReachabilityStatus status = [reachablity currentReachabilityStatus];
    [reachablity stopNotifier];
    return  status > 0;
}


#pragma mark - setter and getter
- (NSString *)baseUrl {
    if (!_baseUrl) {
        _baseUrl = [NSString stringWithFormat:@"%@%@", self.host, self.api];
    }
    return _baseUrl;
}

- (NSString *)api {
    if (!_api) {
        _api = kBaseConfig_JJHostApi;
    }
    return _api;
}

- (NSString *)host {
    if (!_host) {
        _host = kBaseConfig_JJHostUrl;
    }
    return _host;
}



@end

/*
 // url 编码格式
 foo://example.com:8042/over/there?name=ferret#nose
 \_/ \______________/ \________/\_________/ \__/
 |         |              |         |        |
 scheme authority         path      query   fragment
 
 scheme://host.domain:port/path/filename
 scheme - 定义因特网服务的类型。最常见的类型是 http
 host - 定义域主机（http 的默认主机是 www）
 domain - 定义因特网域名，比如 w3school.com.cn
 :port - 定义主机上的端口号（http 的默认端口号是 80）
 path - 定义服务器上的路径（如果省略，则文档必须位于网站的根目录中）。
 filename - 定义文档/资源的名称
 */

