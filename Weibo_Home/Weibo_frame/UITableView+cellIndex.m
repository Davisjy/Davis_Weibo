//
//  UITableView+cellIndex.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "UITableView+cellIndex.h"

@implementation UITableView (cellIndex)

- (NSInteger)indexForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    //将section的row的和加起来(当前cell之前的section)
    for (int i = 0; i < indexPath.section; i ++ ) {
        index += [self numberOfRowsInSection:i];
    }
    
    //index加上当前所处的位置row
    index += indexPath.row;
    return index;
}

- (NSInteger)indexForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    return  [self indexForIndexPath:indexPath];
}
@end
