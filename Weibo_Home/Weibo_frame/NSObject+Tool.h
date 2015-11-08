//
//  NSObject+Tool.h
//  Weibo_frame
//
//  Created by qingyun on 15/10/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <Foundation/Foundation.h>
//得到document文件夹下文件的路径
@interface NSObject (Tool)
+ (NSString *)filePathForDocuments:(NSString *)fileName;
@end
