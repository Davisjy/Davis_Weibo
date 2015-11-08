//
//  Account.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "Account.h"
#import "Common.h"
#import "NSObject+Tool.h"

#define KAccountFileName   @"account"

@interface Account ()<NSCoding>
@property (nonatomic, strong) NSString *accessToken;//访问令牌
@property (nonatomic, strong) NSDate *expires;//有效时间
@property (nonatomic, strong) NSString *uid;//用户的id
@end

@implementation Account

static Account *account;
+ (instancetype)sharedAccount
{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        NSString *filePath = [NSObject filePathForDocuments:KAccountFileName];
        //解档对象
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        //如果解档文件不存在，对象为空
        if (!account) {
            account = [[Account alloc]init];
        }
    });
    return account;
}

- (NSString *)currentUserUid
{
    return self.uid;
}

- (void)saveLoginfo:(NSDictionary *)info
{
    self.accessToken = info[KAccessToken];
    
    //有效时间
    self.expires = [[NSDate date]dateByAddingTimeInterval:[info[KExpiresIn]doubleValue]];
    self.uid = info[KUID];
    
    //保存到屋物理文件中
    [NSKeyedArchiver archiveRootObject:account toFile:[NSObject filePathForDocuments:KAccountFileName]];
}

- (BOOL)isLogin
{
    //比较时间，有效的截止时间跟当前时间对比
    NSComparisonResult result = [self.expires compare:[NSDate date]];
    //存在token并且在有效时间内
    if (self.accessToken && result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (void)logout
{
    //删除内存中的登录信息
    self.accessToken = nil;
    self.expires = nil;
    self.uid = nil;
    
    //删除归档信息
    NSString *filePath = [NSObject filePathForDocuments:KAccountFileName];
    
    //删除文件
    [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
}

#pragma mark - coding 
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.accessToken = [aDecoder decodeObjectForKey:KAccessToken];
        self.expires = [aDecoder decodeObjectForKey:KExpiresIn];
        self.uid = [aDecoder decodeObjectForKey:KUID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accessToken forKey:KAccessToken];
    [aCoder encodeObject:self.expires forKey:KExpiresIn];
    [aCoder encodeObject:self.uid forKey:KUID];
}

//返回一个包含token的可变字典
- (NSMutableDictionary *)requestParameters
{
    if ([self isLogin]) {
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        [parame setObject:self.accessToken forKey:KAccessToken];
        return parame;
    }
    return nil;
}
@end
