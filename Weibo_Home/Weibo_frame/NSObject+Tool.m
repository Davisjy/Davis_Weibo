//
//  NSObject+Tool.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "NSObject+Tool.h"

@implementation NSObject (Tool)

+ (NSString *)filePathForDocuments:(NSString *)fileName
{
    //归档的文件路径
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return filePath;
}


@end
