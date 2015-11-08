//
//  TableViewCell.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/5.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface RetwitterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;

- (void)setStatus:(Status *)status;

//计算cell显示的高度
+ (CGFloat)cellHeight4Status:(Status *)status;
@end
