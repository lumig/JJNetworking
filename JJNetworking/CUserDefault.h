//
//  CUserDefault.h
//  CreditCat
//
//  Created by luming on 2017/3/17.
//  Copyright © 2017年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUserInfoModel.h"


@interface CUserDefault : NSObject

/**
 用户信息
 */
//@property (nonatomic,strong) CUserInfoModel *userInfoModel;
//
///**
// 是否登录
// */
//@property (nonatomic,assign) BOOL isLogin;

/**
 token是否过期
 */
@property (nonatomic,assign) BOOL isHaveToken;


+ (CUserDefault *)shareInstance;


/**
 保存用户信息
 */
- (void)saveUserInfoModel:(CUserInfoModel *)model;



/**
 移除用户信息
 */
- (void)removeUserInfo;


/**
 获取当前用户数据
 */
- (CUserInfoModel *)userInfoModel;


/**
 获取是否登录
 */
- (BOOL)isLogin;

@end
