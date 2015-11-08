//
//  Comments.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/5.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User,Status;
@interface Comments : NSObject

@property (nonatomic, strong)NSDate *created_at;	//string	评论创建时间
@property (nonatomic, strong)NSString *text;	//string	评论的内容
@property (nonatomic, strong)NSString *source;	//string	评论的来源
@property (nonatomic, strong)User *user;	//object	评论作者的用户信息字段 详细
@property (nonatomic, strong)NSString *idstr;	//string	字符串型的评论ID
@property (nonatomic, strong)Status *status;	//object	评论的微博信息字段 详细
@property (nonatomic, strong)Comments *reply_comment;	//object	评论来源评论，当本评论属于对另一评论的回复时返回此字段

- (instancetype)initCommentWithInfo:(NSDictionary *)commentInfo;

@end
