//
//  UITableView+cellIndex.h
//  Weibo_frame
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (cellIndex)

//根据cell的indexPath转化为index
- (NSInteger)indexForIndexPath:(NSIndexPath *)indexPath;
//根据cell找到所对应的index
- (NSInteger)indexForCell:(UITableViewCell *)cell;

@end
