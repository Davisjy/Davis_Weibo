//
//  HomeViewController.m
//  Weibo_frame
//
//  Created by qingyun on 15/10/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司 &蒋洋. All rights reserved.
//

#import "HomeViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "StatusTableViewCell.h"
#import "Status.h"
#import "DataBaseEngine.h"
#import "UINavigationController+notification.h"
#import "StatusCellHeaderFooterView.h"
#import "SendStatusViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray *statues;
@property (nonatomic) BOOL refreshing;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //注册footerView
    [self.tableView registerNib:[UINib nibWithNibName:@"StatusCellHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"footer"];
    
    //添加登录成功的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login) name:KLogIn object:nil];
    
    if ([[Account sharedAccount]isLogin]) {
        self.statues = [NSMutableArray arrayWithArray:[DataBaseEngine statusesFromDB]];
        
        [self loadData];
        
        //1.初始化
        UIRefreshControl *control = [[UIRefreshControl alloc]init];
        //2.指定给tableViewController
        self.refreshControl = control;
        //3.添加target事件
        [control addTarget:self action:@selector(loadNew:) forControlEvents:UIControlEventValueChanged];
        
        //设置属性字符串标题
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"下拉刷新" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor orangeColor]}];
        control.attributedTitle = title;
    }
}

- (void)login
{
    //请求数据
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[Account sharedAccount]isLogin]) {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"popover_icon_qrcode"] style:UIBarButtonItemStylePlain target:self action:@selector(qrcode:)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)reloadStatusWith:(NSString *)sinceId maxId:(NSString *)maxId
{
    //如果正在刷新，不再进行请求数据
    if (_refreshing == YES) {
        return;
    }
    //1.请求数据
    NSString *urlStr = [KBaseUrl stringByAppendingPathComponent:@"home_timeline.json"];
    //2.构造请求的参数
    NSMutableDictionary *parameters = [[Account sharedAccount]requestParameters];
    //3.设置请求的id标准
    [parameters setObject:sinceId forKey:@"since_id"];
    [parameters setObject:maxId forKey:@"max_id"];
    
    
    //http请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //开始请求
    _refreshing = YES;
    [manager GET:urlStr parameters:parameters success:^ void(AFHTTPRequestOperation * operation, id responseObj) {
        
        //请求到的字典数组
        NSArray *statusInfo = [NSMutableArray arrayWithArray:responseObj[@"statuses"]];
        //第一次请求
        if ([sinceId isEqualToString:@"0"] && [maxId isEqualToString:@"0"] ) {
            
            self.statues = [NSMutableArray array];
            //遍历数据
            for (NSDictionary *info in statusInfo) {
                Status *status = [[Status alloc] initStatusWithDictionary:info];
                [self.statues addObject:status];
            }
        
            
            
        }else if (![sinceId isEqualToString:@"0"]){
            //下拉请求更新
            
            NSMutableArray *result = [NSMutableArray array];
            [statusInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Status *status = [[Status alloc]initStatusWithDictionary:obj];
                [result addObject:status];
            }];
            //添加上原有的数据
            [result addObjectsFromArray:self.statues];
            
            //result作为新的数据源
            self.statues = result;
            
            //更新UI
            [self.tableView reloadData];
            
            [self.refreshControl endRefreshing];
            
            [self setRefreshControlTitle:@"下拉刷新"];
            
            if (statusInfo.count != 0) {
                [self.navigationController showNotifitacion:[NSString stringWithFormat:@"刷新了%ld条动态",statusInfo.count]];
            }else{
                [self.navigationController showNotifitacion:@"已经是最新内容"];
            }
            
        }else{
            //请求更多
            for (NSDictionary *dict in statusInfo) {
                //转化为模型
                Status *status = [[Status alloc]initStatusWithDictionary:dict];
                //不等于数组的最后一条id则添加
                if (![status.idStr isEqualToString:[self.statues.lastObject idStr]]) {
                    [self.statues addObject:status];
                }
            }
            //更新UI
        }
        
        //更新ui
        [self.tableView reloadData];
        //保存数据
      [DataBaseEngine saveStatuses2Database:statusInfo];
        
        //请求结束
        _refreshing = NO;
        
    } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
        //请求结束
        _refreshing = NO;
    }];
}

//点击tabbarItem的刷新方法
- (void)refreshData
{
    //触发下拉刷新
    [self loadNew:self.refreshControl];
    //下拉刷新UI
    [self.refreshControl beginRefreshing];
    //显示出refreshcontrol
    [self.tableView setContentOffset:CGPointMake(0, -100)];
}

- (void)loadNew:(UIRefreshControl *)control
{
    //设置属性字符串标题
    [self setRefreshControlTitle:@"正在加载"];
    
    //取出第一条微博
    Status *status = [self.statues firstObject];
    //请求更新
    [self reloadStatusWith:status.idStr maxId:@"0"];
}

- (void)reloadMore
{
    //取出最后一条微博
    Status *status = [self.statues lastObject];
    [self reloadStatusWith:@"0" maxId:status.idStr];
}

- (void)setRefreshControlTitle:(NSString *)title
{
    //构造属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                          NSForegroundColorAttributeName:[UIColor orangeColor]};
    //构造属性字符串
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:title attributes:dic];
    
    //设置refresh的title
    [self.refreshControl setAttributedTitle:attStr];
}

- (void)loadData
{
    //想微博平台请求数据
    [self reloadStatusWith:@"0" maxId:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //用section有间距
    return self.statues.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    Status *status =self.statues[indexPath.section];
    [cell setStatus:status];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算cell需要的高度
    return  [StatusTableViewCell cellHeightWithStatus:self.statues[indexPath.section]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当倒数第五条,触发加载更多方法
    if (self.statues.count - indexPath.section <= 5) {
        [self reloadMore];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    StatusCellHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    [footer bangdingStatus:self.statues[section]];
    
    footer.retwitterBtn.tag = section;//保存footer所在的索引
    [footer.retwitterBtn addTarget:self action:@selector(retwitter:) forControlEvents:UIControlEventTouchUpInside];
    footer.commentBtn.tag = section;
    [footer.commentBtn addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
    footer.likeBtn.tag = section;
    [footer.likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else{
        return 10.f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.f;
}

#pragma mark - action
- (void)retwitter:(UIButton *)btn
{
    //要转发的微博
    Status *reportsStatus = self.statues[btn.tag];
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"sendStatusNav"];
    [nav.viewControllers[0] performSelector:@selector(setReportsStatus:) withObject:reportsStatus];
    SendStatusViewController *sendStatusVC = nav.viewControllers[0];
    sendStatusVC.type = KReportsStatus;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)comments:(UIButton *)btn
{
    
}

- (void)like:(UIButton *)btn
{
    
}

- (void)qrcode:(UIBarButtonItem *)sender
{
    //push二维码扫描界面
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcode"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //目的控制器
    UIViewController *destiVC = segue.destinationViewController;
    
    //sender就是cell,通过cell找到要显示的微博详情
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    //将要显示的Status
    Status *status = self.statues[indexPath.section];
    
    //赋值给下一个控制器
    [destiVC setValue:status forKey:@"status"];
    
}
@end
