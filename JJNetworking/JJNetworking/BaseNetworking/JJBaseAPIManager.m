//
//  JJBaseAPIManager.m
//  WowTemplate
//
//  Created by luming on 2018/4/25.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJBaseAPIManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSObject+YYModel.h"
#import "AFHTTPSessionManager.h"
#import "AdSupport/AdSupport.h"

#import "JJ_NetworkingBaseConfig.h"
#import "NSString+JJ_Networking.h"
#import "NSURLSessionDataTask+JJ_Networking.h"
#import "JJNetworkingCache.h"
#import "BaseModel.h"
#import "CUserDefault.h"
@interface JJBaseAPIManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation JJBaseAPIManager

+ (instancetype)shareInstance {
    static JJBaseAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setRequestHeaderField:(NSDictionary *)dict
{
    [_manager.requestSerializer setValue:dict[@"accessToken"] forHTTPHeaderField:@"accessToken"];

}


- (void)cancelOperations {
    [self.manager.operationQueue cancelAllOperations];
        for (NSURLSessionTask *task in self.manager.tasks)
        {
            [task cancel];
        }
}

//监听网络是否可达
- (void)setReachableMonitorOn:(BOOL)isOn {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (isOn) {
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpClient:statusChanged:)]) {
                [self.delegate httpClient:self statusChanged:status];
            }
        }];
    } else {
        [manager stopMonitoring];
    }
}

- (NSURLSessionDataTask *)getUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion  error : (void (^)(NSError *))failure{
    return [self getUrl:url params:params class:cls completion:completion exceptions:nil error:failure];
}
- (NSURLSessionDataTask *)getUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))failure
{
    NSString *getUrl = [[JJ_NetworkingBaseConfig jj_shareInstance] assembledUrl:url];
   return [self.manager GET:getUrl parameters:params  progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self success:task reponseObject:responseObject class:cls completion:completion exceptions:exceptions error:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failure:task httpError:error class:cls completion:completion  error:failure];

    }];
}

- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class)classVc completion:(void (^)(id))completion {
   return [self postUrl:url params:params class:classVc completion:completion error:nil];
}

- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion error : (void (^)(NSError *))failure
{
   return [self postUrl:url params:params class:cls completion:completion exceptions:nil error:failure];
}
- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls isCache:(BOOL)isCache completion : (void (^)(id))completion error : (void (^)(NSError *))failure{
    return [self postUrl:url params:params class:cls isCache:isCache completion:completion exceptions:nil error:failure];}
- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))failure
{
    return [self postUrl:url params:params class:cls isCache:NO completion:completion exceptions:exceptions error:failure];
}

- (NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params class:(Class )cls isCache:(BOOL)isCache completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))failure
{
    [[JJ_NetworkingBaseConfig jj_shareInstance] setNetworkActivityIndicator];
    NSString *getUrl = [[JJ_NetworkingBaseConfig jj_shareInstance] assembledUrl:url];
    
    return [self.manager POST:getUrl parameters:params  progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isCache) {//是否缓存
            if ([[JJNetworkingCache shareIntance] isCacheDataInvalid:url]) {
                [[JJNetworkingCache shareIntance] saveData:responseObject atUrl:url];
            }
        }
        [self success:task reponseObject:responseObject class:cls completion:completion exceptions:exceptions error:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failure:task httpError:error class:cls completion:completion  error:failure];
        
    }];
}



- (void)success : (NSURLSessionDataTask *)task reponseObject : (id)responseObject class : (Class) class completion : (void (^)(id))completion exceptions:(void (^)(id))exceptions error : (void (^)(NSError *))error {
    
    [[JJ_NetworkingBaseConfig jj_shareInstance] cancelNetworkActivityIndicator];
    //获取球头头部文件
    if ([NSURLSessionDataTask resaveAccesstokenWithTask:task].length > 0) {
        NSDictionary *headerDict = @{@"accessToken":[NSURLSessionDataTask resaveAccesstokenWithTask:task]};
        [self setRequestHeaderField:headerDict];
    }
   

    NSDictionary *dic =responseObject;
//    NSLog(@"data===%@",dic);
    //这里是在调用统一由代理处理时会调用的方法，000是返回NO 跳出继续执行
    if (!exceptions&&self.delegate && [self.delegate respondsToSelector:@selector(httpClient:filterResponse:error:)]){
        if ([self.delegate httpClient:self filterResponse:dic error:nil]) {
//            if (error) {
//                 error(nil);
//            }

            return;
        }
    }
    //class 我们传入表示我们需要什么格式的数据
    //意思是返回一个BOOL类型的值，表示调用该方法的类 是不是 参数类的一个子类 或者 是这个类的本身
    if ([class isSubclassOfClass:[NSDictionary class]]) {
        completion(dic);
    } else if ([class isSubclassOfClass:[NSObject class]]) {
        BaseModel *model = [class  modelWithJSON:dic];
        if ([[model class] isSubclassOfClass:[BaseModel class]])
        {//成功获得数据返回
            if (model && completion && [model.status isEqualToString:kJJ_NetworkingStatusSuccess]) {
                completion(model);
                return;
            }else{//异常数据返回处理
            if (model && exceptions &&![model.status isEqualToString:kJJ_NetworkingStatusSuccess]) {
                exceptions(model);
                return;
            }
            }
        }else
        {//处理异常一般不会到这里
            if (model && completion) {
                completion(model);
                return;
            }
            
        }
        
    }
}

- (void)failure : (NSURLSessionDataTask *)task httpError: (id)httpError class : (Class) class completion : (void (^)(id))completion error : (void (^)(NSError *))failre {
    NSLog(@"http error %@",httpError );
    [[JJ_NetworkingBaseConfig jj_shareInstance] cancelNetworkActivityIndicator];
    
    if(failre)
    {
        failre(nil);
        
    }
    
}


#pragma mark - setter and getter
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] init];
        [_manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [_manager.requestSerializer setTimeoutInterval:30.f];
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer=[AFJSONRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
        
        //        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    if([CUserDefault shareInstance].userInfoModel.accessToken.length > 0)
    {
        [self setRequestHeaderField:@{@"accessToken":[CUserDefault shareInstance].userInfoModel.accessToken}];
        
    }
    return _manager;
}


@end
