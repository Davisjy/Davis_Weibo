//
//  NSString+size.m
//  AutoLayoutLabelCell
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size
{
    CGSize resultSize;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return resultSize;
}

@end
