//
//  CUserInfoModel.m
//  CreditCat
//
//  Created by luming on 2017/4/17.
//  Copyright © 2017年 luming. All rights reserved.
//

#import "CUserInfoModel.h"

//#define ISLOGIN @"isLogin"

@implementation CUserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"accessToken":@"data.accessToken",
             @"realName":@"data.realName",
             @"mobileNo":@"data.mobileNo",
             @"headImageURL":@"data.headImageURL",
             @"isReal":@"data.isReal",
             @"serviceHotline":@"data.serviceHotline",
             };
}


@end
