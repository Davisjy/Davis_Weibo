//
//  StatusDetailHeaderView.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/4.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "StatusDetailHeaderView.h"
#import "Status.h"

@implementation StatusDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)selectButton:(UIButton *)btn
{
    //重置UI的布局
    //设置选择按钮
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];

    [self setButton:btn selected:YES];
    //复原之前选择的按钮
    if (self.retwitter != btn) {
        [self setButton:self.retwitter selected:NO];
    }
    if (self.comment != btn) {
        [self setButton:self.comment selected:NO];
    }
    if (self.like != btn) {
        [self setButton:self.like selected:NO];
    }
    //将小底层颜色移动到按钮下面
    self.currentSelect.center = CGPointMake(btn.center.x, self.currentSelect.center.y);
    self.viewLeft.constant = btn.center.x - self.currentSelect.frame.size.width/2;
}

- (void)setButton:(UIButton *)btn selected:(BOOL)select
{
    if (select) {
        //选择状态
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    }else{
        //未选择
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];

    }
}

- (void)bangdingStatus:(Status *)status
{
    [self.retwitter setTitle:[NSString stringWithFormat:@"%ld",(long)status.repostsCount]forState:UIControlStateNormal];
    [self.comment setTitle:[NSString stringWithFormat:@"%ld",status.commentsCount] forState:UIControlStateNormal];
    [self.like setTitle:[NSString stringWithFormat:@"%ld",status.attitudesCount] forState:UIControlStateNormal];
}

@end
