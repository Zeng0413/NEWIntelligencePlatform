//
//  OCCourseDetailViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseDetailViewController.h"
#import "OCCourseDetailCouserRourseCell.h"
#import "OCCourseDetailCommonCell.h"
#import "OCCourseProblemCell.h"
#import "OCCourseCallCountCell.h"
#import "OCCourseGroupViewController.h"
#import "OCCourseDiscussViewController.h"
#import "OCCourseReportViewController.h"
#import "OCCourseReportNoDataCell.h"
#import "OCCourseWareModel.h"
#import "WKWebViewController.h"
@interface OCCourseDetailViewController ()<UITableViewDelegate, UITableViewDataSource, OCCourseDetailCouserRourseCellDelegate>

@property (strong, nonatomic) NSArray *headTitleArr;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OCCourseDetailCouserRourseCell *couseRourseCell;
@property (strong, nonatomic) OCCourseProblemCell *problemCell;

@property (strong, nonatomic) NSDictionary *dataDict;
@property (nonatomic, assign) CGFloat navigationBarBGColor;

@property (strong, nonatomic) NSArray *courseWareList; // 课件列表
@property (strong, nonatomic) NSDictionary *myGroupDict; // 我的分组列表
@property (strong, nonatomic) NSArray *questionList; // 课堂答题
@property (strong, nonatomic) NSArray *discussList; // 课堂讨论

@property (strong, nonatomic) UIColor *mainBackColor;
@end

@implementation OCCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.imgType==1) {
        self.mainBackColor = kGreenCOLOR;
    }else{
        self.mainBackColor = kBACKCOLOR;
    }
    self.view.backgroundColor = self.mainBackColor;
    
//    self.dataDict = @{@"correctRate":@"70", @"wareCount":@"5", @"score":@"7", @"topImg":@"",
//                      @"courseWareList":@[@{@"id":@"", @"lessonId":@"", @"name":@"电磁场与电磁波第一章", @"size":@"", @"type":@(1), @"url":@""},
//                                          @{@"id":@"", @"lessonId":@"", @"name":@"电磁场与电磁波第一章", @"size":@"", @"type":@(1), @"url":@""}],
//                      @"myGroup":@[@{@"id":@"", @"name":@"第二组"}],
//                      @"questionList":@[@{@"correctCount":@"5", @"name":@"我答对的", @"totalCount":@"6", @"type":@"1"},
//                                        @{@"correctCount":@"4", @"name":@"我答对的", @"totalCount":@"6", @"type":@"2"},
//                                        @{@"correctCount":@"5", @"name":@"我答对的", @"totalCount":@"6", @"type":@"3"},
//                                        @{@"correctCount":@"5", @"name":@"我答对的", @"totalCount":@"6", @"type":@"4"}],
//                      @"discusstList":@[@{@"id":@"", @"name":@"第一次讨论"},@{@"id":@"", @"name":@"第二次讨论"}],
//                      @"rollCall":@{@"addScoreCount":@"15", @"callOutCount":@"1", @"score":@"4"}
//                      };
//
//    self.courseWareList = self.dataDict[@"courseWareList"];
//    self.myGroupList = self.dataDict[@"myGroup"];
//    self.questionList = self.dataDict[@"questionList"];
//    self.discussList = self.dataDict[@"discusstList"];
    
    [self requestLessonReport];
//    self.courseWareList = @[];
//    self.myGroupList = @[];
//    self.questionList = @[];
//    self.discussList = @[];
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:[NSString stringWithFormat:@"%@课堂报告",self.lessonModel.name] backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.headTitleArr = @[@"课件资源", @"我的小组", @"课堂答题", @"课堂讨论", @"课堂点名"];
    
    self.ts_navgationBar.backButton.image = @"common_btn_back_white";
    self.ts_navgationBar.backgroundColor = CLEAR;
    self.ts_navgationBar.titleLabel.textColor = WHITE;
    self.navigationBarBGColor = 0;
    
}

#pragma mark -- view figuer
-(void)setupTableView{
    CGFloat Y = kStatusH;
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, -Y, kViewW, kViewH+Y)];
    self.tableView.backgroundColor = self.mainBackColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self setupHeadView];
//    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(aa)];
    [self.tableView registerNib:[UINib nibWithNibName:@"OCCourseDetailCommonCell" bundle:nil] forCellReuseIdentifier:@"OCCourseDetailCommonCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OCCourseCallCountCell" bundle:nil] forCellReuseIdentifier:@"OCCourseCallCountCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OCCourseReportNoDataCell" bundle:nil] forCellReuseIdentifier:@"OCCourseReportNoDataCellID"];
    [self.view insertSubview:self.tableView atIndex:0];
}

-(void)aa{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

-(UIView *)setupHeadView{
    UIView *backView = [UIView viewWithBgColor:self.mainBackColor frame:Rect(0, 0, kViewW, 210*FITWIDTH)];
    [self.view insertSubview:backView atIndex:0];

    UIImageView *backImg = [UIImageView imageViewWithUrl:[NSURL URLWithString:self.lessonImg] frame:Rect(0, 0, kViewW, 144*FITWIDTH)];
    backImg.backgroundColor = [UIColor blueColor];
    [backView addSubview:backImg];
    
    NSArray *temp = @[@{@"t":[NSString stringWithFormat:@"%@",[self.dataDict[@"wareCount"] integerValue] == 0?@"--":NSStringFormat(@"%@ 个",self.dataDict[@"wareCount"])], @"s":@"课件资源"}, @{@"t":[self.dataDict[@"correctRate"] isEqualToString:@"0%"]?@"--":self.dataDict[@"correctRate"], @"s":@"答题正确率"}, @{@"t":[NSString stringWithFormat:@"%@",[self.dataDict[@"score"] integerValue]==0?@"--":NSStringFormat(@"%@ 分",self.dataDict[@"score"])], @"s":@"课堂得分"}];
    
    for (int i = 0; i<temp.count; i++) {
        CGFloat backW = (kViewW-40-13*FITWIDTH*2)/temp.count;
        UIView *typeBackView = [UIView viewWithBgColor:WHITE frame:Rect(20+(backW + 13*FITWIDTH)*i, 88*FITWIDTH, backW, backW*1.18)];
        typeBackView.layer.masksToBounds = YES;
        typeBackView.layer.cornerRadius = 4;
        [backView addSubview:typeBackView];
        
        NSDictionary *dict = temp[i];
        UILabel *titleLab = [UILabel labelWithText:dict[@"t"] font:30 textColor:kAPPCOLOR frame:CGRectZero];
        titleLab.font = [UIFont boldSystemFontOfSize:30*FITWIDTH];
        titleLab.size = [titleLab.text sizeWithFont:[UIFont boldSystemFontOfSize:30*FITWIDTH]];
        titleLab.x = (typeBackView.width - titleLab.width)/2;
        titleLab.y = typeBackView.height/2 - titleLab.height - 10*FITWIDTH;
        [typeBackView addSubview:titleLab];
        
        UILabel *subTitleLab = [UILabel labelWithText:dict[@"s"] font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
        subTitleLab.size = [subTitleLab.text sizeWithFont:[UIFont systemFontOfSize:14*FITWIDTH]];
        subTitleLab.centerX = titleLab.centerX;
        subTitleLab.y = typeBackView.height/2 + 10*FITWIDTH;
        [typeBackView addSubview:subTitleLab];
        
    }
    
    return backView;
}

#pragma mark -- tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headTitleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.discussList.count>0?self.discussList.count:1;
    }else if (section == 1){
        return 1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseReportNoDataCell *noDataCell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseReportNoDataCellID"];
    if (indexPath.section == 0) {
        if (self.courseWareList.count==0) {
            return noDataCell;
        }
        OCCourseDetailCouserRourseCell *cell = [OCCourseDetailCouserRourseCell initWithCourseRourseTableView:tableView cellForAtIndexPath:indexPath];
        cell.couseRourseDataArr = self.courseWareList;
        cell.delegate = self;
        self.couseRourseCell = cell;
        return cell;
        
    }else if (indexPath.section == 1){
        if ([self.myGroupDict[@"id"] integerValue]==0) {
            return noDataCell;
        }
        OCCourseDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseDetailCommonCellID"];
        NSDictionary *dict = self.myGroupDict;
        cell.titleLab.text = dict[@"name"];
        cell.subTitleLab.text = @"课堂得分";
        return cell;
    }else if (indexPath.section == 2){
        if (self.questionList.count == 0) {
            return noDataCell;
        }
        OCCourseProblemCell *cell = [OCCourseProblemCell initWithCourseProblemTableView:tableView cellForAtIndexPath:indexPath];
        cell.courseProblemArr = self.questionList;
        self.problemCell = cell;
        return cell;
    }else if (indexPath.section == 3){
        if (self.discussList.count == 0) {
            return noDataCell;
        }
        NSDictionary *dict = self.discussList[indexPath.row];
        OCCourseDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseDetailCommonCellID"];
        cell.titleLab.text = dict[@"name"];
        cell.subTitleLab.text = @"查看所有发言";
        return cell;
    }else if (indexPath.section == 4){
        OCCourseCallCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseCallCountCellID"];
        cell.dataDict = self.dataDict[@"rollCall"];
        return cell;
    }
    
    
    static NSString *indentitder = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentitder];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentitder];
    }
    cell.textLabel.text = @"hello world";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if ([self.myGroupDict[@"id"] integerValue]!=0) {
            OCCourseGroupViewController *vc = [[OCCourseGroupViewController alloc] init];
            vc.tempDict = self.myGroupDict;
            vc.lessonID = self.lessonModel.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 3){
        if (self.discussList.count != 0) {
            OCCourseDiscussViewController *vc = [[OCCourseDiscussViewController alloc] init];
            vc.tempDict = self.discussList[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (self.questionList.count != 0) {
            OCCourseReportViewController *vc = [[OCCourseReportViewController alloc] init];
            vc.dataModel = self.lessonModel;
            vc.tempDict = self.questionList[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.courseWareList.count==0) {
            return 79;
        }
        return self.couseRourseCell.cellH;
    }else if (indexPath.section == 1){
        if ([self.myGroupDict[@"id"] integerValue]==0) {
            return 79;
        }
        return 88;
    }else if (indexPath.section == 2){
        if (self.questionList.count==0) {
            return 79;
        }
        return self.problemCell.cellH;
    }else if (indexPath.section == 3){
        if (self.discussList.count==0) {
            return 79;
        }
        return 64*FITWIDTH;
    }else if (indexPath.section == 4){
        return 132*FITWIDTH;
    }
    return 44;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView viewWithBgColor:self.mainBackColor frame:Rect(0, 0, kViewW, 41*FITWIDTH)];
    
    UILabel *titleLab = [UILabel labelWithText:self.headTitleArr[section] font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20, 23*FITWIDTH, 120*FITWIDTH, 18*FITWIDTH)];
    titleLab.font = [UIFont boldSystemFontOfSize:18*FITWIDTH];
    [headView addSubview:titleLab];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41*FITWIDTH;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat value = offsetY / 88*FITWIDTH;
    if (value >= 1) {
        self.navigationBarBGColor = 1;
    }else{
        self.navigationBarBGColor = value;
    }
    
    self.ts_navgationBar.titleLabel.textColor = value < 0.5 ? WHITE : TEXT_COLOR_BLACK;
    self.ts_navgationBar.backButton.image = value < 0.5 ? @"common_btn_back_white" : @"common_btn_back_black";
    self.ts_navgationBar.backgroundColor = RGBA(255, 255, 255, self.navigationBarBGColor);
}

#pragma mark - cell delegate
-(void)courseWareClickWithWareDict:(OCCourseWareModel *)dataModel{
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:dataModel.url.lastPathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [self openFileWithPath:filePath];
    if ([fileManager fileExistsAtPath:filePath]) {
        [self openFileWithPath:filePath];
    }else{
        Weak;
        [MBProgressHUD showMessage:@""];
        [APPRequest downloadFileWithFileName:dataModel.name filePath:filePath requestUrlStr:dataModel.url success:^(id responseObject) {
            [MBProgressHUD hideHUD];
            [wself openFileWithPath:responseObject];
        }];
    }
    
    
}

-(void)openFileWithPath:(NSString *)pathStr{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    vc.urlStr1 = pathStr;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络请求
-(void)requestLessonReport{
    
    NSString *urlStr = NSStringFormat(@"%@/%@v1/lesson/report/%ld/%@",kURL,APIInteractiveURl,self.lessonModel.ID,[kUserDefaults valueForKey:@"signClazzId"]);
    Weak;
    [APPRequest getRequestWithUrl:urlStr parameters:nil success:^(id responseObject) {
        wself.dataDict = responseObject;
        
        wself.courseWareList = [OCCourseWareModel objectArrayWithKeyValuesArray:wself.dataDict[@"courseWareList"]];
        wself.myGroupDict = wself.dataDict[@"myGroup"];
        wself.questionList = wself.dataDict[@"questionList"];
        wself.discussList = wself.dataDict[@"discusstList"];
        [wself setupTableView];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

@end
