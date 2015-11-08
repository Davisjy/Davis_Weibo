//
//  AppDelegate.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1.window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //2.根据不同情况指定根视图控制器
    self.window.rootViewController = [self instantiateRooterViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (id)instantiateRooterViewController
{
    //当前运行的版本
    NSString *currentVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    //本地保存的版本号
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [userDefault objectForKey:KAPP_Version];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([currentVersion isEqualToString:localVersion]) {
        //已经运行过该版本
        //初始化主控制器
        
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"main"];
        return vc;
    }else{
        //第一次运行该版本
        //初始化引导页控制器
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"guide"];
        
//        [userDefault setObject:currentVersion forKey:KAPP_Version];
//        [userDefault synchronize];
        
        return vc;
        //更新本地存储的版本
        
    }
}

- (void)guiEnd
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *currentVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    [userDefault setObject:currentVersion forKey:KAPP_Version];
    [userDefault synchronize];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //出对根视图
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"main"];
    
    //指定window的根视图
    self.window.rootViewController = vc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
