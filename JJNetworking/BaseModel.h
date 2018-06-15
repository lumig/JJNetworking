//
//  BaseModel.h
//  CreditCat
//
//  Created by luming on 2017/3/17.
//  Copyright © 2017年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic,  copy) NSString *status;    // 状态  00 成功
@property (nonatomic,  copy) NSString *message;   // 说明

@end
