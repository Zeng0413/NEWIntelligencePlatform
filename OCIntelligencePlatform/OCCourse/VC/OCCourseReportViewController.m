//
//  OCCourseReportViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseReportViewController.h"
#import "OCCourseReportHeadView.h"
#import "OCCourseReportModel.h"
#import "OCChooseTypeSubjectCell.h"
#import "OCSolutionTypeQuestionCell.h"
#import "OCQuickChooseAnswerCell.h"
#import "OCLessonQuestionAllModel.h"
#import "OCSubObjQuestionModel.h"
@interface OCCourseReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) OCCourseReportHeadView *headView;
@property (assign, nonatomic) OCChooseTypeSubjectCell *subjectCell;
@property (assign, nonatomic) OCQuickChooseAnswerCell *quickChooseCell;
@property (assign, nonatomic) OCSolutionTypeQuestionCell *QuestionCell;

@property (strong, nonatomic) OCCourseReportModel *reportModel;
@property (strong, nonatomic) OCLessonQuestionAllModel *subjectModel;

@property (strong, nonatomic) NSMutableArray *subjDataArray;
@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation OCCourseReportViewController

-(NSMutableArray *)subjDataArray{
    if (!_subjDataArray) {
        _subjDataArray = [NSMutableArray array];
    }
    return _subjDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"课堂答题" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
//    self.dataDict = @{@"score": @(5), @"objCorrectCount": @(2), @"objErrorCount":@(3), @"objNoAnswerCount":@(0), @"objCount":@(5), @"subjAnswerCount":@(2), @"subjNoAnswerCount":@(0), @"subjCount":@(5), @"name":@"adc", @"lessonId":@(4),
//                      @"objList" : @[@{@"answer":@(1), @"headTitle":@"", @"id":@(2), @"imgsList":@[], @"score":@(2), @"title":@"人类大约能活多少岁？", @"type":@(1), @"userAnswer":@"3",
//                        @"optionList":@[@{@"opKey": @"A", @"opValue": @"60", @"correct": @"0", @"optionId": @"1"},
//                                        @{@"opKey": @"B", @"opValue": @"70", @"correct": @"0", @"optionId": @"2"},
//                                        @{@"opKey": @"C", @"opValue": @"80", @"correct": @"1", @"optionId": @"3"},
//                                        @{@"opKey": @"D", @"opValue": @"90", @"correct": @"0", @"optionId": @"4"}
//                                       ]},
//                                     @{@"answer":@(1), @"headTitle":@"", @"id":@(2), @"imgsList":@[], @"score":@(4), @"title":@"什么动物是四条腿？", @"type":@(2), @"userAnswer":@"1,2,3,4,5,6",
//                                       @"optionList":@[@{@"opKey": @"A", @"opValue": @"小鸡", @"correct": @"0", @"optionId": @"1"},
//                                                       @{@"opKey": @"B", @"opValue": @"小狗", @"correct": @"1", @"optionId": @"2"},
//                                                       @{@"opKey": @"C", @"opValue": @"小猫", @"correct": @"1", @"optionId": @"3"},
//                                                       @{@"opKey": @"D", @"opValue": @"小猪", @"correct": @"1", @"optionId": @"4"},
//                                                       @{@"opKey": @"E", @"opValue": @"鸭子", @"correct": @"0", @"optionId": @"5"},
//                                                       @{@"opKey": @"D", @"opValue": @"老虎", @"correct": @"1", @"optionId": @"6"}
//                                                       ]},
//                                     @{@"answer":@(1), @"headTitle":@"", @"id":@(2), @"imgsList":@[], @"score":@(4), @"title":@"科比单场最高得分是81分?", @"type":@(3), @"userAnswer":@"2",
//                                       @"optionList":@[@{@"opKey": @"A", @"opValue": @"对", @"correct": @"1", @"optionId": @"1"},
//                                                       @{@"opKey": @"B", @"opValue": @"错", @"correct": @"0", @"optionId": @"2"}]}
//                                     ],
//                      @"subjList" : @[@{@"allowUpload":@(1), @"answer":@(1), @"answerContent":@"科比在对阵猛龙的比赛当中得到81分,科比在对阵猛龙的比赛当中得到81分,科比在对阵猛龙的比赛当中得到81分,科比在对阵猛龙的比赛当中得到81分,科比在对阵猛龙的比赛当中得到81分,科比在对阵猛龙的比赛当中得到81分", @"headTitle":@"", @"id":@"12", @"imgsList":@[], @"score":@"12", @"title":@"科比单场最高得分是多少?", @"type":@"1"}]
//                      };
//    NSArray *objArr = self.dataDict[@"objList"];
//    NSArray *subjArr = self.dataDict[@"subjList"];
//    for (NSDictionary *dic in objArr) {
//        OCSubObjQuestionModel *model = [OCSubObjQuestionModel objectWithKeyValues:dic];
//        [self.subjDataArray addObject:model];
//    }
//
//    for (NSDictionary *dic in subjArr) {
//        OCSubObjQuestionModel *model = [OCSubObjQuestionModel objectWithKeyValues:dic];
//        model.type = model.type + 3;
//        [self.subjDataArray addObject:model];
//    }
//
//    self.reportModel = [OCCourseReportModel objectWithKeyValues:self.dataDict];
//    self.subjectModel = [OCLessonQuestionAllModel objectWithKeyValues:self.dataDict];
    
    [self requestLessonQuestionData];
    
//    [self setupTableView];
}

-(void)setupTableView{
    self.headView = [[OCCourseReportHeadView alloc] initWithFrame:Rect(0, 0, kViewW, 190*FITWIDTH)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH-kNavH)];
    tableView.delegate = self;
    tableView.backgroundColor = kBACKCOLOR;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.tableHeaderView = self.headView;
    tableView.tableFooterView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, 48*FITWIDTH)];
    [self.view addSubview:tableView];
    
    self.headView.dataModel = self.subjectModel;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subjDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OCSubObjQuestionModel *model = self.subjDataArray[indexPath.row];
    if (model.type == 1 || model.type == 2 || model.type == 3) { // 单选 多选 判断
        OCChooseTypeSubjectCell *cell = [OCChooseTypeSubjectCell initWithOCChooseTypeSubjectWithTableView:tableView cellForAtIndexPath:indexPath];
        cell.currentPage = indexPath.row+1;
        cell.subjectCount = self.subjectModel.subjCount + self.subjectModel.objCount;
        cell.dataModel = model;
        self.subjectCell = cell;
        return cell;
    }else if (model.type == 4 || model.type == 5 || model.type == 6){ // 问答题 分组讨论 自由讨论
        OCSolutionTypeQuestionCell *cell = [OCSolutionTypeQuestionCell initWithOCSolutionTypeQuestionWithTableView:tableView cellForAtIndexPath:indexPath];
        cell.currentPage = indexPath.row+1;
        cell.subjectCount = self.subjectModel.subjCount + self.subjectModel.objCount;
        cell.dataModel = model;
        self.QuestionCell = cell;
        return cell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCSubObjQuestionModel *model = self.subjDataArray[indexPath.row];
    if (model.type==1 || model.type==2 || model.type==3) {
        return self.subjectCell.cellH;
    }else if(model.type == 4 || model.type == 5 || model.type == 6){
        return self.QuestionCell.cellH;
    }
    return 44;
    
}

#pragma mark - 网络请求
-(void)requestLessonQuestionData{
    NSString *urlStr = NSStringFormat(@"%@/%@v1/lesson/questions/all/%ld/%@",kURL,APIInteractiveURl,self.dataModel.ID,[kUserDefaults valueForKey:@"signClazzId"]);
    Weak;
    [APPRequest getRequestWithUrl:urlStr parameters:@{} success:^(id responseObject) {
        wself.dataDict = responseObject;
        NSArray *objArr = wself.dataDict[@"objList"];
        NSArray *subjArr = wself.dataDict[@"subjList"];
        for (NSDictionary *dic in objArr) {
            OCSubObjQuestionModel *model = [OCSubObjQuestionModel objectWithKeyValues:dic];
            [wself.subjDataArray addObject:model];
        }
        
        for (NSDictionary *dic in subjArr) {
            OCSubObjQuestionModel *model = [OCSubObjQuestionModel objectWithKeyValues:dic];
            model.type = model.type + 3;
            [wself.subjDataArray addObject:model];
        }
        
        wself.reportModel = [OCCourseReportModel objectWithKeyValues:wself.dataDict];
        wself.subjectModel = [OCLessonQuestionAllModel objectWithKeyValues:wself.dataDict];
        
        [wself setupTableView];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}
@end
