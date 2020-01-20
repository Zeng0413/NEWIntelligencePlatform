//
//  OCOamNormalListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOamNormalListViewController.h"
#import "OCOamNorListCell.h"

@interface OCOamNormalListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) OCOamNorListCell *oamCell;

@property (strong, nonatomic) NSArray *dataArr;

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation OCOamNormalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    self.dataArr = @[@{@"time":@"2019年11月03日 11:07", @"titleName":@"#747057 国际报告厅鹅颈会议筒鹅颈话筒故障", @"address":@"位置：国际报告厅【教育技术中心】", @"assets":@"资产：鹅颈会议话筒【鹅颈话筒故障】"},
                     @{@"time":@"2019年11月03日 09:10", @"titleName":@"501教室手持话筒未知故障", @"address":@"位置：501教室", @"assets":@"资产：手持话筒"}];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kViewW, kViewH - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCOamNorListCell *cell = [OCOamNorListCell initWithOCOamNorListCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    cell.dataDict = self.dataArr[indexPath.row];
    self.oamCell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.oamCell.cellH;
}

@end
