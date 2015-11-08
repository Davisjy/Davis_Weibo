//
//  MainViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "MainViewController.h"
#import "Common.h"
#import "Account.h"
#import "AFNetworking.h"

@interface MainViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSTimer *timer;//用于刷新未读消息数
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.translucent = NO;
    //设置tabBar的tintColor
    self.tabBar.tintColor = [UIColor orangeColor];
    
    //设置默认选择的控制器
    if (![[Account sharedAccount]isLogin]) {
        //为了触发首页的didload方法
        UINavigationController *navVC = self.viewControllers[0];
        [navVC.viewControllers[0] view];
        
        self.selectedIndex = 2;
    }
    
    //退出登录的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout) name:KLogOut object:nil];
    
    //监听登录成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login) name:KLogIn object:nil];
    
    //发微博页面取消通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancel:) name:KDismiss object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(refreshUnreadMessage:) userInfo:nil repeats:YES];
    
    [self installTabbar];
}

- (void)cancel:(NSNotification *)noti
{
    self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical ;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//在tabbar上添加加号按钮49
- (void)installTabbar
{
    CGFloat buttonW = 50;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //居中显示
    btn.frame = CGRectMake((KScreenW - buttonW)/2, 7, buttonW, 40);
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(middleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    //tabbar直接添加子视图
    [self.tabBar addSubview:btn];
}

- (void)middleBtnPress:(UIButton *)btn
{
    //显示more的页面
    UIViewController *moreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    moreVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:moreVC animated:YES completion:nil];
}

- (void)logout
{
    //收到退出登录的通知
    //1.弹出来登录界面
    UIViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self presentViewController:login animated:YES completion:nil];
    
    //2.切换控制器
    self.selectedIndex = 2;
    
    //3.清空保存的登录信息
    [[Account sharedAccount] logout];
}

- (void)login
{
    //选择首页控制器
    self.selectedIndex = 0;
    
}

- (void)refreshUnreadMessage:(NSTimer *)timer
{
     //请求的URl
    NSString *url = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    //请求参数
    NSMutableDictionary *tokenDic = [[Account sharedAccount]requestParameters];
    if (!tokenDic) {
        //如果为空则没有登录，不刷新
        return;
    }
    [tokenDic setObject:[[Account sharedAccount]currentUserUid] forKey:@"uid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:tokenDic success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
        //设置未读消息数
        //未读微博数量
        NSNumber *statusNum = responseObj[@"status"];
        if ([statusNum isEqualToNumber:@0]) {
            //设置不显示内容
            [[self.viewControllers[0] tabBarItem]setBadgeValue:nil];
        }else{
            //设置显示未读消息数
            [[self.viewControllers[0]tabBarItem]setBadgeValue:statusNum.stringValue];
        }
    } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //已经选择到第0个控制器，并且再次选择到第0个控制器
    if (self.selectedIndex == 0 && viewController == self.viewControllers[0]) {
        //首页刷新
        UINavigationController *nav = self.viewControllers[0];
        [nav.viewControllers[0] performSelector:@selector(refreshData) withObject:nil];
    }
    
    if (viewController == self.viewControllers[2]) {
        //中间的只是起一个占位的作用，不能触发选择
        return NO;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
