//
//  JJNetworkingCache.h
//  WowTemplate
//
//  Created by luming on 2018/5/16.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNetworkingCache : NSObject
+ (instancetype)shareIntance;

//这里一般存储字典
- (void)saveData:(id)object atUrl:(NSString*)url;

//读取数据
- (id)readDataAtUrl:(NSString*)url;
//判断是否有该缓存
- (BOOL)isCacheDataInvalid:(NSString*)url;
//获取存储大小
- (NSInteger)CacheSize;
//清除缓存
- (void)clearDisk;
@end
