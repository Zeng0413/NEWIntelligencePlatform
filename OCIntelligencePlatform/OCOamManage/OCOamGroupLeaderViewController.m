//
//  OCOamHomeViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/12.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOamGroupLeaderViewController.h"
#import "OCOamGroupLeaderListCell.h"

@interface OCOamGroupLeaderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation OCOamGroupLeaderViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *temp = @[@"99",@"101",@"916"];
    for (int i = 0; i<3; i++) {
        OCOamManageModel *model = [[OCOamManageModel alloc] init];
        model.type = i;
        model.score = temp[i];
        [self.dataArray addObject:model];
    }
    
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}

#pragma mark - view figure
-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH - kDockH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 128*FITWIDTH;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCOamGroupLeaderListCell *cell = [OCOamGroupLeaderListCell initWithOCOamGroupLeaderListCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    cell.oamModel = self.dataArray[indexPath.row];
    return cell;
}
@end
