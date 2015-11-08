//
//  User.h
//  Weibo_frame
//
//  Created by qingyun on 15/10/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//idstr	string	字符串型的用户UID
@property (nonatomic, strong) NSString *idStr;

//name	string	友好显示名称
@property (nonatomic, strong) NSString *name;

//location	string	用户所在地
@property (nonatomic, strong) NSString *location;

//description	string	用户个人描述
@property (nonatomic, strong) NSString *userDescription;

//profile_image_url	string	用户头像地址（中图），50×50像素
@property (nonatomic, strong) NSString *profileImageURL;

//followers_count	int	粉丝数
@property (nonatomic) NSInteger followers;

//friends_count	int	关注数
@property (nonatomic) NSInteger friendsCount;

//statuses_count	int	微博数
@property (nonatomic) NSInteger StatusesCount;

//favourites_count	int	收藏数
@property (nonatomic) NSInteger favouritesCount;

//verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
@property (nonatomic) BOOL verified;

//remark	string	用户备注信息，只有在查询用户关系时才返回此字段
@property (nonatomic, strong) NSString *remark;

//avatar_hd	string	用户头像地址（高清），高清头像原图
@property (nonatomic, strong) NSString *avatarHD;

- (instancetype)initUserWithDictionary:(NSDictionary *)userInfo;

@end
