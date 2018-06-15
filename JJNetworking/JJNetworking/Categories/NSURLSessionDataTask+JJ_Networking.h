//
//  NSURLSessionDataTask+JJ_Networking.h
//  WowTemplate
//
//  Created by luming on 2018/5/16.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionDataTask (JJ_Networking)


/**
 重新保存accesstoken

 @param task 任务
 @return 返回token
 */
+(NSString *)resaveAccesstokenWithTask:(NSURLSessionDataTask *)task;
@end
