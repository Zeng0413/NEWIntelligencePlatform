//
//  OCOrderedSeatListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/11.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCOrderedSeatListViewController.h"
#import "OCOrderListModel.h"
#import "OCOrderSeatCell.h"
#import "OCInfoMessagePushView.h"

@interface OCOrderedSeatListViewController ()<UITableViewDelegate, UITableViewDataSource, OCOrderSeatCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;

@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation OCOrderedSeatListViewController

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
    [self requestOrderRecordData];
    
    [self setupTableView];

    // Do any additional setup after loading the view.
}


#pragma mark - UI figure
-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, 35 + 15*FITWIDTH, kViewW, kViewH - kNavH - 35 - 15*FITWIDTH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCOrderSeatCell *cell = [OCOrderSeatCell initWithOCOrderSeatCellTableView:tableView cellForAtIndexPath:indexPath];
    cell.index = self.index;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67*FITWIDTH;
}

#pragma mark - cell delegate
-(void)cancelOrderSeatWithModel:(OCOrderListModel *)model{
    
    NSString *endDateToDay = [NSString formateDateToDay:NSStringFormat(@"%ld",model.endTime)];
     NSDate *endD = [NSString dateFromTimeStr:endDateToDay];
     BOOL isToday = endD.isToday;
     BOOL isTorrom = endD.isTorromday;
     BOOL isTorromLast = endD.isTorromdayLast;
     NSString *timeStr = @"";
     if (isToday) {
         timeStr = @"今天";
     }else if (isTorrom){
         timeStr = @"明天";
     }else if (isTorromLast){
         timeStr = @"后天";
     }
     NSString *endDate = [NSString formateDateOnlyYueri:NSStringFormat(@"%ld",model.endTime)];
     NSString *startTime = [NSString formateDateOnlyShifen:NSStringFormat(@"%ld",model.starTime)];
     NSString *endTime = [NSString formateDateOnlyShifen:NSStringFormat(@"%ld",model.endTime)];
    
     NSString *orderSeatTime = @"";
     if (timeStr.length>0) {
         orderSeatTime = NSStringFormat(@"%@%@%@-%@",timeStr,endDate,startTime,endTime);
     }else{
         orderSeatTime = NSStringFormat(@"%@%@-%@",endDate,startTime,endTime);
     }
    
    OCInfoMessagePushView *infoPushView = [[OCInfoMessagePushView alloc]initWithPushViewFrame:Rect(0, 0, kViewW - 67*2*FITWIDTH, 0) withAllStr:NSStringFormat(@"确认取消%@时段%@%@座位吗？",orderSeatTime,model.seatArea,model.seatName) withPointStr:orderSeatTime withPointStrColor:kAPPCOLOR withBtnCount:2 withBtn1Str:@"取消" withBtn2Str:@"确定"];
    TYAlertController * tyVC = [TYAlertController alertControllerWithAlertView:infoPushView preferredStyle:TYAlertControllerStyleAlert];
    tyVC.backgoundTapDismissEnable = YES;
    [self presentViewController:tyVC animated:YES completion:nil];
    Weak;
    [infoPushView setCancelBlock:^{
        [tyVC dismissViewControllerAnimated:NO];
    }];
    [infoPushView setBtnBlock:^(NSInteger type) {
        if (type == 1) {
        }else{
            [MBProgressHUD showMessage:@""];
            [APPRequest deleteRequestWithURLStr:NSStringFormat(@"%@/%@v1/reservation/record/%@",kURL,APICollegeURL,model.ID) paramDic:@{} success:^(id responseObject) {
                wself.page = 1;
                wself.totalPage = 1;
                [wself requestOrderRecordData];
            } error:^(id responseObject) {
            } failure:^(NSError *error) {
            } controller:self];
        }
        [tyVC dismissViewControllerAnimated:NO];

    }];
}

#pragma mark - action method
- (void)noticePullRefresh {
    _page = 1;
    [self requestOrderRecordData];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestOrderRecordData];
}

#pragma mark - 网络请求
-(void)requestOrderRecordData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(self.index);
    params[@"currentPage"] = @(_page);
    params[@"pageSize"] = @(20);
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/reservation/record",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSLog(@"%@",responseObject);
        NSArray *list = [OCOrderListModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        if (wself.page == 1) {
            wself.dataArray = [NSMutableArray array];
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
