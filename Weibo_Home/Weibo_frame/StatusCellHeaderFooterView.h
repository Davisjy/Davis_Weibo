//
//  StatusCellHeaderFooterView.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/3.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface StatusCellHeaderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *retwitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

- (void)bangdingStatus:(Status *)status;
@end
