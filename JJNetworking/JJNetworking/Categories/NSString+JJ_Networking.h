//
//  NSString+JJ_Networking.h
//  JJNetworking
//
//  Created by luming on 2018/5/18.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JJ_Networking)

//请求成功 000
extern NSString *const kJJ_NetworkingStatusSuccess;
//token失效异常编码 006
extern NSString *const kJJ_NetworkingStatusErrorToken;
//token不能为空 007
extern NSString *const kJJ_NetworkingStatusTokenNull;
//绑定银行卡异常 005
extern NSString *const kJJ_NetworkingStatusErrorBindCard;
//数字密码错误 201
extern NSString *const kJJ_NetworkingStatusErrorNumberPassword;

@end
