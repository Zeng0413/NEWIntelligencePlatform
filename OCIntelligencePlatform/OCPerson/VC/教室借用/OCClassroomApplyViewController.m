//
//  OCClassroomApplyViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomApplyViewController.h"
#import "lectureApplyView.h"
#import "OCDefaultClassroomApplyView.h"
#import "MultilevelDataHandler.h"
#import "TreeTableViewViewController.h"
@interface OCClassroomApplyViewController ()<OCDefaultClassroomApplyViewDelegate, lectureApplyViewDelegate>

@property (strong, nonatomic) UIButton *selectedBtn;
@property (strong, nonatomic) UIScrollView *scrollview;
@property (strong, nonatomic) lectureApplyView *lectureView;
@property (strong, nonatomic) OCDefaultClassroomApplyView *defClassroomlectureView;
@property (strong, nonatomic) NSArray *classroomList;

@property (copy, nonatomic) NSString *selectedXqStr;
@property (copy, nonatomic) NSString *lectureSelectedXqStr;
@property (copy, nonatomic) NSString *notifRangeIdStrs;
@property (copy, nonatomic) NSString *joinRangeIdStrs;

@property (assign, nonatomic) BOOL isLectureApply;
@end

@implementation OCClassroomApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"教室申请" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;
    
    [self setupTopView];

    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/clazz/list",kURL,APICollegeURL) parameters:@{} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        MultilevelDataHandler *dataHandler = [MultilevelDataHandler sharedHandler];
        NSMutableArray *tempArr = [NSMutableArray array];
        NSDictionary *tempDict = @{@"id":@"1234",@"list":responseObject,@"parentId":@(0),@"text":@"全校"};
        [tempArr insertObject:tempDict atIndex:0];
        [dataHandler setLevelKeys:@[@"list",@"list",@"list",@"list"]];
        [dataHandler setReDataSource:tempArr];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

#pragma mark - view figure
-(void)setupTopView{
    UILabel *titleLab = [UILabel labelWithText:@"申请类型：" font:15*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    titleLab.font = kBoldFont(15);
    titleLab.size = [titleLab.text sizeWithFont:kBoldFont(15)];
    titleLab.x = 20;
    titleLab.y = kNavH+12;
    [self.view addSubview:titleLab];
    
    NSArray *titleArr = @[@"普通申请", @"讲座申请"];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.x = MaxX(titleLab)+3;
        btn.size = CGSizeMake(75, 15);
        btn.y = titleLab.y + (btn.height+15)*i;
        [btn setTitleColor:TEXT_COLOR_BLACK];
        btn.titleFont = 15;
        [btn setImage:GetImage(@"course_btn_circle_nor") forState:UIControlStateNormal];
        [btn setImage:GetImage(@"course_btn_circle_sel") forState:UIControlStateDisabled];
        [btn setTitle:titleArr[i]];
        [btn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageLeft imageTitleSpacing:6];
        [btn addTarget:self action:@selector(selectedApplyType:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
        if (i==0) { 
            self.scrollview = [UIScrollView scrollViewWithBgColor:kBACKCOLOR frame:Rect(0, kNavH+57, kViewW, kViewH-(kNavH+57))];
            [self.view addSubview:self.scrollview];
            [self selectedApplyType:btn];
        }
        [self.view addSubview:btn];
    }
    
}

-(void)setContentView:(UIButton *)btn{
    
    Weak;
    [self.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if (btn.tag == 1) {
        self.isLectureApply = NO;
        self.defClassroomlectureView.hidden = NO;
        self.lectureView.hidden = YES;
        if (self.defClassroomlectureView) {
            return;
        }
        self.defClassroomlectureView = [OCDefaultClassroomApplyView defaultClassroomApplyView];
        self.defClassroomlectureView.delegate = self;
        self.defClassroomlectureView.block = ^(NSInteger type) {
            if (type == 0) {
                [wself requestClassroomListData];
            }else{
//                [BRDatePickerView showDatePickerWithTitle:nil dateType:BRDatePickerModeYMD defaultSelValue:nil resultBlock:^(NSString *selectValue) {
//                    wself.defClassroomlectureView.timeLab.text = selectValue;
//                    if (![wself.defClassroomlectureView.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
//                        [wself requestClassroomInfoTime];
//                    }
//                    
//                }];
                [BRDatePickerView showDatePickerWithTitle:nil dateType:BRDatePickerModeYMD defaultSelValue:nil minDate:[NSDate date] maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                    if (self.isLectureApply) {
                        self.lectureView.borrowDateLab.text = selectValue;
                        if (![self.lectureView.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
                            [self requestClassroomInfoTime];
                        }
                    }else{
                        self.defClassroomlectureView.timeLab.text = selectValue;
                        if (![self.defClassroomlectureView.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
                            [self requestClassroomInfoTime];
                        }
                    }
                }];
            }
        };
        self.defClassroomlectureView.frame = Rect(0, 0, kViewW, 620);
        [self.scrollview addSubview:self.defClassroomlectureView];
        self.scrollview.contentSize = CGSizeMake(0, self.defClassroomlectureView.height);
        
        
    }else{
        self.isLectureApply = YES;
        self.defClassroomlectureView.hidden = YES;
        self.lectureView.hidden = NO;
        if (self.lectureView) {
            return;
        }
        self.lectureView = [lectureApplyView creatLectureApplyView];
        self.lectureView.delegate = self;
        self.lectureView.notificationBlock = ^(NotificationType type) {
            if (type == messageType) {
                TreeTableViewViewController *vc = [[TreeTableViewViewController alloc] init];
                [vc returnBlock:^(NSArray * _Nonnull dataArr, NSInteger allSchool) {
                    NSString *str = @"";
                    NSString *idStr = @"";
                    for (int i = 0; i<dataArr.count; i++) {
                        NSDictionary *dict = dataArr[i];
                        if (i == 0) {
                            idStr = dict[@"id"];
                            str = dict[@"text"];
                        }else{
                            idStr = [idStr stringByAppendingString:NSStringFormat(@",%@",dict[@"id"])];
                            if (allSchool == 1) {
                                str = @"全校";
                            }else{
                                str = [str stringByAppendingString:NSStringFormat(@",%@",dict[@"text"])];
                            }
                            
                        }
                    }
                    wself.notifRangeIdStrs = idStr;
                    wself.lectureView.notificationRangeLab.text = str.length == 0?@"点击选择":str;
                }];
                [wself.navigationController pushViewController:vc animated:YES];
            }else{
                TreeTableViewViewController *vc = [[TreeTableViewViewController alloc] init];
                [vc returnBlock:^(NSArray * _Nonnull dataArr, NSInteger allSchool) {
                    NSString *str = @"";
                    NSString *idStr = @"";
                    for (int i = 0; i<dataArr.count; i++) {
                        NSDictionary *dict = dataArr[i];
                        if (i == 0) {
                            idStr = dict[@"id"];
                            str = dict[@"text"];
                        }else{
                            idStr = [idStr stringByAppendingString:NSStringFormat(@",%@",dict[@"id"])];
                            if (allSchool == 1) {
                                str = @"全校";
                            }else{
                                str = [str stringByAppendingString:NSStringFormat(@",%@",dict[@"text"])];
                            }
                        }
                    }
                    wself.joinRangeIdStrs = idStr;
                    wself.lectureView.joinRangeLab.text = str.length == 0?@"点击选择":str;
                }];
                [wself.navigationController pushViewController:vc animated:YES];
            }
            
        };
        self.lectureView.frame = Rect(0, 0, kViewW, 883);
        [self.scrollview addSubview:self.lectureView];
        self.scrollview.contentSize = CGSizeMake(0, self.lectureView.height);
        
    }
}

#pragma mark - defaultClassroomApplyView delegate
-(void)defaultClassroomSubmitApplyWithApplyClassroomName:(NSString *)classroomName withDateInterval:(NSString *)timeInterval withBorrowTimes:(NSString *)times withReason:(NSString *)reasonStr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"campus"] = self.selectedXqStr;
    params[@"date"] = timeInterval;
    params[@"reason"] = reasonStr;
    params[@"roomCode"] = classroomName;
    params[@"sections"] = times;
    
    Weak;
    [MBProgressHUD showMessage:@""];
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/classroom/borrow/normal",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        NSInteger status = [responseObject integerValue];
        if (status == 1) {
            [MBProgressHUD showSuccess:@"申请成功"];
            [wself.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}




#pragma mark - lectureApply delegate
-(void)classroomOrDateClickWithType:(NSInteger)type{
    if (type == 1) {
        [self requestClassroomListData];
    }else{
        [BRDatePickerView showDatePickerWithTitle:nil dateType:BRDatePickerModeYMD defaultSelValue:nil minDate:[NSDate date] maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            if (self.isLectureApply) {
                self.lectureView.borrowDateLab.text = selectValue;
                if (![self.lectureView.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
                    [self requestClassroomInfoTime];
                }
            }else{
                self.defClassroomlectureView.timeLab.text = selectValue;
                if (![self.defClassroomlectureView.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
                    [self requestClassroomInfoTime];
                }
            }
        }];
    }
}

-(void)lectureApplySubmitWithLectureName:(NSString *)lectureName withSpeaker:(NSString *)speaker withDec:(NSString *)dec isLive:(NSInteger)liveStatus isSaveVideo:(NSInteger)saveVideoStatus notificationRange:(NSString *)notifRange joinRange:(NSInteger)joinRange withApplyClassroom:(NSString *)classroomName withDateInterval:(NSString *)timeInterval withBorrowTimes:(NSString *)times{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"campus"] = self.lectureSelectedXqStr;
    params[@"date"] = timeInterval;
    params[@"informRange"] = self.joinRangeIdStrs;
    params[@"intro"] = dec;
    params[@"isLive"] = liveStatus?@(1):@(0);
    params[@"isSave"] = saveVideoStatus?@(1):@(0);
    params[@"joinRange"] = self.notifRangeIdStrs;
    params[@"joinType"] = @(4);
    params[@"lectureName"] = lectureName;
    params[@"roomCode"] = classroomName;
    params[@"sections"] = times;
    params[@"speaker"] = speaker;

    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/classroom/borrow/lecture",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        NSInteger status = [responseObject integerValue];
        if (status == 1) {
            [MBProgressHUD showSuccess:@"申请成功"];
            [wself.navigationController popViewControllerAnimated:YES];
        }
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];

}
#pragma mark - action method
-(void)selectedApplyType:(UIButton *)button{
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    [self setContentView:button];

}

#pragma mark - 网络请求
-(void)requestClassroomInfoTime{
    [MBProgressHUD showMessage:@""];
    Weak;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.isLectureApply) {
        params[@"date"] = NSStringFormat(@"%ld",[NSString gettimeStamp:self.lectureView.borrowDateLab.text]);
        params[@"roomCode"] = self.lectureView.applyClassroomLab.text;
    }else{
        params[@"date"] = NSStringFormat(@"%ld",[NSString gettimeStamp:self.defClassroomlectureView.timeLab.text]);
        params[@"roomCode"] = [[self.defClassroomlectureView.applyClassroomLab.text componentsSeparatedByString:@"-"] lastObject];
    }
    params[@"campus"] = self.selectedXqStr;
    
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/classroominfo/sections",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        if (wself.isLectureApply) {
            wself.lectureView.isCanBtnClick = YES;
            [wself.lectureView refreshBtnsStatus:responseObject];
        }else{
            [wself.defClassroomlectureView refreshBtnsStatus:responseObject];
            wself.defClassroomlectureView.isCanBtnClick = YES;
        }
//
//        NSMutableArray *temp = [responseObject mutableCopy];
//        temp[2] = @(1);
//        responseObject = [temp copy];
        
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)requestClassroomListData{
    Weak;
    if (self.classroomList.count==0) {
        [MBProgressHUD showMessage:@""];
        [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/classroominfo/classroom",kURL,APICollegeURL) parameters:@{} success:^(id responseObject) {
            [BRAddressPickerView showClassroomPickerWithShowType:BRClassroomPickerMode dataSource:responseObject defaultSelected:nil isAutoSelect:YES themeColor:nil resultBlock:^(xqModel *xq, jxlModel *jxl, jsModel *js) {
                if (self.isLectureApply) {
                    wself.lectureView.applyClassroomLab.text = NSStringFormat(@"%@-%@",jxl.buildingName,js.jsName);
                    wself.lectureSelectedXqStr = xq.campus;
                    if (![wself.lectureView.borrowDateLab.text isEqualToString:@"点击选择时间"]) {
                        [wself requestClassroomInfoTime];
                    }

                }else{
                    wself.defClassroomlectureView.applyClassroomLab.text = NSStringFormat(@"%@-%@",jxl.buildingName,js.jsName);
                    wself.selectedXqStr = xq.campus;
                    if (![wself.defClassroomlectureView.timeLab.text isEqualToString:@"点击选择时间"]) {
                        [wself requestClassroomInfoTime];
                    }
                }
                
                
            } cancelBlock:^{
                
            }];
            //        NSLog(@"%@",responseObject);
            wself.classroomList = responseObject;
            
        } stateError:^(id responseObject) {
        } failure:^(NSError *error) {
        } viewController:self needCache:NO];
    }else{
        [BRAddressPickerView showClassroomPickerWithShowType:BRClassroomPickerMode dataSource:self.classroomList defaultSelected:nil isAutoSelect:YES themeColor:nil resultBlock:^(xqModel *xq, jxlModel *jxl, jsModel *js) {
            if (self.isLectureApply) {
                wself.lectureView.applyClassroomLab.text = NSStringFormat(@"%@-%@",jxl.buildingName,js.jsName);
                wself.lectureSelectedXqStr = xq.campus;
                if (![wself.lectureView.borrowDateLab.text isEqualToString:@"点击选择时间"]) {
                    [wself requestClassroomInfoTime];
                }
            }else{
                wself.defClassroomlectureView.applyClassroomLab.text = NSStringFormat(@"%@-%@",jxl.buildingName,js.jsName);
                wself.selectedXqStr = xq.campus;
                if (![wself.defClassroomlectureView.timeLab.text isEqualToString:@"点击选择时间"]) {
                    [wself requestClassroomInfoTime];
                }
            }

            
        } cancelBlock:^{
            
        }];
    }
    
}
@end
