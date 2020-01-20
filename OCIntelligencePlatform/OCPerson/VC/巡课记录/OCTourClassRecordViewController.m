//
//  OCTourClassRecordViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTourClassRecordViewController.h"
#import "OCTourClassRecordFiltrateView.h"
#import "OCSystemLogCell.h"
#import "OCTourClassRecordModel.h"

@interface OCTourClassRecordViewController ()<UITableViewDelegate, UITableViewDataSource, OCTourClassRecordFiltrateViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *topView;
@property (strong, nonatomic) OCTourClassRecordFiltrateView *filtrateView;

@property (assign, nonatomic) BOOL isOpen;

@property (copy, nonatomic) NSString *courseName;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger endTime;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger totalPage;

@property (assign, nonatomic) NSInteger startTime;
@property (copy, nonatomic) NSString *teachUser;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation OCTourClassRecordViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    self.currentPage = 1;
    self.totalPage = 1;
    self.pageSize = 20;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"巡课记录" rightTitle:@"高级搜索" rightAction:^{
        [wself rightClick];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self requestTourClassList];
    [self setupTopView];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

#pragma mark - view figure
-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH+40*FITWIDTH, kViewW, kViewH - (kNavH+40*FITWIDTH))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 63;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"OCSystemLogCell" bundle:nil] forCellReuseIdentifier:@"OCSystemLogCellID"];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1) {
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无记录~"];
        }else{
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark ------------------------------------------------------- 交互事件
- (void)noticePullRefresh {
    _currentPage = 1;
    [self requestTourClassList];
}

- (void)noticeDropRefresh {
    _currentPage ++;
    if (_currentPage > _totalPage) {
        _currentPage --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestTourClassList];
}

-(void)setupTopView{
    self.filtrateView = [OCTourClassRecordFiltrateView creatTourClassRecordFiltrateView];
    self.filtrateView.size = CGSizeMake(kViewW, 157);
    self.filtrateView.x = 0;
    self.filtrateView.y = -self.filtrateView.height;
    self.filtrateView.delegate = self;
    [self.view addSubview:self.filtrateView];
    
    NSArray *tempArr = @[@"巡课时间", @"课程名称", @"授课人", @"评分"];
    UIView *topBackView = [UIView viewWithBgColor:WHITE frame:Rect(0, kNavH, kViewW, 40*FITWIDTH)];
    [self.view addSubview:topBackView];
    
    for (int i = 0; i<tempArr.count; i++) {
        UILabel *label = [UILabel labelWithText:tempArr[i] font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
        label.font = kBoldFont(14*FITWIDTH);
        label.size = CGSizeMake(kViewW/4, 39*FITWIDTH);
        label.x = label.width*i;
        label.y = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [topBackView addSubview:label];
    }
    
    UIView *lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20, 39*FITWIDTH, kViewW-40, 1*FITWIDTH)];
    [topBackView addSubview:lineView];
    
    self.topView = topBackView;
}


#pragma mark - action method
-(void)rightClick{
    if (!self.isOpen) {
        self.ts_navgationBar.rightButton.title = @"收起搜索";
        [UIView animateWithDuration:0.5 animations:^{
            self.filtrateView.y = kNavH;
            self.topView.y = MaxY(self.filtrateView)+10;
            self.tableView.y = MaxY(self.topView);
            self.tableView.height = kViewH - self.tableView.y;


        }];
    }else{
        self.ts_navgationBar.rightButton.title = @"高级搜索";
        [UIView animateWithDuration:0.5 animations:^{
            self.filtrateView.y = -self.filtrateView.height;
            self.topView.y = kNavH;
            self.tableView.y = MaxY(self.topView);
            self.tableView.height = kViewH - self.tableView.y;
        }];
    }
    self.isOpen = !self.isOpen;
}

#pragma mark - filtrateView delegate
-(void)tourClassSearchClickWithCourseName:(NSString *)courseName withTeachName:(NSString *)teachName withStarTime:(NSInteger)startTime withEndTime:(NSInteger)endTime{
    self.courseName = courseName;
    self.teachUser = teachName;
    self.startTime = startTime;
    self.endTime = endTime;
    self.currentPage = 1;
    [self requestTourClassList];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCSystemLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCSystemLogCellID"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 网络请求
-(void)requestTourClassList{
    
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1) {
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无记录~"];
        }else{
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    
    Weak;
//    [MBProgressHUD showMessage:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"courseName"] = self.courseName.length==0?@"":self.courseName;
    params[@"currentPage"] = @(self.currentPage);
    params[@"endTime"] = self.endTime?@(self.endTime):@(0);
    params[@"pageSize"] =  @(self.pageSize);
    params[@"startTime"] = self.startTime?@(self.startTime):@(0);
    params[@"teachUser"] = self.teachUser.length==0?@"":self.teachUser;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/patrolLesson/list",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCTourClassRecordModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        
        if (wself.currentPage == 1) {
            [wself.dataArray removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.currentPage >= wself.totalPage) {
            wself.tableView.mj_footer.hidden = YES;
        }else{
            wself.tableView.mj_footer.hidden = NO;
        }
        [wself.dataArray addObjectsFromArray:list];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
