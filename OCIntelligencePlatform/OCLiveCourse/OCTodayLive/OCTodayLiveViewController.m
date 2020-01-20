//
//  OCTodayLiveViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTodayLiveViewController.h"
#import "OCTodayLiveListCell.h"
#import "OCTomorrowLiveListCell.h"

#import "OCLiveVideoModel.h"
#import "OCPlayVideoViewController.h"

@interface OCTodayLiveViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) OCTomorrowLiveListCell *listCell;

@property (assign, nonatomic) BOOL isPullRefresh;
@end

@implementation OCTodayLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;

    self.dataSource = [NSMutableArray array];
    self.page = 1;
    self.totalPage = 1;
    [self requestLiveListData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.dataSource.count == 0){
        NSString *isHasNetWorking = [kUserDefaults valueForKey:kNetWorkAlertStr];

            if ([isHasNetWorking integerValue] == 1) {
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无直播~"];
            }else{
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
    }
    
}

#pragma mark ----------------------------------- 交互事件
- (void)noticePullRefresh {
    _page = 1;
    self.isPullRefresh = YES;
    [self requestLiveListData];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestLiveListData];
}

#pragma mark ----------------------------------- 协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCLiveVideoModel *liveModel = self.dataSource[indexPath.row];
    if (liveModel.isLiving) {
        OCTodayLiveListCell * cell = [OCTodayLiveListCell creatLiveListCellWith:tableView data:_dataSource index:indexPath];
        return cell;
    }else{
        OCTomorrowLiveListCell *cell = [OCTomorrowLiveListCell initWithTomorrowLiveListTableView:tableView cellForAtIndexPath:indexPath];
        cell.dataModel = self.dataSource[indexPath.row];
        self.listCell = cell;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OCLiveVideoModel *liveModel = self.dataSource[indexPath.row];
    if (liveModel.isLiving) {
        OCPlayVideoViewController *vc = [[OCPlayVideoViewController alloc] init];
        vc.isLive = YES;
        vc.model = liveModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCLiveVideoModel *liveModel = self.dataSource[indexPath.row];
    if (liveModel.isLiving) {
        return (kViewW - 20) * 0.56 + 10;
    }else{
        return self.listCell.cellH;
    }
}


#pragma mark ----------------------------------- 网络请求
- (void)requestLiveListData {
    self.tableView.x = 0;
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizLiveListTodayAndTomorrow/%@/%@",[kUserDefaults valueForKey:kInsideURL],APICourseURL,SINGLE.userModel.schoolId,SINGLE.userModel.userId) parameters:@{} success:^(id responseObject) {
        SLEndRefreshing(self.tableView);
        wself.dataSource = [NSMutableArray array];
        NSDate *nowDate = [NSDate date];
        NSInteger nowHourInt = nowDate.br_hour;
        NSInteger nowMinuteInt = nowDate.br_minute;
        NSDate *nowHourDate = [NSDate br_setHour:nowHourInt minute:nowMinuteInt];
        NSDictionary *dataDict = [NSString stringConvertToDic:responseObject];
        NSArray *liveArray = dataDict[@"data"][@"list"][@"listTodayLive"];
        for (NSDictionary *dict in liveArray) {
            OCLiveVideoModel *liveModel = [OCLiveVideoModel objectWithKeyValues:dict];
            NSString *timeRange = [[dict[@"timeRangeTip"] componentsSeparatedByString:@" "] lastObject];
            
            NSString *startTimeStr = [[timeRange componentsSeparatedByString:@"-"] firstObject];
            NSString *startHourInt = [[startTimeStr componentsSeparatedByString:@":"] firstObject];
            NSString *startMinuteInt = [[startTimeStr componentsSeparatedByString:@":"] lastObject];
            NSDate *startHourDate = [NSDate br_setHour:[startHourInt integerValue] minute:[startMinuteInt integerValue]];
            
            NSString *endTimeStr = [[timeRange componentsSeparatedByString:@"-"] lastObject];
            NSString *endHourInt = [[endTimeStr componentsSeparatedByString:@":"] firstObject];
            NSString *endMinuteInt = [[endTimeStr componentsSeparatedByString:@":"] lastObject];
            NSDate *endHourDate = [NSDate br_setHour:[endHourInt integerValue] minute:[endMinuteInt integerValue]];
            if ([OCPublicMethodManager date:nowHourDate isBetweenDate:startHourDate andDate:endHourDate]) {
                liveModel.isLiving = YES;
            }
            [wself.dataSource addObject:liveModel];
        }
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(self.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(self.tableView);
    } viewController:self needCache:NO];
}

#pragma mark ----------------------------------- 懒加载
- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kViewW, kViewH - kStatusH - 35 - kDockH - 15)];
    
    _tableView.backgroundColor = kBACKCOLOR;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
//    _tableView.rowHeight = (kViewW - 20) * 0.56 + 10;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = 0;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

        if ([has integerValue] == 1) {
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无直播~"];
        }else{
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"OCTodayLiveListCell" bundle:nil] forCellReuseIdentifier:@"OCTodayLiveListCellID"];
    
    
    [self.view addSubview:_tableView];
    
    return _tableView;
}
@end
