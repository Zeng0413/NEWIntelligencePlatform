//
//  OCClassroomDetailViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomDetailViewController.h"
#import "OCClassSheetClassroomModel.h"
#import "OCClassSheetCell.h"
#import "OCClassroomPushView.h"
#import "OCPlayVideoViewController.h"
#import "OCClassSheetSubject.h"
@interface OCClassroomDetailViewController ()<UITableViewDelegate, UITableViewDataSource, OCClassSheetCellDelegate>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OCClassroomPushView *pushView;
@property (strong, nonatomic) NSArray *timeArr;
@end

@implementation OCClassroomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBACKCOLOR;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"课表详情" rightTitle:@"" rightAction:^{
        
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;

    if (self.currentCourseSheetArr.count>0) {
        NSDictionary *dataDict = [self.currentCourseSheetArr firstObject];
        NSInteger currentIndex = [dataDict[@"week"] integerValue];
        NSArray *listArr = dataDict[@"list"];
        NSArray *weekArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 0; i<weekArr.count; i++) {
            OCClassSheetClassroomModel *model = [[OCClassSheetClassroomModel alloc] init];
            model.roomCode = weekArr[i];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            if (i+1 == currentIndex) {
                for (NSDictionary *dict in listArr) {
                    OCClassSheetSubject *subjectModel = [[OCClassSheetSubject alloc] init];
                    subjectModel.mergeSection = dict[@"mergeSection"];
                    NSString *classroomStr = dict[@"classroom"];
                    subjectModel.lessonCode = classroomStr.length==0?@"" : classroomStr;
                    subjectModel.oldLocation = [dict[@"oldLocation"] stringValue];
                    subjectModel.lessonName = dict[@"name"];
                    subjectModel.teacher = dict[@"teacher"];
                    subjectModel.time = dict[@"time"];
                    subjectModel.weeks = dict[@"weeks"];
                    [tempArr addObject:subjectModel];
                }
            }else{
                for (int j = 0; j < 6; j++) {
                    OCClassSheetSubject *subjectModel = [[OCClassSheetSubject alloc] init];
                    subjectModel.mergeSection = @"2";
                    subjectModel.lessonCode = @"";
                    [tempArr addObject:subjectModel];
                }
            }
            model.times = [tempArr copy];
            [dataArray addObject:model];
        }
        self.dataArray = [dataArray copy];
    }else{
        [self reloadClassroomDetailData];
    }
    
    [self setupUI];
}

#pragma mark - view figure
-(void)setupUI{
    NSArray *titleArr = @[@"一大节",@"二大节",@"三大节",@"四大节",@"五大节",@"六大节"];
    for (int i = 0; i<titleArr.count; i++) {
        UILabel *lable = [UILabel labelWithText:titleArr[i] font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
        lable.size = CGSizeMake((kViewW - 73*FITWIDTH - 20*FITWIDTH - (6*FITWIDTH*(titleArr.count-1)))/titleArr.count, 48*FITWIDTH);
        lable.x = 73*FITWIDTH + (lable.width + 6*FITWIDTH)*i;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.y = kNavH;
        [self.view addSubview:lable];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH+48*FITWIDTH, kViewW, kViewH-(kNavH+48*FITWIDTH))];
    self.tableView.backgroundColor = kBACKCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 72*FITWIDTH;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCClassSheetCell *cell = [OCClassSheetCell initWithOCClassSheetCellTableView:tableView cellForAtIndexPath:indexPath];
    cell.timeArray = self.timeArr;
    cell.classroomModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - cell delegate
-(void)chooseClaseeSheetCourseWithModel:(OCClassSheetSubject *)model{
    BOOL flag = [OCPublicMethodManager checkUserPermission:OCUserPermissionTourClass];

    NSDictionary *startTimeDict = self.timeArr[[model.section integerValue]-1];
    NSDictionary *endTimeDict = self.timeArr[[model.section integerValue]+[model.mergeSection integerValue]-2];

    self.pushView = [OCClassroomPushView creatClassroomPushView];
    self.pushView.frame = self.view.bounds;
    if (model.weeks.length==0) {
        self.pushView.timeLab.text = NSStringFormat(@"时间：%@-%@",startTimeDict[@"kssj"],endTimeDict[@"jssj"]);
        self.pushView.titleLab.text = NSStringFormat(@"%@校区-%@%@",self.campusModel.campus,model.roomName,model.roomCode);
    }else{
        self.pushView.timeLab.text = NSStringFormat(@"时间：%@",model.time);
        self.pushView.titleLab.text = NSStringFormat(@"%@校",model.lessonName);
    }
    if (model.isLive == 0) {
        self.pushView.videoStatusLab.text = @"无直播";
        self.pushView.videoStatusLab.textColor = TEXT_COLOR_GRAY;
//        flag = NO;
    }else{
        NSDate *nowDate = [NSDate date];
        NSInteger nowHourInt = nowDate.br_hour;
        NSInteger nowMinuteInt = nowDate.br_minute;
        NSDate *nowHourDate = [NSDate br_setHour:nowHourInt minute:nowMinuteInt];
        NSString *startHourInt = [[startTimeDict[@"kssj"] componentsSeparatedByString:@":"] firstObject];
        NSString *startMinuteInt = [[startTimeDict[@"kssj"] componentsSeparatedByString:@":"] lastObject];
        NSDate *startHourDate = [NSDate br_setHour:[startHourInt integerValue] minute:[startMinuteInt integerValue]];
        
        NSString *endHourInt = [[endTimeDict[@"jssj"] componentsSeparatedByString:@":"] firstObject];
        NSString *endMinuteInt = [[endTimeDict[@"jssj"] componentsSeparatedByString:@":"] lastObject];
        NSDate *endHourDate = [NSDate br_setHour:[endHourInt integerValue] minute:[endMinuteInt integerValue]];
        if ([OCPublicMethodManager date:nowHourDate isBetweenDate:startHourDate andDate:endHourDate]) {
            self.pushView.videoStatusLab.text = @"直播中 >";
            self.pushView.videoStatusLab.textColor = kAPPCOLOR;
        }else{
//            flag = NO;
            self.pushView.videoStatusLab.text = @"无直播";
            self.pushView.videoStatusLab.textColor = TEXT_COLOR_GRAY;
        }
        
    }
    
    self.pushView.subjectModel = model;
    if (flag) {
        self.pushView.tourCourseBtn.hidden = NO;
        self.pushView.backViewHLay.constant = 259;
    }else{
        self.pushView.tourCourseBtn.hidden = YES;
        self.pushView.backViewHLay.constant = 259 - 55;
    }
    
    self.pushView.contenBackVIew.layer.masksToBounds = YES;
    self.pushView.contenBackVIew.layer.cornerRadius = 3;
    
    Weak;
    self.pushView.block = ^{
        OCPlayVideoViewController *vc = [[OCPlayVideoViewController alloc] init];
        OCLiveVideoModel *liveModel = [[OCLiveVideoModel alloc] init];
        liveModel.title = model.lessonName;
        liveModel.speaker = model.teacher;
        
        vc.model = liveModel;
        vc.classSheetModel = model;
        vc.isTourClass = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
    self.pushView.liveBlock = ^(OCClassSheetSubject * _Nonnull model) {
        NSLog(@"%@",model);
    };
    [self.view addSubview:self.pushView];
}




#pragma mark - 网络请求
-(void)reloadClassroomDetailData{
    Weak;
    NSString *urlStr = [NSStringFormat(@"%@/%@v1/classroominfo/details/%@",kURL,APICollegeURL,self.campusModel.buildName) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [APPRequest getRequestWithUrl:urlStr parameters:@{} success:^(id responseObject) {
        wself.dataArray = [OCClassSheetClassroomModel objectArrayWithKeyValuesArray:responseObject];
        [wself requestSectionTime];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

// 获取节次时间
-(void)requestSectionTime{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/classroominfo/sectionTime/%@",kURL,APICollegeURL,self.campusModel.campus) parameters:@{} success:^(id responseObject) {
        wself.timeArr = responseObject;
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

@end
