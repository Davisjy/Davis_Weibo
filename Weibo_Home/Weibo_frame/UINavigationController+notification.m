//
//  UINavigationController+notification.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/3.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "UINavigationController+notification.h"
#import "Common.h"
@implementation UINavigationController (notification)

- (void)showNotifitacion:(NSString *)info
{
    //初始化一个label用于显示刷新微博数
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, KScreenW, 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.textAlignment = NSTextAlignmentCenter;
    view.text = info;
    view.textColor = [UIColor whiteColor];
    //添加view到navigationBar下面
    [self.view insertSubview:view belowSubview:self.navigationBar];
    
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = CGRectOffset(view.frame, 0, 44);
    } completion:^(BOOL finished) {
        //停留时间
        [UIView animateWithDuration:0.5 delay:1.f options:0 animations:^{
            view.frame = CGRectOffset(view.frame, 0, -44);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }];
}

@end
