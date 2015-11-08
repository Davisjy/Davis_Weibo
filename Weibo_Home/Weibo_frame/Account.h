//
//  Account.h
//  Weibo_frame
//
//  Created by qingyun on 15/10/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

//单例方法
+ (instancetype)sharedAccount;

//返回用户的UID
- (NSString *)currentUserUid;

//保存登录信息
- (void)saveLoginfo:(NSDictionary *)info;

//判断是否登录
- (BOOL)isLogin;

//退出登录
- (void)logout;

//返回包含token的可变字典，用作请求的参数
- (NSMutableDictionary *)requestParameters;

@end
