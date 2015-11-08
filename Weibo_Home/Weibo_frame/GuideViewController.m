//
//  GuideViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
@interface GuideViewController ()<UIScrollViewDelegate>

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
}
#if 0
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //指定scrollview的congtentsize由内容决定
    self.scrollView.contentSize = self.contentView.frame.size;
}
#endif

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //约束只有在viewDidAppear之后起作用，调整contentview的大小，，根据其大小调整scrollview的contentSize
    self.scrollView.contentSize = self.contentView.frame.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)guideEnd:(UIButton *)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate guiEnd];
}
#pragma mark - scrollview  delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算出第几页
    self.pageControl.currentPage = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
