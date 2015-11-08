//
//  CommentsCell.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/5.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comments;
@interface CommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comments;

//绑定数据源方法
- (void)bangleComments:(Comments *)comments;

//计算cell高度
+ (CGFloat)cellHeight4Comments:(Comments *)comments;

@end
