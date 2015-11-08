//
//  CommentsCell.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/5.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "CommentsCell.h"
#import "Common.h"
#import "Status.h"
#import "User.h"
#import "NSString+size.h"
#import "Comments.h"
#import "UIImageView+WebCache.h"

@implementation CommentsCell

+ (CGFloat)cellHeight4Comments:(Comments *)comments
{
    //正文的高度加上正文起始的位置高度
    CGFloat cellHeight = 59;
    
    //正文的高度
    CGFloat textHeight = [comments.text sizeWithFont:[UIFont systemFontOfSize:17] size:CGSizeMake(KScreenW - 8 - 66, MAXFLOAT)].height;
    return cellHeight += textHeight + 8;
}

- (void)awakeFromNib {
    // Initialization code
}

//绑定模型的内容
- (void)bangleComments:(Comments *)comments
{
    //用户基本信息
    [self.icon sd_setImageWithURL:[NSURL URLWithString:comments.user.profileImageURL]];
    self.name.text = comments.user.name;
    //格式化时间
    NSString *timeStr = [NSDateFormatter localizedStringFromDate:comments.created_at dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.time.text = timeStr;
    //正文
    self.comments.text = comments.text;
    
}

@end
