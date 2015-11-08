//
//  User.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "User.h"
#import "Common.h"
@implementation User

- (instancetype)initUserWithDictionary:(NSDictionary *)userInfo
{
    if (self = [super init]) {
        //初始化属性
        self.idStr = userInfo[kUserID];
        self.name = userInfo[kUserInfoName];
        self.userDescription = userInfo[kUserDescription];
        self.profileImageURL = userInfo[kUserProfileImageURL];
        self.followers = [userInfo[kUserFollowersCount] integerValue];
        self.friendsCount = [userInfo[kUserFriendCount] integerValue];
        self.StatusesCount = [userInfo[kUserStatusCount] integerValue];
        self.avatarHD = userInfo[kUserAvatarHd];
    }
    return self;
}

@end
