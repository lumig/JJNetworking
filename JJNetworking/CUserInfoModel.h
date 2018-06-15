//
//  CUserInfoModel.h
//  CreditCat
//
//  Created by luming on 2017/4/17.
//  Copyright © 2017年 luming. All rights reserved.
//

#import "BaseModel.h"

@interface CUserInfoModel : BaseModel


/**
 accessToken 	string 	访问令牌
 realName 	string 	用户姓名
 mobileNo 	string 	手机号码
 headImageURL 	string 	头像网址
 isReal 	int 	0.否 1.是
 serviceHotline 	string 	客服电话
 realName 	string 	姓名
 */
@property (nonatomic,copy) NSString *accessToken;

@property (nonatomic,copy) NSString *realName;

@property (nonatomic,copy) NSString *mobileNo;

@property (nonatomic,copy) NSString *headImageURL;

@property (nonatomic,assign) NSInteger isReal;

@property (nonatomic,copy) NSString *serviceHotline;

/**
 用户头像
 */
@property (nonatomic, copy) NSString *userHeadImageStr;

/**
 登录账号
 */
@property (nonatomic, copy) NSString *accountNumber;

@end
