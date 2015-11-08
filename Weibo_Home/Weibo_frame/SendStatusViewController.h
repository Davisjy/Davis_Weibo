//
//  SendStatusViewController.h
//  Weibo_frame
//
//  Created by qingyun on 15/11/6.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KWriteStatus,
    KReportsStatus,
    KComments,
} KSendStatusType;
@class Status;
@interface SendStatusViewController : UITableViewController
@property (nonatomic) KSendStatusType type;

@property (nonatomic, strong) Status *reportsStatus;
@end
