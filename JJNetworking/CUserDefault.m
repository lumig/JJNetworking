//
//  CUserDefault.m
//  CreditCat
//
//  Created by luming on 2017/3/17.
//  Copyright © 2017年 luming. All rights reserved.
//

#import "CUserDefault.h"
#import <YYKit.h>
#define USERINFO @"userInfo"
#define ISLOGIN @"isLogin"

@interface CUserDefault ()

/**
 存取用户信息
 */
//@property (nonatomic, strong) CUserInfoModel *infoModel;

@end

@implementation CUserDefault

+ (CUserDefault *)shareInstance
{
    static CUserDefault *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)saveUserInfoModel:(CUserInfoModel *)model
{
    NSDictionary *dict =[model modelToJSONObject];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:dict forKey:USERINFO];
    [userDef synchronize];
}

- (void)removeUserInfo
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef removeObjectForKey:USERINFO];
    NSDictionary *dict = @{};
    [userDef setObject:dict forKey:USERINFO];
    [userDef synchronize];
}

- (CUserInfoModel *)userInfoModel
{

    CUserInfoModel *model = [[CUserInfoModel alloc] init];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDef objectForKey:USERINFO];
    model = [CUserInfoModel modelWithJSON:dic];
    return model;
}

- (BOOL)isLogin{
    
    CUserInfoModel *model = [CUserDefault shareInstance].userInfoModel;
    if (model.realName.length > 0) {
        
        return YES;
    }
    return NO;

   
}

#pragma mark - set && get
//- (CUserInfoModel *)infoModel{
//    if (nil == _infoModel) {
//        CUserInfoModel *model = [[CUserInfoModel alloc] init];
//        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//        NSDictionary *dic = [userDef objectForKey:USERINFO];
//        model = [CUserInfoModel yy_modelWithJSON:dic];
//        _infoModel = model;
//    }
//    return _infoModel;
//}

@end
