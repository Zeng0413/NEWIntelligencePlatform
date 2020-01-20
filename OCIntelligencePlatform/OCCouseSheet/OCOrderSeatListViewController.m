//
//  OCOrderSeatListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/10.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCOrderSeatListViewController.h"
#import "OCClassroomBuildCell.h"
#import "OCClassroomBuildModel.h"
#import "OCOrderSeatViewController.h"
#import "OCInfoMessagePushView.h"

@interface OCOrderSeatListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *contentBackView;
}
@property (strong, nonatomic) UILabel *selectedWeekLab;
@property (strong, nonatomic) UILabel *dateLab;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) NSMutableArray *selectedBtnArr;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;

@property (strong, nonatomic) NSMutableArray *timeStrArray;

@property (copy, nonatomic) NSString *timeStr;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) NSString *weekStr;

@property (strong, nonatomic) NSMutableArray *weekArray;
@end

@implementation OCOrderSeatListViewController

-(NSMutableArray *)weekArray{
    if (!_weekArray) {
        _weekArray = [NSMutableArray array];
    }
    return _weekArray;
}

-(NSMutableArray *)timeStrArray{
    if (!_timeStrArray) {
        _timeStrArray = [NSMutableArray array];
    }
    return _timeStrArray;
}

-(NSMutableArray *)selectedBtnArr{
    if (!_selectedBtnArr) {
        _selectedBtnArr = [NSMutableArray array];
    }
    return _selectedBtnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBACKCOLOR;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"预约座位" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.weekStr = @"明天";
    
    UIButton *moreBtn = [UIButton buttonWithTitle:@"" titleColor:nil backgroundColor:nil font:0 image:@"common_btn_rule" frame:CGRectZero];
    moreBtn.x = kViewW - 20*FITWIDTH - 18*FITWIDTH;
    moreBtn.size = CGSizeMake(18*FITWIDTH, 18*FITWIDTH);
    moreBtn.y = kStatusH + 12*FITWIDTH;
    [moreBtn addTarget:self action:@selector(moreClick)];
    [self.ts_navgationBar addSubview:moreBtn];
    
    self.page = 1;
    self.totalPage = 1;
    
    [self setupTopUI];
    
    [self setupTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestReservationDate];
}

#pragma mark - view figure

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, MaxY(contentBackView), kViewW, kViewH - MaxY(contentBackView))];
    self.tableView.backgroundColor = kBACKCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    [self.view addSubview:self.tableView];
}

-(void)setupTopUI{
    
    contentBackView = [UIView viewWithBgColor:WHITE frame:Rect(0, kNavH, kViewW, 147*FITWIDTH - kNavH)];
    [self.view addSubview:contentBackView];
    
    CGFloat normalW = (kViewW - 40*FITWIDTH - 20*FITWIDTH*6)/7;
    NSDate *nextDate = [[NSDate date] followingDay];
    for (int i = 0; i<7; i++) {
        UILabel *weekLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(20*FITWIDTH + (20*FITWIDTH + normalW)*i, 4*FITWIDTH, normalW, 14*FITWIDTH)];
        weekLab.font = kBoldFont(14*FITWIDTH);
        weekLab.tag = 100+i;
        weekLab.textAlignment = NSTextAlignmentCenter;
        [contentBackView addSubview:weekLab];
        if (i == 0) {
            weekLab.textColor = RGBA(254, 106, 107, 1);
            weekLab.text = @"明天";
            self.selectedWeekLab = weekLab;
        }else if (i == 1){
            weekLab.text = @"后天";
        }else{
            NSString *weekStr = [OCPublicMethodManager translationArabicNum:[nextDate weekday]-1];
            weekLab.text = NSStringFormat(@"周%@",weekStr.length>0?weekStr:@"日");
        }
        
        [self.weekArray addObject:weekLab.text];
        
        /** 日期和字符串之间的转换：NSDate --> NSString */
        NSString *dateStr = [NSDate br_getDateString:nextDate format:@"MM-dd"];
        
        [self.timeStrArray addObject:NSStringFormat(@"%ld-%@",nextDate.br_year,dateStr)];
        
        UILabel *dateLab = [UILabel labelWithText:dateStr font:10*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(weekLab.x, MaxY(weekLab)+4*FITWIDTH, weekLab.width, 10*FITWIDTH)];
        dateLab.textAlignment = NSTextAlignmentCenter;
        [contentBackView addSubview:dateLab];
        
        nextDate = [nextDate followingDay];
        
        UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dateBtn.frame = Rect(weekLab.x, weekLab.y, weekLab.width, MaxY(dateLab)-4*FITWIDTH);
        dateBtn.tag = i;
        [dateBtn addTarget:self action:@selector(dateBtnClick:)];
        [contentBackView addSubview:dateBtn];
        
        if (i == 0) {
            self.timeStr = NSStringFormat(@"%ld-%@",nextDate.br_year,dateStr);
            self.lineView = [UIView viewWithBgColor:kAPPCOLOR frame:Rect(weekLab.x, MaxY(dateLab)+4*FITWIDTH, weekLab.width, 2*FITWIDTH)];
            [self.lineView setCornerRadius:self.lineView.height/2];
            [contentBackView addSubview:self.lineView];
        }
    }
    
    NSArray *titleArr = @[@"一大节",@"二大节",@"三大节",@"四大节",@"五大节",@"六大节"];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sectionBtn.size = CGSizeMake((kViewW - 28*FITWIDTH*2 - (7*FITWIDTH*(titleArr.count-1)))/titleArr.count, 21*FITWIDTH);
        sectionBtn.x = 20*FITWIDTH + (sectionBtn.width + 9*FITWIDTH)*i;
        sectionBtn.y = MaxY(self.lineView)+15*FITWIDTH;
        sectionBtn.title = titleArr[i];
        sectionBtn.tag = i+1;
        [sectionBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        sectionBtn.layer.cornerRadius = 4*FITWIDTH;
        sectionBtn.titleFont = 12*FITWIDTH;
        sectionBtn.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
        sectionBtn.layer.borderWidth = 1;
        [sectionBtn addTarget:self action:@selector(sectionClick:)];
        
        if (i == 0) {
            [self sectionClick:sectionBtn];
        }
        [contentBackView addSubview:sectionBtn];
    }
}


#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCClassroomBuildCell *cell = [OCClassroomBuildCell initWithClassroomBulidTableView:tableView cellForAtIndexPath:indexPath];
    cell.buildModel = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89*FITWIDTH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCOrderSeatViewController *vc = [[OCOrderSeatViewController alloc] init];
    vc.dateStr = self.timeStr;
    vc.weekStr = self.weekStr;
    
    if (self.selectedBtnArr.count==1) {
        UIButton *btn1 = [self.selectedBtnArr firstObject];
        vc.selIndex1 = btn1.tag;
        vc.selIndex2 = 100;
    }else if(self.selectedBtnArr.count==2){
        UIButton *btn1 = [self.selectedBtnArr firstObject];
        UIButton *btn2 = [self.selectedBtnArr lastObject];
        vc.selIndex1 = btn1.tag;
        vc.selIndex2 = btn2.tag;
    }
    vc.classroomModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网路请求
-(void)requestReservationDate{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = @(_page);
    params[@"date"] = self.timeStr;
    params[@"pageSize"] = @(20);
    
    NSString *sectionStr = @"";
    if (self.selectedBtnArr.count==1) {
        UIButton *btn = [self.selectedBtnArr firstObject];
        sectionStr = NSStringFormat(@"%ld",btn.tag);
    }else if(self.selectedBtnArr.count==2){
        UIButton *btn1 = [self.selectedBtnArr firstObject];
        UIButton *btn2 = [self.selectedBtnArr lastObject];
        if (btn1.tag>btn2.tag) {
            sectionStr = NSStringFormat(@"%ld",btn2.tag);
            sectionStr = [sectionStr stringByAppendingString:NSStringFormat(@",%ld",btn1.tag)];
        }else{
            sectionStr = NSStringFormat(@"%ld",btn1.tag);
            sectionStr = [sectionStr stringByAppendingString:NSStringFormat(@",%ld",btn2.tag)];
        }
        
    }
    params[@"session"] = sectionStr;

    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/reservation/date/list",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCClassroomBuildModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
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

#pragma mark - action method

-(void)moreClick{
    OCInfoMessagePushView *infoPushView = [[OCInfoMessagePushView alloc]initWithPushViewFrame:Rect(0, 0, kViewW - 67*2*FITWIDTH, 0) withAllStr:@"1. 仅允许预约从明日起七日内的座位。\n2. 每天最多预约两个时间段。\n3. 预约后需要使用二维码才能打开闸机。\n4. 二维码在预约时间前10分钟发放。\n5. 预约时间开始半小时后未到视为迟到 。\n6. 当月累计三次迟到或缺席后，则从第三次的当日起，七日内暂停开放预约功能，已预约的座位全部取消。\n7. 预约时间的当日不可以取消预约。" withPointStr:@"" withPointStrColor:TEXT_COLOR_BLACK withBtnCount:0 withBtn1Str:@"" withBtn2Str:@""];
    TYAlertController * tyVC = [TYAlertController alertControllerWithAlertView:infoPushView preferredStyle:TYAlertControllerStyleAlert];
    tyVC.backgoundTapDismissEnable = YES;
    [self presentViewController:tyVC animated:YES completion:nil];
    [infoPushView setCancelBlock:^{
        [tyVC dismissViewControllerAnimated:NO];
    }];
}

-(void)noticePullRefresh{
    self.page = 1;
    [self requestReservationDate];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestReservationDate];
    
}

-(void)sectionClick:(UIButton *)button{
    if (!button.selected) {
        if (self.selectedBtnArr.count<2) {
            if (self.selectedBtnArr.count>0) {
                UIButton *tempBtn = [self.selectedBtnArr firstObject];
                if (tempBtn.tag-1 == button.tag || tempBtn.tag+1 == button.tag) {
                    button.backgroundColor = RGBA(184, 205, 255, 1);
                    [button setTitleColor:WHITE];
                    button.layer.borderColor = CLEAR.CGColor;
                    [self.selectedBtnArr addObject:button];
                    button.selected = !button.selected;
                }else{
                    [tempBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
                    tempBtn.backgroundColor = WHITE;
                    tempBtn.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
                    tempBtn.selected = NO;
                    [self.selectedBtnArr removeObject:tempBtn];
                    
                    button.backgroundColor = RGBA(184, 205, 255, 1);
                    [button setTitleColor:WHITE];
                    button.layer.borderColor = CLEAR.CGColor;
                    [self.selectedBtnArr addObject:button];
                    button.selected = !button.selected;
                }
            }else{
                button.backgroundColor = RGBA(184, 205, 255, 1);
                [button setTitleColor:WHITE];
                button.layer.borderColor = CLEAR.CGColor;
                [self.selectedBtnArr addObject:button];
                button.selected = !button.selected;
            }
        }else{
            UIButton *tempBtn1 = [self.selectedBtnArr firstObject];
            UIButton *tempBtn2 = [self.selectedBtnArr lastObject];
            [tempBtn1 setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            tempBtn1.selected = NO;
            tempBtn1.backgroundColor = WHITE;
            tempBtn1.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
            
            [tempBtn2 setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            tempBtn2.selected = NO;
            tempBtn2.backgroundColor = WHITE;
            tempBtn2.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
            [self.selectedBtnArr removeAllObjects];
            
            button.backgroundColor = RGBA(184, 205, 255, 1);
            [button setTitleColor:WHITE];
            button.layer.borderColor = CLEAR.CGColor;
            [self.selectedBtnArr addObject:button];
            button.selected = !button.selected;
        }
        
    }else{
        if (self.selectedBtnArr.count != 1) {
            [button setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
            button.backgroundColor = WHITE;
            button.layer.borderColor = RGBA(112, 112, 112, 1).CGColor;
            [self.selectedBtnArr removeObject:button];
            button.selected = !button.selected;
        }
        
    }
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)dateBtnClick:(UIButton *)button{

    self.timeStr = self.timeStrArray[button.tag];

    self.weekStr = self.weekArray[button.tag];
    
    self.selectedWeekLab.textColor = RGBA(153, 153, 153, 1);
    UILabel *weekLab = [self.view viewWithTag:button.tag+100];
    weekLab.textColor = RGBA(254, 106, 107, 1);
    self.selectedWeekLab = weekLab;
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.centerX = weekLab.centerX;
    }];
    
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"%ld",weekLab.tag);
}
@end
