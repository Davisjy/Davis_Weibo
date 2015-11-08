//
//  StatusDetailHeaderView.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/4.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface StatusDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *retwitter;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIView *currentSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeft;

- (void)selectButton:(UIButton *)btn;

- (void)bangdingStatus:(Status *)status;

@end
