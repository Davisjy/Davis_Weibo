//
//  TableViewCell.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/5.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "RetwitterTableViewCell.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "NSString+size.h"
#import "Common.h"

@implementation RetwitterTableViewCell

+ (CGFloat)cellHeight4Status:(Status *)status
{
    //正文的高度加上正文起始的位置高度
    CGFloat cellHeight = 59;
    
    //正文的高度
    CGFloat textHeight = [status.text sizeWithFont:[UIFont systemFontOfSize:17] size:CGSizeMake(KScreenW - 8 - 66, MAXFLOAT)].height;
    return cellHeight += textHeight + 8;
}

- (void)awakeFromNib {
    // Initialization code
}

//绑定模型的内容
- (void)setStatus:(Status *)status
{
    //用户基本信息
    [self.icon sd_setImageWithURL:[NSURL URLWithString:status.user.profileImageURL]];
    self.name.text = status.user.name;
    //格式化时间
    NSString *timeStr = [NSDateFormatter localizedStringFromDate:status.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.time.text = timeStr;
    //正文
    self.content.text = status.text;
    
}

@end
