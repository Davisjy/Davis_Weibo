//
//  DataBaseEngine.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/1.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject

/**
 *  存储微博数据到数据库
 */
+ (void)saveStatuses2Database:(NSArray *)statuses;

/**
 *  从数据库中查询数据
 */
+ (NSArray *)statusesFromDB;



@end
