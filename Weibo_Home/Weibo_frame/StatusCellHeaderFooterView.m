//
//  StatusCellHeaderFooterView.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/3.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "StatusCellHeaderFooterView.h"
#import "Status.h"

@implementation StatusCellHeaderFooterView

- (void)awakeFromNib {
    // Initialization codef
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)bangdingStatus:(Status *)status
{
    [self.retwitterBtn setTitle:[NSString stringWithFormat:@"%ld",status.repostsCount] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",status.commentsCount] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",status.attitudesCount] forState:UIControlStateNormal];
    
}

@end
