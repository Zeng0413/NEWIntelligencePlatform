//
//  OCTomorrwLiveViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTomorrwLiveViewController.h"
#import "OCTomorrowLiveListCell.h"
#import "OCLiveVideoModel.h"
@interface OCTomorrwLiveViewController ()<UITableViewDelegate, UITableViewDataSource, OCTomorrowLiveListCellDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) OCTomorrowLiveListCell *listCell;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation OCTomorrwLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];

    self.view.backgroundColor = kBACKCOLOR;
    
//    for (int i = 0; i<3; i++) {
//        OCLiveVideoModel *model = [[OCLiveVideoModel alloc] init];
//        model.title = @"微观经济学-第三讲";
//        model.speaker = @"汪明";
//        model.startTimeTip = @"2019/05/08 09:30";
//        [self.dataSource addObject:model];
//    }
    
    [self setupTableView];
    [self requestLiveListData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.dataSource.count == 0) {
        NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

            if ([has integerValue] == 1) {
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无直播~"];
            }else{
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
    }
    
}

#pragma mark ----------------------------------- 交互事件
- (void)refresh {
    [self requestLiveListData];
}

#pragma mark -- view figuer


-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, 35, kViewW, kViewH - kStatusH - 35 - kDockH - 15)];
    self.tableView.backgroundColor = kBACKCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

        if ([has integerValue] == 1) {
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无直播~"];
        }else{
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    [self.view addSubview:self.tableView];
}

#pragma mark - table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTomorrowLiveListCell *cell = [OCTomorrowLiveListCell initWithTomorrowLiveListTableView:tableView cellForAtIndexPath:indexPath];
    cell.dataModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    self.listCell = cell;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.listCell.cellH;
}

#pragma mark - cell delegate
-(void)likeLookWithModel:(OCLiveVideoModel *)model{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"endTime"] = model.endTimeTip;
    params[@"equipmentId"] =  NSStringFormat(@"%ld",model.recordEquipmentId);
    params[@"roomCode"] = model.recordEquipmentName;
    params[@"startTime"] = model.startTimeTip;
    params[@"teacher"] = model.speaker;
    params[@"title"] = model.title;
    
    [MBProgressHUD showMessage:@""];
    Weak;
    if (model.wannaSee == 0) {
        [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/wannaSee",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
            [wself requestLiveListData];
        } stateError:^(id responseObject) {
        } failure:^(NSError *error) {
        } viewController:self];
    }else{
        [APPRequest deleteRequestWithURLStr:NSStringFormat(@"%@/%@v1/wannaSee",kURL,APICollegeURL) paramDic:params success:^(id responseObject) {
            [wself requestLiveListData];
        } error:^(id responseObject) {
        } failure:^(NSError *error) {
        } controller:self];
    }
    
}

#pragma mark ----------------------------------- 网络请求
- (void)requestLiveListData {
    self.tableView.x = 0;
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizLiveListTodayAndTomorrow/%@/%@",[kUserDefaults valueForKey:kInsideURL],APICourseURL,SINGLE.userModel.schoolId,SINGLE.userModel.userId) parameters:@{} success:^(id responseObject) {
        SLEndRefreshing(self.tableView);
        NSDictionary *dataDict = [NSString stringConvertToDic:responseObject];
        wself.dataSource = [[OCLiveVideoModel objectArrayWithKeyValuesArray:dataDict[@"data"][@"list"][@"listTonorrowLive"]] mutableCopy];
        
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(self.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(self.tableView);
    } viewController:self needCache:NO];
}
@end
