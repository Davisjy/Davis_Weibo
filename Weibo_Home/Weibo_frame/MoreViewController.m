//
//  MoreViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/6.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "MoreViewController.h"
#import "Common.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //按钮的弹出动画
    for (int i = 0; i < self.actionButton.count; i ++) {
        //按钮的动画开始时间一次递增
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //将按钮移动到开始位置
            UIButton *btn = self.actionButton[i];
            CGRect originFrame = btn.frame;
            
            btn.frame = CGRectOffset(btn.frame, 0, self.view.frame.size.height - btn.frame.origin.y);
            btn.hidden = NO;
            [UIView animateWithDuration:.3f animations:^{
                btn.frame = CGRectOffset(originFrame, 0, -15);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1f animations:^{
                    btn.frame = originFrame;
                }];
            }];
            
            
        });
    }
}

- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
