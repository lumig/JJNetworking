//
//  NSURLSessionDataTask+JJ_Networking.m
//  WowTemplate
//
//  Created by luming on 2018/5/16.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "NSURLSessionDataTask+JJ_Networking.h"
#import "CUserDefault.h"
@implementation NSURLSessionDataTask (JJ_Networking)

+ (NSString *)resaveAccesstokenWithTask:(NSURLSessionDataTask *)task
{
    //获取球头头部文件
    NSString *accesstoken = @"";
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *allHeaders = response.allHeaderFields;
    if ([allHeaders.allKeys containsObject:@"accessToken" ]) {
        accesstoken = allHeaders[@"accessToken"];
        CUserInfoModel *userInfoModel = [CUserDefault shareInstance].userInfoModel;
        userInfoModel.accessToken = allHeaders[@"accessToken"];
        [[CUserDefault shareInstance] saveUserInfoModel:userInfoModel];
    }
    return accesstoken;
}

@end
