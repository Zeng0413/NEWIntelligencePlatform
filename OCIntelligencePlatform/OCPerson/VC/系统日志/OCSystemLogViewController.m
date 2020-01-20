//
//  OCSystemLogViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSystemLogViewController.h"
#import "OCSystemLogCell.h"
#import "OCSystemLogFiltrateView.h"

@interface OCSystemLogViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) OCSystemLogFiltrateView *filtrateView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *topView;

@property (assign, nonatomic) BOOL isOpen;
@end

@implementation OCSystemLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"系统日志" rightTitle:@"高级搜索" rightAction:^{
        [wself rightClick];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setupTopView];
    [self setupTableView];

}

#pragma mark - view figure
-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH+40*FITWIDTH, kViewW, kViewH - (kNavH+40*FITWIDTH))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 63;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"OCSystemLogCell" bundle:nil] forCellReuseIdentifier:@"OCSystemLogCellID"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)setupTopView{
    self.filtrateView = [OCSystemLogFiltrateView creatSystemLogFiltrateView];
    self.filtrateView.size = CGSizeMake(kViewW, 205);
    self.filtrateView.x = 0;
    self.filtrateView.y = -self.filtrateView.height;
    [self.view addSubview:self.filtrateView];
    
    NSArray *tempArr = @[@"用户名", @"操作模块", @"日志标题", @"建立时间"];
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

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCSystemLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCSystemLogCellID"];
    return cell;
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
@end
