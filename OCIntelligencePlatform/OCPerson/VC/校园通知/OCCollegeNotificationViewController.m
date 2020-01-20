//
//  OCCollegeNotificationViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCollegeNotificationViewController.h"
#import "OCCollegeNotiModel.h"
#import "OCSystemMessageCell.h"
#import "OCCollegeNotiDetailViewController.h"

@interface OCCollegeNotificationViewController ()<UITableViewDelegate, UITableViewDataSource, OCSystemMessageCellDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) OCSystemMessageCell *systemCell;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation OCCollegeNotificationViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE;
    
    self.page = 1;
    self.totalPage = 1;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"校园通知" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setupTableView];

    [self requestDataArr];
}

-(void)requestDataArr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"filters"] = @"";
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
//    params[@"schoolId"] = SINGLE.userModel.schoolId;
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/ecc/notice/list",kURL,APIIotURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCCollegeNotiModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];

        if (wself.page == 1) {
            [wself.dataArray removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.page >= wself.totalPage) {
            wself.tableView.mj_footer.hidden = YES;
        }else{
            wself.tableView.mj_footer.hidden = NO;
        }
        [wself.dataArray addObjectsFromArray:list];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.tableView);
    } viewController:self];
}


#pragma mark - view figure
-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH)];
    tableView.backgroundColor = WHITE;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1){
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无通知~"];
        }else{
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }

    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark ------------------------------------------------------- 交互事件
- (void)noticePullRefresh {
    _page = 1;
    [self requestDataArr];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestDataArr];
}
#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCSystemMessageCell *cell = [OCSystemMessageCell initWithOCSystemMessageCellTableView:tableView cellForAtIndexPath:indexPath];
    cell.collegeNotiModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    self.systemCell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.systemCell.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCollegeNotiDetailViewController *vc = [[OCCollegeNotiDetailViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickWithCell:(OCSystemMessageCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OCCollegeNotiDetailViewController *vc = [[OCCollegeNotiDetailViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
