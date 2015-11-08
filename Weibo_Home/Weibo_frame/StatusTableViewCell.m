//
//  StatusTableViewCell.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "User.h"
#import "NSString+size.h"
#import "Common.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"

#define KLineCount 3
#define KImageHeight 90
#define KImageMargin 5
#define KImageWidth  90

@interface StatusTableViewCell ()<SDPhotoBrowserDelegate>

@end

@implementation StatusTableViewCell

- (void)awakeFromNib {
    
    
}

+ (CGFloat)cellHeightWithStatus:(Status *)status
{
    //初始高度
    CGFloat height = 69;
    
    //微博正文的高度
    CGFloat textHeight = [status.text sizeWithFont:[UIFont systemFontOfSize:17] size:CGSizeMake(KScreenW - 16, MAXFLOAT)].height;
    height += textHeight;
    //返回总高度
    
    //计算出微博正文图片的高度
    CGFloat imageHeight = [StatusTableViewCell imageSuperViewHeightForPicURLs:status.picUrls];
    height += imageHeight;
    
    //计算转发微博需要的高度
    Status *reStatus = status.reStatus;
    if (reStatus) {
        //转发微博正文的高度
        CGFloat reTextHeight = [reStatus.text sizeWithFont:[UIFont systemFontOfSize:17] size:CGSizeMake(KScreenW - 16, MAXFLOAT)].height;
        
        height += reTextHeight;
        
        //计算转发图片的高度
        CGFloat reStatusImageHeight = [StatusTableViewCell imageSuperViewHeightForPicURLs:reStatus.picUrls];
        height += reStatusImageHeight;
    }
    
    //底部留八个像素和一个分割线的像素
    return height += 9;
}

//计算图片显示需要的高度
+ (CGFloat)imageSuperViewHeightForPicURLs:(NSArray *)picUrls
{
    if (picUrls.count == 0) {
        return 0;
    }
    
    //计算出图片的行数
    NSInteger line = (picUrls.count - 1) / KLineCount + 1;
    
    //图片显示需要的高度
    NSInteger imageHeight = line * KImageHeight + (line - 1)* KImageMargin;
    
    
    return imageHeight;
}

- (void)setStatus:(Status *)status
{
    //保留数据
//    self.status = status;
    //绑定用户头像
    NSString *urlStr = status.user.profileImageURL;
    //转化为data
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//    //iamge
//    UIImage *image = [UIImage imageWithData:imageData];
//    self.personIcon.image = image;
    [self.personIcon sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    //用户的昵称
    self.name.text = status.user.name;
    
    //微博的创建时间
    self.time.text = status.timeAgo;
    
    //微博的来源
    self.source.text = status.source;
    
    //微博的正文
    self.content.text = status.text;
    
    //布局微博的图片
    [self layoutImage:status.picUrls forView:self.imageSuperView constraint:self.imageSuperViewHeight];
    
    //绑定转发微博
    Status *reStatus = [status reStatus];
    self.reStatusContent.text = reStatus.text;
    
    [self layoutImage:reStatus.picUrls forView:self.reStatusImageSuper constraint:self.reStatusHeight];
}

- (void)layoutImage:(NSArray *)images forView:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    //1.移除之前所有子视图
    NSArray *subViews = view.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //2.更改父视图到需要的高度
    CGFloat viewHeight = [StatusTableViewCell imageSuperViewHeightForPicURLs:images];
    constraint.constant = viewHeight;
    
    for (int i = 0; i < images.count ; i ++) {
        //3.添加图片
        CGFloat imageX = i % KLineCount * (KImageWidth + KImageMargin);
        CGFloat imageY = i / KLineCount * (KImageMargin + KImageHeight);
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(imageX, imageY, KImageWidth, KImageHeight)];
        
        //取出图片的url
        NSString *urlStr = [[images objectAtIndex:i] objectForKey:kStatusThumbnailPic];
        
        //设置图片的url地址
        [button sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
        //button通过tag值进行区分
        button.tag = i;
        [button addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
    }
    
}

- (void)showImage:(UIButton *)button
{
    NSLog(@"%ld",(long)button.tag);
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    browser.sourceImagesContainerView = button.superview;
    //父视图
    browser.imageCount = button.superview.subviews.count;
    //子视图个数
    browser.currentImageIndex = (int)button.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //绑定内容的时候已经将不用的子视图全部清除,就是布局正文，因为之前已经清空之前的视图
    if (self.imageSuperView.subviews.count != 0) {
        UIButton *btn = (UIButton *)[self.imageSuperView.subviews objectAtIndex:index];
        return btn.currentImage;
    }else{
        UIButton *btn = (UIButton *)[self.reStatusImageSuper.subviews objectAtIndex:index];
        return btn.currentImage;
    }
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSArray *picUrls;
    //如果没有转发的就布局本身正文的图片
    if (!self.status.repostsCount) {
        picUrls = self.status.picUrls;
    }else{//有转发的就显示转发的图片
        picUrls = self.status.reStatus.picUrls;
    }
    NSString *urlStr = picUrls[index] [kStatusThumbnailPic];
    //换成大图url
    NSString *string = [urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    NSURL *url = [NSURL URLWithString:string];
    return url;
}


@end
