//
//  courseViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "courseViewController.h"
#import "OCCourseCell.h"
#import "OCCourseDetailViewController.h"
#import "OCCourseInteractionEnterViewController.h"
#import "OCCourseLessonModel.h"

@interface courseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *subTitleLab;

@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation courseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.backgroundColor = CLEAR;
 
    self.ts_navgationBar.backButton.image = @"common_btn_back_white";
    [self requestCourseLessonData];
    [self setupTableView];
    [self setupHeadView];
}

#pragma mark -- view figuer
-(void)setupHeadView{
    UIImageView *backImg = [UIImageView imageViewWithUrl:[NSURL URLWithString:self.courseModel.lessonImg] frame:Rect(0, 0, kViewW, 144*FITWIDTH)];
    backImg.backgroundColor = [UIColor blueColor];
    
    self.titleLab = [UILabel labelWithText:self.courseModel.courseName font:20*FITWIDTH textColor:WHITE frame:Rect(20, 74*FITWIDTH, kViewW-40, 20*FITWIDTH)];
    self.titleLab.font = [UIFont boldSystemFontOfSize:20*FITWIDTH];
    [backImg addSubview:self.titleLab];
    
//    self.subTitleLab = [UILabel labelWithText:@"正在发起单选题互动" font:14*FITWIDTH textColor:WHITE frame:Rect(self.titleLab.x, MaxY(self.titleLab)+12*FITWIDTH, kViewW-40, 14*FITWIDTH)];
//    [backImg addSubview:self.subTitleLab];
    
    [self.view insertSubview:backImg atIndex:0];
    
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, 144*FITWIDTH, kViewW, kViewH-144*FITWIDTH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 72*FITWIDTH;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.tableView atIndex:0];
}
-(void)refresh{
    [self requestCourseLessonData];
}
#pragma mark -- tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    OCCourseLessonModel *model = [[OCCourseLessonModel alloc] init];
//    model.taught = 1;
//    model.name = @"dasda";
//    self.dataArr = @[model];
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseCell *cell = [OCCourseCell initWithCourseTableView:tableView cellForAtIndexPath:indexPath];
    cell.dataModel = self.dataArr[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseLessonModel *model = self.dataArr[indexPath.section];
    [kUserDefaults setValue:model.clazzId forKey:@"signClazzId"];
    if (model.taught == 1) {
        OCCourseInteractionEnterViewController *vc = [[OCCourseInteractionEnterViewController alloc] init];
        vc.lessonModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.taught == 2){
        OCCourseDetailViewController *vc = [[OCCourseDetailViewController alloc] init];
        vc.imgType = self.courseModel.lessonImgType;
        vc.lessonImg = self.courseModel.lessonImg;
        vc.lessonModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OCCourseInteractionEnterViewController *vc = [[OCCourseInteractionEnterViewController alloc] init];
//        [kUserDefaults setValue:model.clazzId forKey:@"signClazzId"];
        vc.isNoClass = YES;
        vc.lessonModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, 6*FITWIDTH)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6*FITWIDTH;
}

#pragma mark - 网络请求
-(void)requestCourseLessonData{

    NSDictionary *params = @{@"courseId":NSStringFormat(@"%ld",self.courseModel.ID), @"currentPage":@"1", @"pageSize":@"1000"};
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/course/student/lessons/list",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        wself.dataArr = [OCCourseLessonModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.tableView);
    } viewController:self];
}

#pragma mark -- 懒加载
@end
