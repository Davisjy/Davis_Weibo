//
//  NSDateFormatter+Status.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "NSDateFormatter+Status.h"

@implementation NSDateFormatter (Status)

- (NSDate *)statusDateFromString:(NSString *)dateStr;
{
    //[self setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    //en_us   zh_CN  13949113823
    self.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_us"];
    //self.locale = [NSLocale currentLocale];
    self.dateFormat = @"EEE MMM dd HH:mm:ss zzz yyyy";
    return [self dateFromString:dateStr];
}

@end
