//
//  StatusDetailController.m
//  Weibo_frame
//
//  Created by qingyun on 15/11/4.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "StatusDetailController.h"
#import "Status.h"
#import "StatusTableViewCell.h"
#import "StatusDetailHeaderView.h"
#import "Common.h"
#import "Account.h"
#import "AFNetworking.h"
#import "RetwitterTableViewCell.h"
#import "Comments.h"
#import "CommentsCell.h"

typedef enum : NSUInteger {
    KRetwitter,
    KComments,
    KLike,
} KDetailType;

@interface StatusDetailController ()

@property (nonatomic, strong) NSArray *retwitter;//转发微博的列表

@property (nonatomic, strong) NSArray *comments;//评论的数据源

@property (nonatomic, strong) StatusDetailHeaderView *headerView;

@property (nonatomic)KDetailType selectType;//当前选择的类型
@end

@implementation StatusDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"微博正文";
    //设置默认选择是转发
    self.selectType = KRetwitter;
    //更改响应的UI
    [self.headerView selectButton:self.headerView.retwitter];
}

- (StatusDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"StatusDetailHeaderView" owner:nil options:0][0];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retwitter:(id)sender
{
    [self.headerView selectButton:sender];
    
    //请求转发微博的数据
    //1.url地址
    NSString *urlStr = [KBaseUrl stringByAppendingPathComponent:@"repost_timeline.json"];
    //2.参数
    NSMutableDictionary *tokenDic = [[Account sharedAccount]requestParameters];
    [tokenDic setObject:self.status.idStr forKey:@"id"];
    
    //3.通过http向服务器发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:tokenDic success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
        //返回结果
        NSLog(@"%@",responseObj);
        
        NSArray *statusInfo = responseObj[@"reposts"];
        NSMutableArray *resultArr = [NSMutableArray array];
        for (NSDictionary *dict in statusInfo) {
            //转化为模型
            Status *status = [[Status alloc]initStatusWithDictionary:dict];
            [resultArr addObject:status];
        }
        //作为数据源
        self.retwitter = resultArr;
        
        //更改选择的类型
        self.selectType = KRetwitter;
        
        //更新UI
        [self.tableView reloadData];
        
    } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)comment:(id)sender
{
    [self.headerView selectButton:sender];
    //请求微博的评论数据
    NSString *url = [kBaseCommentURL stringByAppendingPathComponent:@"show.json"];
    //请求的参数
    NSMutableDictionary *tokenDic = [[Account sharedAccount]requestParameters];
    [tokenDic setObject:self.status.idStr forKey:@"id"];
    
    //http请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:tokenDic success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
        NSLog(@"%@",responseObj);
        NSArray *commentsInfo = responseObj[@"comments"];
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dict in commentsInfo) {
            Comments *comment = [[Comments alloc]initCommentWithInfo:dict];
            [result addObject:comment];
        }
        self.comments = result;
        
        //设置选择的类型
        self.selectType = KComments;
        
        //更新UI
        [self.tableView reloadData];
    } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@",error);
    }];
}

- (void)like:(id)sender
{
    [self.headerView selectButton:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //是正文的时候
    if (section == 0) {
        return 1;
    }else{
        switch (self.selectType) {
            case KRetwitter:
            {
                return self.retwitter.count;
            }
                break;
            case KComments:
            {
                return self.comments.count;
            }
                break;
            case KLike:
            {
                return 0;
            }
                break;
            default:
                break;
        }
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //显示正文
        StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
        [cell setStatus:self.status];
        
        return cell;
    }else{//显示转发
        if (self.selectType == KRetwitter) {
            RetwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"retwitter" forIndexPath:indexPath];
            [cell setStatus:self.retwitter[indexPath.row]];
            
            return cell;
        }else if (self.selectType == KComments){
            //此时选择是评论的时候
            CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comments" forIndexPath:indexPath];
            [cell bangleComments:self.comments[indexPath.row]];
            return cell;
        }else{
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //计算cell的高度
        return [StatusTableViewCell cellHeightWithStatus:self.status];
    }else{
        
        if (self.selectType == KRetwitter) {
            //转发时的高度
            return [RetwitterTableViewCell cellHeight4Status:self.retwitter[indexPath.row]];
        }else if (self.selectType == KComments){
            //评论时的高度
            return [CommentsCell cellHeight4Comments:self.comments[indexPath.row]];
        }else{
            return 0;
        }
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
   
        [self.headerView bangdingStatus:self.status];
        
        //按钮添加事件
        [self.headerView.retwitter addTarget:self action:@selector(retwitter:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView.comment addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView.like addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
            
        return self.headerView;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return .1f;
    }else{
        return 30.f;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
