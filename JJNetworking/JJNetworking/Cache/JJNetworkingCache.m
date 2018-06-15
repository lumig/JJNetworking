//
//  JJNetworkingCache.m
//  WowTemplate
//
//  Created by luming on 2018/5/16.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJNetworkingCache.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "ns"
@implementation JJNetworkingCache

+ (instancetype)shareIntance
{
    static JJNetworkingCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (NSString*)cacheDirctory{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"JJNetworkingCache"];
    NSError *error;
    BOOL  bret = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
    if (!bret) {
        return nil;
    }
    return cacheDir;
}
- (NSString*)cacheFileFullPath:(NSString*)url{
    NSString *fileName = [self MD5_32Bit:url];
    NSString *cacheDir = [self cacheDirctory];
    return [cacheDir stringByAppendingPathComponent:fileName];
}
- (void)saveData:(id)object atUrl:(NSString*)url{
    NSString *fileFullPath = [self cacheFileFullPath:url];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [data writeToFile:fileFullPath atomically:YES];
    
}

- (id)readDataAtUrl:(NSString*)url{
    NSString *filFullPath  = [self cacheFileFullPath:url];
    NSData *data = [NSData dataWithContentsOfFile:filFullPath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (BOOL)isCacheDataInvalid:(NSString*)url{
    NSString *filFullPath  = [self cacheFileFullPath:url];
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:filFullPath isDirectory:nil];
    NSDictionary *attributeDic = [[NSFileManager defaultManager]attributesOfItemAtPath:filFullPath error:nil];
    NSDate *lastCacheDate = attributeDic.fileModificationDate;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastCacheDate];
    BOOL isExpire = (timeInterval > 600*600);
    if (isFileExist && !isExpire) {
        return YES;
    }
    return NO;
}

- (NSInteger)CacheSize{
    NSInteger totalSize = 0;
    NSString *cacheDir = [self cacheDirctory];
    NSDirectoryEnumerator *enmuerator = [[NSFileManager defaultManager]enumeratorAtPath:cacheDir];
    for (NSString *filename in enmuerator) {
        NSString *fileFullPath = [cacheDir stringByAppendingPathComponent:filename];
        NSDictionary *attributeDic = [[NSFileManager defaultManager]attributesOfItemAtPath:fileFullPath error:nil];
        totalSize += attributeDic.fileSize;
    }
    return totalSize;
}

- (void)clearDisk{
    NSString *cacheDir = [self cacheDirctory];
    [[NSFileManager defaultManager] removeItemAtPath:cacheDir error:nil];
}


#pragma mark - private
- (NSString *)MD5_32Bit:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    NSString* str_format = [NSString stringWithFormat:
                            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
                            ];
    return  str_format.uppercaseString;
    
}

@end
