//
//  OCClassroomApproveViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/9.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomApproveViewController.h"
#import "OCCommonTopChooseView.h"
#import "OCClassroomApproveCell.h"
#import "OCClassroomBorrowModel.h"

@interface OCClassroomApproveViewController ()<UITableViewDelegate, UITableViewDataSource, OCClassroomApproveCellDelegate>
@property (strong, nonatomic) OCCommonTopChooseView *topView;
@property (strong, nonatomic) OCClassroomApproveCell *approveCell;
@property (weak, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@end

@implementation OCClassroomApproveViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.totalPage = 1;
    self.index = 0;
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"教室审批" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self requestClassroomApproveList];
    [self setupTopView];
    [self setupTableView];
}

#pragma mark - view figure
-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, MaxY(self.topView), kViewW, kViewH - MaxY(self.topView))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1) {
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无审批~"];
        }else{
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)setupTopView{
    if (!self.topView) {
        self.topView = [[OCCommonTopChooseView alloc] initWithTopViewFrame:Rect(0, kNavH, kViewW, 38*FITWIDTH) titleName:@[@"待处理", @"已通过", @"已拒绝"] aveWidth:3];
        [self.view addSubview:self.topView];
        
        Weak;
        _topView.block = ^(NSInteger tag) {
            wself.page = 1;
            wself.totalPage = 1;

            wself.index = tag;
            [wself requestClassroomApproveList];
//            [wself.tableView reloadData];
//            daySelectedIndex = tag;
//            [wself changeOrderList];
        };
        
        // 默认选中订单类型
        [self.topView selectedWithIndex:0];
    }
}

#pragma mark - action method
- (void)noticePullRefresh {
    _page = 1;
    [self requestClassroomApproveList];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestClassroomApproveList];
}


#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCClassroomApproveCell *cell = [OCClassroomApproveCell initWithClassroomApproveWithTableView:tableView cellForAtIndexPath:indexPath];
    cell.dataModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    self.approveCell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.approveCell.cellH;
}

#pragma mark - cell delegate
-(void)cellOperateClickWithModel:(OCClassroomBorrowModel *)model withType:(NSInteger)type{
    [MBProgressHUD showMessage:@""];
    Weak;
    NSString *urlStr = NSStringFormat(@"%@/%@v1/classroom/audit/%@/%ld/%@",kURL,APICollegeURL,model.borrowId,type,@"无");
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [APPRequest putRequestWithUrl:urlStr parameters:@{} success:^(id responseObject) {
        [wself requestClassroomApproveList];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
    
}

#define mark - 教室审批
-(void)requestClassroomApproveList{
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1) {
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无审批~"];
        }else{
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/classroom/borrow/list/%ld",kURL,APICollegeURL,self.index+1) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCClassroomBorrowModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
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
@end
