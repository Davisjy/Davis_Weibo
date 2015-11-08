//
//  SendStatusViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/6.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "SendStatusViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"

#define KLineCount 3
#define KImageHeight 90
#define KImageMargin 5
#define KImageWidth  90

@interface SendStatusViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (nonatomic, strong) NSMutableArray *sendImages;
@property (weak, nonatomic) IBOutlet UIImageView *reportsIcon;
@property (weak, nonatomic) IBOutlet UILabel *reportsName;
@property (weak, nonatomic) IBOutlet UILabel *reportsText;
@end

@implementation SendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消view的延伸效果
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //添加占位符
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor grayColor];
    label.text = @"分享新鲜事...";
    self.label = label;
    [self.textView addSubview:label];
    self.textView.delegate = self;
    
    //如果之前保存有草稿
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *status = [defaults objectForKey:@"status"];
    if (status) {
        self.textView.text = status;
        //清空内容
        [defaults setObject:nil forKey:@"status"];
    }
    
    if (self.type == KReportsStatus) {
        //如果是转发微博
        UIView *view = [[NSBundle mainBundle]loadNibNamed:@"ReportsView" owner:self options:0][0];
        self.tableView.tableFooterView = view;
        //绑定内容
        [self.reportsIcon sd_setImageWithURL:[NSURL URLWithString:self.reportsStatus.user.profileImageURL]];
        self.reportsName.text = self.reportsStatus.user.name;
        self.reportsText.text = self.reportsStatus.text;
    }else if (self.type == KWriteStatus){
        //默认空内容不能发送
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.type == KWriteStatus) {
        [self layoutImage:self.sendImages forView:self.imageSuperView];
    }
}

- (void)layoutImage:(NSArray *)images forView:(UIView *)view
{
    //1.移除所有的子视图
    NSArray *subViews = view.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //2.调整imageSuperView到合适的高度
    CGFloat imageSuperViewHeight = [SendStatusViewController imageSuperViewHeightForImages:images];
    CGRect frame = view.frame;
    frame.size.height = imageSuperViewHeight;
    view.frame = frame;
    
    //添加新的imageView
    for (int i = 0; i < images.count ; i ++) {
        CGFloat imageX = i % KLineCount * (KImageWidth + KImageMargin);
        CGFloat imageY = i / KLineCount * (KImageHeight + KImageMargin);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, KImageWidth, KImageHeight)];
        imageView.image = images[i];
        [view addSubview:imageView];
    }
    //添加最后的加号按钮
    NSUInteger i = images.count;
    CGFloat imageX = i % KLineCount * (KImageWidth + KImageMargin);
    CGFloat imageY = i / KLineCount * (KImageHeight + KImageMargin);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(imageX, imageY, KImageWidth, KImageHeight)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    
}

- (void)addImage{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //指定为图片的选择器
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    imagePicker.delegate = self;
    //显示
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//计算图片显示需要的高度
+ (CGFloat)imageSuperViewHeightForImages:(NSArray *)images
{
    //加上加号按钮
    NSInteger count = images.count + 1;
    
    //计算出图片的行数
    NSInteger line = (count - 1) / KLineCount + 1;
    
    //图片显示需要的高度
    NSInteger imageHeight = line * KImageHeight + (line - 1)* KImageMargin;
    
    
    return imageHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //如果用户输入有内容，则保存到userDefults
    if (self.textView.text != nil || ![self.textView.text isEqualToString:@""]) {
        NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
        [userDe setObject:self.textView.text forKey:@"status"];
        [userDe synchronize];
    }
    //通过通知，通知根视图控制器取消模态视图，可以两个模态视图一块消失
    [[NSNotificationCenter defaultCenter]postNotificationName:KDismiss object:nil];
    
    
}

- (void)sendReportsStatus
{
    //转发微博
    NSString *urlStr = [KBaseUrl stringByAppendingPathComponent:@"repost.json"];
    NSMutableDictionary *tokenDic = [[Account sharedAccount]requestParameters];
    
    [tokenDic setObject:self.reportsStatus.idStr forKey:@"id"];
    //转发微博允许内容为空
    if (self.textView.text && ![self.textView.text isEqualToString:@""]) {
        [tokenDic setObject:self.textView.text forKey:@"status"];

    }
    //发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:tokenDic success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
        NSLog(@"%@",responseObj);
        
        //通过通知，通知根视图控制器取消模态视图，可以两个模态视图一块消失
        [[NSNotificationCenter defaultCenter]postNotificationName:KDismiss object:nil];
    } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];

}

- (void)sendStatus
{
    //发送带图片的微博
    if (self.sendImages.count != 0) {
        NSString *urlStr = [KBaseUrl stringByAppendingPathComponent:@"upload.json"];
        NSMutableDictionary *dic = [[Account sharedAccount]requestParameters];
        [dic setObject:self.textView.text forKey:@"status"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlStr parameters:dic constructingBodyWithBlock:^ void(id<AFMultipartFormData> formData) {
            //将第零张转化为二进制数据
            NSData *imageData = UIImagePNGRepresentation(self.sendImages[0]);
            
            [formData appendPartWithFileData:imageData name:@"pic" fileName:@"statusImage" mimeType:@"image/jpeg"];
        } success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
            NSLog(@"%@",responseObj);
            [[NSNotificationCenter defaultCenter]postNotificationName:KDismiss object:nil];
        } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@",error);
        }];
        
    }else{
        //发送文字微博
        NSString *urlStr = [KBaseUrl stringByAppendingPathComponent:@"update.json"];
        NSMutableDictionary *tokenDic = [[Account sharedAccount]requestParameters];
        [tokenDic setObject:self.textView.text forKey:@"status"];
        //发送请求
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlStr parameters:tokenDic success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
            NSLog(@"%@",responseObj);
            
            //通过通知，通知根视图控制器取消模态视图，可以两个模态视图一块消失
            [[NSNotificationCenter defaultCenter]postNotificationName:KDismiss object:nil];
        } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
            
        }];
    }

}

- (IBAction)sender:(UIBarButtonItem *)sender {
    
    if (self.type == KReportsStatus) {
        //转发微博
        [self sendReportsStatus];
    }else{
        [self sendStatus];//发送普通微博
    }
    
}

#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        //不能发送微博
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.label.hidden = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.label.hidden = YES;
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!self.sendImages) {
        self.sendImages = [NSMutableArray array];
    }
    //更改数据源
    [self.sendImages addObject:image];
    //更新UI
    [self layoutImage:self.sendImages forView:self.imageSuperView];
    //重新设置，更新tableView
    [self.tableView setTableFooterView:self.imageSuperView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
