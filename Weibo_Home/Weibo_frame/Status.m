
//
//  Status.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "Status.h"
#import "User.h"
#import "Common.h"
#import "NSDateFormatter+Status.h"
@implementation Status

- (instancetype)initStatusWithDictionary:(NSDictionary *)statusInfo
{
    if (self = [super init]) {
        //初始化普通属性
        
        //取出时间字符串
        NSString *dataStr = statusInfo[kStatusCreateTime];
        
        //将字符串格式化为时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        self.createdAt = [formatter statusDateFromString:dataStr];
        
        self.idStr = statusInfo[kStatusIDStr];
        self.text = statusInfo[kStatusText];
        self.source = [self sourceWithString:statusInfo[kStatusSource]];
        self.favorited = [statusInfo[kstatusFavorited] boolValue];
        self.geo = statusInfo[kstatusGeo];
        
        
        //初始化user
        NSDictionary *user = statusInfo[kStatusUserInfo];
        self.user = [[User alloc]initUserWithDictionary:user];
        
        NSDictionary *restatus = statusInfo[kStatusRetweetStatus];
        if (restatus) {
            self.reStatus = [[Status alloc]initStatusWithDictionary:restatus];
        }
        
        self.repostsCount = [statusInfo[kStatusRepostsCount] integerValue];
        
        self.commentsCount = [statusInfo[kStatusCommentsCount] integerValue];
        self.attitudesCount = [statusInfo[kStatusAttitudesCount] integerValue];
        self.picUrls = statusInfo[kStatusPicUrls];
    }
    return self;
}

//重写timeago的get方法
- (NSString *)timeAgo
{
    //1.微博创建时间与当前时间差
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.createdAt];
    
    if (interval < 60) {
        //返回刚刚(秒级)
        return @"刚刚";
    }else if (interval < 60 * 60){
        //分钟的
        return [NSString stringWithFormat:@"%d 分钟前",(int)interval / 60];
    }else if (interval < 60 *60 * 24){
        //小时的
        return [NSString stringWithFormat:@"%d 小时前",(int)interval / (60 * 60)];
    }else if (interval < 60 *60 * 24 *30){
        //一个月之内
        return [NSString stringWithFormat:@"%d 天前", (int)interval / (60 *60 * 24)];
    }else{
        //直接返回时间
        return  [NSDateFormatter localizedStringFromDate:self.createdAt dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
}

- (NSString *)sourceWithString:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] || [string isEqualToString:@""] || string == nil) {
        return nil;
    }
    //1.正则表达式
    NSString *regExStr = @">.+<";
    
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regExStr options:0 error:&error];
    
    //2.查找符合条件的结果
    NSTextCheckingResult *result = [expression firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (result) {
        NSRange range = result.range;
        NSString *source = [string substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
        return [NSString stringWithFormat:@"来自%@",source];
    }
    return nil;
}

@end
