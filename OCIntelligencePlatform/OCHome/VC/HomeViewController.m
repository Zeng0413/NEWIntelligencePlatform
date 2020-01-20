//
//  HomeViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "HomeViewController.h"
#import "courseViewController.h"
#import "OCHomeCourseCell.h"
#import "HMScannerController.h"
#import "OCCourseListModel.h"
#import "OCCourseInteractionEnterViewController.h"
#import "OCTermModel.h"
#import "OCLeftPushView.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSDictionary *dataDict;

@property (strong, nonatomic) NSArray *dataArr;

@property (strong, nonatomic) NSArray *termArr;
@property (strong, nonatomic) OCTermModel *currentTermModel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;

    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"" rightImage:nil rightAction:^{
//        [wself toScannerVc];
    } backAction:^{
        NSInteger index = 0;
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        for (int i = 0; i<wself.termArr.count; i++) {
            OCTermModel *model = wself.termArr[i];
            if (model.ID == wself.currentTermModel.ID) {
                index = i;
            }
        }
        OCLeftPushView *leftView = [OCLeftPushView showLeftPushViewWithDataArr:wself.termArr withSelectedIndex:index];
        leftView.block = ^(OCTermModel * _Nonnull model) {
            wself.currentTermModel = model;
            [wself refreshNavLeftView];
            [wself requestCourseListData];
        };
        [keyWindow addSubview:leftView];
    }];
    [self.ts_navgationBar.backButton setTitle:self.dataDict[@"semesterName"] forState:UIControlStateNormal];
    self.ts_navgationBar.backButton.titleLabel.font = kBoldFont(15);
    self.ts_navgationBar.backButton.width = 120;
    self.ts_navgationBar.backButton.image = nil;
    [self.ts_navgationBar.backButton setTitleColor:TEXT_COLOR_BLACK forState:UIControlStateNormal];
    
    // 检查更新
    [OCPublicMethodManager checkWersion];
    [self requestTermList];
    [self setupTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
    if (self.dataArr.count == 0) {
        NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

            if ([has integerValue] == 1) {
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无互动课程~"];
            }else{
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}


-(void)toScannerVc{
    
    Weak;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        [wself studentSignRequestWithToken:stringValue];
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}


#pragma mark -- view figuer


-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kDockH - kNavH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 198*FITWIDTH;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

        if ([has integerValue] == 1) {
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无互动课程~"];
        }else{
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    [self.view addSubview:self.tableView];
}

-(void)refreshNavLeftView{
    NSString *startStr = NSStringFormat(@"%ld",self.currentTermModel.startYear);
    NSString *endStr = NSStringFormat(@"%ld",self.currentTermModel.endYear);

    NSString *startTime = [startStr substringFromIndex:startStr.length-2];
    NSString *endTime = [endStr substringFromIndex:endStr.length-2];
    
    NSString *timeStr = NSStringFormat(@"%@ %@-%@",self.currentTermModel.termName,startTime,endTime);
    NSString *changeStr = [[timeStr componentsSeparatedByString:@" "] firstObject];
    NSMutableAttributedString *attrStr = [OCPublicMethodManager changeWithString:timeStr withChangeString:changeStr];
    [self.ts_navgationBar.backButton setAttributedTitle:attrStr forState:UIControlStateNormal];
    CGSize backSize = [self.ts_navgationBar.backButton.titleLabel.text sizeWithFont:kBoldFont(18)];
    self.ts_navgationBar.backButton.size = CGSizeMake(backSize.width+30, backSize.height+30);
}

-(void)refresh{
    [self requestCourseListData];
}

#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OCHomeCourseCell *cell = [OCHomeCourseCell initWithHomeCourseTableView:tableView cellForAtIndexPath:indexPath];
    cell.dataModel = self.dataArr[indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseListModel *model = self.dataArr[indexPath.row];
    courseViewController *vc = [[courseViewController alloc] init];
    vc.courseModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求
-(void)studentSignRequestWithToken:(NSString *)signToken{
    [MBProgressHUD showMessage:@""];
    NSString *userId = [kUserDefaults valueForKey:@"userId"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sign"] = @"1";
    params[@"studentId"] = userId;
    params[@"token"] = signToken;
    params[@"type"] = @"1";
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/sign",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        OCCourseInteractionEnterViewController *vc = [[OCCourseInteractionEnterViewController alloc] init];
        vc.signDict = responseObject;
        [kUserDefaults setValue:responseObject[@"clazzId"] forKey:@"signClazzId"];
        [wself.navigationController pushViewController:vc animated:YES];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)requestCourseListData{
    NSString *userId = [kUserDefaults valueForKey:@"userId"];
    NSDictionary *params = @{@"currentPage":@"1", @"pageSize":@"1000", @"termId":NSStringFormat(@"%ld",self.currentTermModel.ID), @"userId":userId};
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/course/student/list",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);

        wself.dataArr = [OCCourseListModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        [wself.tableView reloadData];
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.tableView);
    } viewController:self];
}

-(void)requestTermList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"schoolId"] = SINGLE.userModel.schoolId;
    params[@"currentPage"] = @"1";
    params[@"pageSize"] = @"1000";
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/term/list",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        wself.termArr = [OCTermModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        
        for (OCTermModel *model in wself.termArr) {
            NSDate *startDate = [[NSDate dateFromString:model.startTime withFormat:@"yyyy-MM-dd"] followingDay];
            NSDate *endDate = [[NSDate dateFromString:model.endTime withFormat:@"yyyy-MM-dd"] followingDay];
            NSDate *nowDate = [NSDate date];
            if ([OCPublicMethodManager date:nowDate isBetweenDate:startDate andDate:endDate]) {
                wself.currentTermModel = model;
                break;
            }
        }
        
        if (wself.currentTermModel) {
            [wself refreshNavLeftView];
            [wself requestCourseListData];
        }
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

@end
