//
//  NSString+size.h
//  AutoLayoutLabelCell
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (size)

//根据文字显示的区域以及大小计算最终显示所需要的空间
- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;

@end
