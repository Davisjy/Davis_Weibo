//
//  PersonViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //正在滚动
    //scrollview y轴上的偏移
    CGFloat contentOffset = scrollView.contentOffset.y;
    if (contentOffset < 0) {
        //bgimage要增加的高度
        CGFloat imageAddHeight = -contentOffset;
        self.imageView.frame = CGRectMake(0, -imageAddHeight, self.imageView.frame.size.width, imageAddHeight + self.imageView.superview.frame.size.height);
    }
}

@end
