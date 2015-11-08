//
//  QRCodeViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/4.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Common.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

//设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入端
@property (nonatomic, strong) AVCaptureInput *input;
//输出端
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
//会话桥梁
@property (nonatomic, strong) AVCaptureSession *session;
//显示预览界面layer
@property (weak, nonatomic) IBOutlet UIView *preView;

@property (nonatomic, strong) UIImageView *animationView;

@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置UI效果
    //1.添加扫描的边框
    UIImage *image = [UIImage imageNamed:@"qrcode_border"];
    UIImage *boundImg = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 26, 26)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:boundImg];
    
    CGFloat width = KScreenW- 70 * 2;
    [imageView setFrame:CGRectMake(70, 170, width, width)];
    [self.view addSubview:imageView];
    
    //添加动画图片
    UIImageView *imageAnimate = [[UIImageView alloc]initWithFrame:CGRectMake(0, -width, width, width)];
    [imageAnimate setImage:[UIImage imageNamed:@"qrcode_scanline_qrcode"]];
    //添加到方框视图上
    [imageView addSubview:imageAnimate];
    //剪切到超出父视图区域，即超出父视图不显示
    imageView.clipsToBounds = YES;
    self.animationView = imageAnimate;
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)changeImage:(NSTimer *)timer
{
    //产生动画
    self.animationView.frame = CGRectOffset(self.animationView.frame, 0, 2);
    if (self.animationView.frame.origin.y >= self.animationView.superview.frame.size.height) {
        self.animationView.frame = CGRectMake(0, -CGRectGetHeight(self.animationView.superview.frame), self.animationView.frame.size.width, self.animationView.frame.size.height);
    }
}

- (void)cancel
{
    [self stopReading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //开始二维码扫描
    [self reading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止二维码扫描
    [self stopReading];
}

- (void)reading
{
    //1.构造device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.构造input
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    //3.构造output,源数据
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    //4.session
    self.session = [[AVCaptureSession alloc]init];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //5.配置output
    //5.1设置代理,支持输出的类型
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    [self.output setMetadataObjectTypes:self.output.availableMetadataObjectTypes];//可用的源数据的类型
    
    //6.添加预览功能
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer setFrame:self.view.bounds];
    [self.preView.layer addSublayer:layer];
    
    //生成一个图片，周围半透明，中间不透明作为layer的mask层第二个参数no代表有alpha通道值
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]);//根据屏幕来确定是几倍分辨率图片
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底层半透明
    CGContextSetRGBFillColor(context, 0, 0, 0, .9f);
    CGContextAddRect(context, self.view.bounds);
    CGContextFillPath(context);
    
    //绘制中间不透明区域
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.f);
    //中间方框区域
    CGContextAddRect(context, self.animationView.superview.frame);
    CGContextFillPath(context);
    
    //得到生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //停止生成图片，释放资源
    UIGraphicsEndImageContext();
    
    CALayer *maskLayer = [[CALayer alloc]init];
    maskLayer.bounds = self.preView.bounds;
    maskLayer.position = self.preView.center;
    maskLayer.contents = (__bridge id)(image.CGImage);
    layer.mask = maskLayer;
    layer.masksToBounds = YES;
    
    //7.启动服务
    [self.session startRunning];
    
    [self.animationTimer fire];
}

- (void)stopReading
{
    [self.session stopRunning];
    //停止timer
    [self.animationTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //1.接收元数据
    if (metadataObjects.count != 0) {
        AVMetadataMachineReadableCodeObject *codeObj = metadataObjects[0];
        if ([codeObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSLog(@"%@",[codeObj stringValue]);
            
            //在主线程中刷新UI
            [self performSelectorOnMainThread:@selector(cancel) withObject:nil waitUntilDone:YES];
        }
    }
}

@end
