//
//  LoginViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "SVProgressHUD.h"
@interface LoginViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code", kApp_KEY, kRedirectURI];
    
    //1.将用户引导到认证界面
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    
}
- (IBAction)cancle:(UIBarButtonItem *)sender {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //取出请求url地址
    NSURL *url = request.URL;
    NSString *urlStr = [url absoluteString];
    NSLog(@"%@",urlStr);
    
    //2.如果请求地址是以回调地址开头
    if ([urlStr hasPrefix:kRedirectURI]) {
        //取出code授权码
        NSArray *resault = [urlStr componentsSeparatedByString:@"code="];
        NSString *code = resault[1];
        
        //3.换取授权码
        NSString *urlToken = @"https://api.weibo.com/oauth2/access_token";
        NSDictionary *params = @{@"client_id":kApp_KEY,
                                 @"client_secret":@"ce744bf3881bda336001e8bcd52d021a",
                                 @"grant_type":@"authorization_code",
                                 @"code":code,
                                 @"redirect_uri":kRedirectURI};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager POST:urlToken parameters:params success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
            NSLog(@"%@",responseObj);
            
            //4.换取token成功后保存
            [[Account sharedAccount] saveLoginfo:responseObj];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            //发送登录成功的通知
            [[NSNotificationCenter defaultCenter]postNotificationName:KLogIn object:nil];
            //清理cookie
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in storage.cookies) {
                [storage deleteCookie:cookie];
            }
            
        } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
            if (error) {
                NSLog(@"%@",error);
                return;
            }
        }];
        return NO;
    }
    //显示等待指示符
    [SVProgressHUD show];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载完成后的取消指示符
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //加载错误后失败，取消等待
    [SVProgressHUD dismiss];
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
