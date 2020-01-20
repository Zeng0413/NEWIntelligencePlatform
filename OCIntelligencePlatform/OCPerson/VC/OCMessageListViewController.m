//
//  OCMessageListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCMessageListViewController.h"
#import "OCMessageNotifCell.h"
#import "OCCourseInteractionEnterViewController.h"
@interface OCMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *colorArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation OCMessageListViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorArr = @[RGBA(134, 199, 71, 1),RGBA(69, 197, 202, 1),RGBA(69, 93, 202, 1)];
    
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"消息通知" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.page = 1;
    self.totalPage = 1;
    [self setupTableView];
    
    [self requestMessageData];
    // Do any additional setup after loading the view.
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH-kNavH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView .rowHeight = 73*FITWIDTH;
    [tableView registerNib:[UINib nibWithNibName:@"OCMessageNotifCell" bundle:nil] forCellReuseIdentifier:@"OCMessageNotifCellID"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCMessageNotifCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCMessageNotifCellID"];
    cell.iconLab.backgroundColor = arc4randomColor;
    cell.dataDict = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    OCCourseInteractionEnterViewController *vc = [[OCCourseInteractionEnterViewController alloc] init];
    vc.signDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------------------------------------------------------- 交互事件
- (void)noticePullRefresh {
    _page = 1;
    [self requestMessageData];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestMessageData];
}
#pragma mark - 网络请求
-(void)requestMessageData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clazzId"] = [kUserDefaults valueForKey:@"signClazzId"];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/clazz/notice/list",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = responseObject[@"pageList"];
        if (wself.page==1) {
            [wself.dataSource removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.page >= wself.totalPage) {
            wself.tableView.mj_footer.hidden = YES;
        }else{
            wself.tableView.mj_footer.hidden = NO;
        }
        [wself.dataSource addObjectsFromArray:list];
        [wself.tableView reloadData];
        
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}
@end
