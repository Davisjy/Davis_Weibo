//
//  Comments.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/5.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "Comments.h"
#import "User.h"
#import "Status.h"
#import "NSDateFormatter+Status.h"
#import "Common.h"

@implementation Comments

- (instancetype)initCommentWithInfo:(NSDictionary *)commentInfo
{
    if (self = [super init]) {
        //解析时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        self.created_at = [formatter statusDateFromString: commentInfo[kStatusCreateTime]];
        self.text = commentInfo[kStatusText];
        self.source = commentInfo[kStatusSource];
        
        //解析usemodel
        NSDictionary *user = commentInfo[kStatusUserInfo];
        self.user = [[User alloc]initUserWithDictionary:user];
        self.idstr = commentInfo[kStatusID];
        
        //解析StatusModel
        NSDictionary *statusInfo = commentInfo[@"status"];
        self.status = [[Status alloc]initStatusWithDictionary:statusInfo];
        
        //解析reply_comment
        NSDictionary *reply = commentInfo[@"reply_comment"];
        if (reply) {
            self.reply_comment = [[Comments alloc]initCommentWithInfo:reply];
        }
    }
    return self;
}

@end
