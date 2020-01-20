//
//  OCMyAnswerPaperViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCMyAnswerPaperViewController.h"
#import "OCCourseDetailCommonCell.h"
#import "OCCourseProblemCell.h"
#import "OCCourseReportNoDataCell.h"
#import "OCCourseGroupViewController.h"
#import "OCCourseReportViewController.h"
#import "OCCourseDiscussViewController.h"
@interface OCMyAnswerPaperViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *headTitleArr;
@property (strong, nonatomic) NSDictionary *myGroupDict; // 我的分组列表
@property (strong, nonatomic) NSArray *discussList; // 课堂讨论
@property (strong, nonatomic) NSArray *questionList; // 课堂答题

@property (strong, nonatomic) OCCourseProblemCell *problemCell;

@end

@implementation OCMyAnswerPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"我的答题卡" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.headTitleArr = @[@"我的小组",@"课堂答题",@"课堂讨论"];
    
    [self requestMyAnswerPaperData];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

#pragma mark -- view figuer
-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH-kNavH)];
    self.tableView.backgroundColor = kBACKCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"OCCourseDetailCommonCell" bundle:nil] forCellReuseIdentifier:@"OCCourseDetailCommonCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OCCourseReportNoDataCell" bundle:nil] forCellReuseIdentifier:@"OCCourseReportNoDataCellID"];
    [self.view insertSubview:self.tableView atIndex:0];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headTitleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.discussList.count>0?self.discussList.count:1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseReportNoDataCell *noDataCell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseReportNoDataCellID"];
    if (indexPath.section == 0) {
        if ([self.myGroupDict[@"id"] integerValue]==0) {
            return noDataCell;
        }
        OCCourseDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseDetailCommonCellID"];
        cell.titleLab.text = self.myGroupDict[@"name"];
        cell.subTitleLab.text = @"课堂得分";
        return cell;
    }else if (indexPath.section == 1){
        if (self.questionList.count == 0) {
            return noDataCell;
        }
        OCCourseProblemCell *cell = [OCCourseProblemCell initWithCourseProblemTableView:tableView cellForAtIndexPath:indexPath];
        cell.courseProblemArr = self.questionList;
        self.problemCell = cell;
        return cell;
    }else{
        if (self.discussList.count == 0) {
            return noDataCell;
        }
        NSDictionary *dict = self.discussList[indexPath.row];
        OCCourseDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseDetailCommonCellID"];
        cell.titleLab.text = dict[@"name"];
        cell.subTitleLab.text = @"查看所有发言";
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([self.myGroupDict[@"id"] integerValue]==0) {
            return 79;
        }
        return 88;
    }else if (indexPath.section == 1){
        if (self.questionList.count==0) {
            return 79;
        }
        return self.problemCell.cellH;
    }else{
        if (self.discussList.count==0) {
            return 79;
        }
        return 64*FITWIDTH;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([self.myGroupDict[@"id"] integerValue]!=0) {
            OCCourseGroupViewController *vc = [[OCCourseGroupViewController alloc] init];
            vc.tempDict = self.myGroupDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (self.questionList.count != 0) {
            OCCourseLessonModel *model = [[OCCourseLessonModel alloc] init];
            model.ID = self.lessonID;
            OCCourseReportViewController *vc = [[OCCourseReportViewController alloc] init];
            vc.dataModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (self.discussList.count != 0) {
            OCCourseDiscussViewController *vc = [[OCCourseDiscussViewController alloc] init];
            vc.tempDict = self.discussList[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, 38*FITWIDTH)];
    
    UILabel *titleLab = [UILabel labelWithText:self.headTitleArr[section] font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20, 20, 120*FITWIDTH, 18*FITWIDTH)];
    titleLab.font = [UIFont boldSystemFontOfSize:18*FITWIDTH];
    [headView addSubview:titleLab];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38*FITWIDTH;
}

#pragma mark - 网络请求
-(void)requestMyAnswerPaperData{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/lesson/answer/sheet/%ld/%@",kURL,APIInteractiveURl,self.lessonID,[kUserDefaults valueForKey:@"signClazzId"]) parameters:@{} success:^(id responseObject) {
        wself.myGroupDict = responseObject[@"myGroup"];
        wself.discussList = responseObject[@"discusstList"];
        wself.questionList = responseObject[@"questionList"];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}
@end
