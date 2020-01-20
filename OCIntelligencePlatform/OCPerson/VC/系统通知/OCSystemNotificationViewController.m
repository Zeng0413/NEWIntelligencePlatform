//
//  OCSystemNotificationViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSystemNotificationViewController.h"
#import "OCSystemMessageModel.h"
#import "OCSystemMessageCell.h"

@interface OCSystemNotificationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) OCSystemMessageCell *systemCell;

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation OCSystemNotificationViewController

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
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"系统通知" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [self requestSystemNotiData];
    
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1){
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无通知~"];
        }else{
            self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
}

#pragma mark - view figure
-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH)];
    tableView.backgroundColor = WHITE;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
    if ([has integerValue] == 1) {
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无通知~"];
        }else{
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCSystemMessageCell *cell = [OCSystemMessageCell initWithOCSystemMessageCellTableView:tableView cellForAtIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    self.systemCell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.systemCell.cellH;
}

#pragma mark - 网络请求
-(void)requestSystemNotiData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clazzId"] = [kUserDefaults valueForKey:@"signClazzId"];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/clazz/notice/list",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCSystemMessageModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        if (wself.page==1) {
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
    } failure:^(NSError *error) {
    } viewController:self];
}
@end
