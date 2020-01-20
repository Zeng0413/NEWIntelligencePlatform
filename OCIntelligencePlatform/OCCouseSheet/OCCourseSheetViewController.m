//
//  OCCourseSheetViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSheetViewController.h"
#import "OCClassroomListViewController.h"
#import "HMScannerController.h"
#import "OCCourseInteractionEnterViewController.h"
#import "OCCourseSheetModel.h"
#import "OCCourseSheetCell.h"
#import "OCCourseSheetModel.h"
#import "OCCourseSheetCalenderView.h"
#import "OCCourseSheetPushView.h"
#import "LXCalendarDayModel.h"
#import "OCCourseSheetSearchCell.h"
#import "OCSubmitWorkorderViewController.h"
#import "OCSearchCourseSheetModel.h"
#import "OCClassroomDetailViewController.h"
#import "JPUSHService.h"
#import "OCOrderSeatViewController.h"
#import "FSCalendar.h"

#import "newCalenderViewController.h"
@interface OCCourseSheetViewController ()<UITableViewDelegate, UITableViewDataSource, OCCourseSheetCellDelegate, UITextFieldDelegate, OCCourseSheetSearchCellDelegate, FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>
{
    void * _KVOContext;
}
@property (strong, nonatomic) NSMutableArray *sheetDataArr;
@property (strong, nonatomic) NSMutableArray *searchSheetArr;
@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) OCCourseSheetCell *sheetCell;

@property (assign, nonatomic) NSInteger currentTime;
@property (copy, nonatomic) NSString *currentTimeStr;

@property (strong, nonatomic) NSArray *courseSheetArr;


@property (strong, nonatomic) OCCourseSheetCalenderView *calenderView;

@property (strong, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

@property (strong, nonatomic) UIView *moreView;

@property (strong, nonatomic) UIImageView *arrowImg;


@property (strong, nonatomic) OCCourseSheetPushView *pushView;

@property (strong, nonatomic) UITextField *searchTextField;

@property (weak, nonatomic) UIButton *addBtn;

@property (weak, nonatomic) UIButton *cancelBtn;

@property (assign, nonatomic) BOOL isSearch;

@property (strong, nonatomic) LXCalendarDayModel *selectModel;

@property (strong, nonatomic) UILabel *dateLab;


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
 

@end

@implementation OCCourseSheetViewController

-(NSMutableArray *)sheetDataArr{
    if (!_sheetDataArr) {
        _sheetDataArr = [NSMutableArray array];
    }
    return _sheetDataArr;
}

-(NSMutableArray *)searchSheetArr{
    if (!_searchSheetArr) {
        _searchSheetArr = [NSMutableArray array];
    }
    return _searchSheetArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
    if (self.sheetDataArr.count==0) {
        NSString *isHasNetWorking = [kUserDefaults valueForKey:kNetWorkAlertStr];
            if ([isHasNetWorking integerValue] == 1) {
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"目前没有相关课程" detailStr:@"请好好预习和复习哦~"];
            }else{
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"哎呀，您的网络还在沉睡中" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    self.totalPage = 1;
    
    NSDate *nowDate = [NSDate date];
    self.selectModel = [[LXCalendarDayModel alloc] init];
    self.selectModel.year = nowDate.br_year;
    self.selectModel.month = nowDate.br_month;
    self.selectModel.day = nowDate.br_day;
    
    NSString *nowDateStr = [NSString getNowTime];
    NSInteger nowTime = [NSString gettimeStamp:nowDateStr];
    [self requestSheetDataWithTime:nowTime];
    self.currentTime = nowTime;
  
    self.view.backgroundColor = kBACKCOLOR;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle_:@""];
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;
    
    // 初始化日历
//    [self initCalendarView];
    

//
    [self setupHeadCalenderView];
//
//    [self setupSearchTopView];
//    [self setupTableView];
    // Do any additional setup after loading the view.
}


#pragma mark - view figure


-(void)setupHeadCalenderView{
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -kStatusH, kViewW, 230)];
    headBackView.backgroundColor = RGBA(12, 94, 210, 1);
    [self.view addSubview:headBackView];

    UIButton *tvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tvBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
    tvBtn.x = kViewW - 20*FITWIDTH - tvBtn.width;
    tvBtn.y =  kStatusH + 32*FITWIDTH;
    tvBtn.image = @"common_btn_tv_mini";
    [headBackView addSubview:tvBtn];

    UIButton *seatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seatBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
    seatBtn.x = CGRectGetMinX(tvBtn.frame) - 20*FITWIDTH - seatBtn.width;
    seatBtn.y = tvBtn.y;
    seatBtn.image = @"common_btn_seat_mini ";
    [headBackView addSubview:seatBtn];


    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
    scanBtn.x = CGRectGetMinX(seatBtn.frame) - 20*FITWIDTH - scanBtn.width;
    scanBtn.y = tvBtn.y;
    scanBtn.image = @"common_btn_scan_mini";
    [headBackView addSubview:scanBtn];

    UIView *searchBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
    searchBackView.x = 20*FITWIDTH;
    searchBackView.width = CGRectGetMinX(scanBtn.frame) - 24*FITWIDTH - 20*FITWIDTH;
    searchBackView.height = 30*FITWIDTH;
    searchBackView.centerY = scanBtn.centerY;
    searchBackView.layer.masksToBounds = YES;
    searchBackView.layer.cornerRadius = 3;
    searchBackView.userInteractionEnabled = YES;
    [headBackView addSubview:searchBackView];

    UIImageView *searchIconImg = [UIImageView imageViewWithImage:GetImage(@"common_btn_search") frame:CGRectZero];
    searchIconImg.x = 12*FITWIDTH;
    searchIconImg.size = CGSizeMake(14*FITWIDTH, 14*FITWIDTH);
    searchIconImg.centerY = searchBackView.height/2;
    [searchBackView addSubview:searchIconImg];

    self.searchTextField = [[UITextField alloc] initWithFrame:Rect(MaxX(searchIconImg)+7*FITWIDTH, 0, searchBackView.width - (MaxX(searchIconImg)+7*FITWIDTH), searchBackView.height)];
    self.searchTextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    self.searchTextField.delegate=self;
    self.searchTextField.placeholder = @"搜索";
    self.searchTextField.font = kFont(14);
//    [self.searchTextField setValue:RGBA(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBackView addSubview:self.searchTextField];

    self.dateLab = [UILabel labelWithText:@"2019-12-7" font:16*FITWIDTH textColor:RGBA(163, 201, 242, 1) frame:Rect(20*FITWIDTH, MaxY(searchBackView)+20*FITWIDTH, 200*FITWIDTH, 16*FITWIDTH)];
    self.dateLab.font = kBoldFont(16*FITWIDTH);
    [headBackView addSubview:self.dateLab];

    NSArray *weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    for (int i = 0; i<weekArr.count; i++) {
        CGFloat weekW = kViewW/weekArr.count;
        UILabel *weekLab = [[UILabel alloc] initWithFrame:CGRectMake(weekW*i, CGRectGetMaxY(self.dateLab.frame), weekW, 37*FITWIDTH)];
       weekLab.text = weekArr[i];
       weekLab.font = [UIFont systemFontOfSize:12*FITWIDTH];
       weekLab.textColor = RGBA(208, 227, 248, 1);
        weekLab.textAlignment = NSTextAlignmentCenter;
       [headBackView addSubview:weekLab];

        headBackView.height = MaxY(weekLab);
    }
    
    self.calendar = [[FSCalendar alloc] initWithFrame:Rect(0, MaxY(headBackView), kViewW, 199*FITWIDTH)];
    
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    self.calendar.scope = FSCalendarScopeWeek;
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    
     [self.calendar selectDate:[NSDate date] scrollToDate:YES];
//    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    [self.view addSubview:self.calendar];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.calendar addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    self.moreView = [UIView viewWithBgColor:WHITE frame:Rect(0, MaxY(self.calendar), kViewW, 23*FITWIDTH)];
//    [self.moreView addGestureRecognizer:panGesture];
    self.arrowImg = [UIImageView imageViewWithImage:GetImage(@"home_icon_arrow") frame:CGRectZero];
    self.arrowImg.size = CGSizeMake(24*FITWIDTH, 11*FITWIDTH);
    self.arrowImg.centerX = kViewW/2;
    self.arrowImg.y = 6*FITWIDTH;
    self.arrowImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *arrowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowClick)];
    [self.arrowImg addGestureRecognizer:arrowTap];
    [self.moreView addSubview:self.arrowImg];
    [self.view addSubview:self.moreView];
    
    [self setupTableView];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)setupSearchTopView{
    
    
    UIButton *addBtn = [UIButton buttonWithTitle:@"" titleColor:nil backgroundColor:nil font:0 image:@"common_btn_plus" frame:CGRectZero];
    addBtn.x = kViewW - 20*FITWIDTH - 26;
    addBtn.size = CGSizeMake(26, 26);
    addBtn.y = kStatusH + 12;
    [addBtn addTarget:self action:@selector(moreClick)];
    [self.ts_navgationBar addSubview:addBtn];
    self.addBtn = addBtn;
    
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kAPPCOLOR backgroundColor:CLEAR font:14 image:@"" frame:CGRectZero];
    [cancelBtn addTarget:self action:@selector(cancelClick)];
    cancelBtn.size = CGSizeMake(26+20+11, 26);
    cancelBtn.x = kViewW - cancelBtn.width;
    cancelBtn.y = kStatusH + 12;
    cancelBtn.hidden = YES;
    [self.ts_navgationBar addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    UIView *searchBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
    searchBackView.x = 20*FITWIDTH;
    searchBackView.width = CGRectGetMinX(addBtn.frame) - 11*FITWIDTH - 20*FITWIDTH;
    searchBackView.height = 30;
    searchBackView.centerY = addBtn.centerY;
    searchBackView.layer.masksToBounds = YES;
    searchBackView.layer.cornerRadius = 3;
    searchBackView.userInteractionEnabled = YES;
    [self.ts_navgationBar addSubview:searchBackView];
    
    UIImageView *searchIconImg = [UIImageView imageViewWithImage:GetImage(@"common_btn_search") frame:CGRectZero];
    searchIconImg.x = 12*FITWIDTH;
    searchIconImg.size = CGSizeMake(14*FITWIDTH, 14*FITWIDTH);
    searchIconImg.centerY = searchBackView.height/2;
    [searchBackView addSubview:searchIconImg];

    self.searchTextField = [[UITextField alloc] initWithFrame:Rect(MaxX(searchIconImg)+7*FITWIDTH, 0, searchBackView.width - (MaxX(searchIconImg)+7*FITWIDTH), searchBackView.height)];
    self.searchTextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    self.searchTextField.delegate=self;
    self.searchTextField.placeholder = @"搜索";
    self.searchTextField.font = kFont(14);
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBackView addSubview:self.searchTextField];

}
-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, MaxY(self.moreView), kViewW, kViewH - MaxY(self.moreView) - kDockH)];
//    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH - kDockH)];
    tableView.backgroundColor = kBACKCOLOR;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    UIView *footView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, 15*FITWIDTH)];
    tableView.tableFooterView = footView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    
  
    NSString *isHasNetWorking = [kUserDefaults valueForKey:kNetWorkAlertStr];


        if ([isHasNetWorking integerValue] == 1) {
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"目前没有相关课程" detailStr:@"请好好预习和复习哦~"];
        }else{
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"哎呀，您的网络还在沉睡中" detailStr:@"请找个开阔的的地方再试试哦～"];
        }
    
    
    tableView.ly_emptyView.detailLabFont = kFont(11);
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;

}
#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
//    if (shouldBegin) {
//        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
//        switch (self.calendar.scope) {
//            case FSCalendarScopeMonth:
//                return velocity.y < 0;
//            case FSCalendarScopeWeek:
//                return velocity.y > 0;
//        }
//    }
//    return shouldBegin;
//}

#pragma mark - FSCalender delegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    self.moreView.frame = Rect(0, MaxY(calendar), kViewW, 23*FITWIDTH);
    self.tableView.frame = Rect(0, MaxY(self.moreView), kViewW, kViewH - MaxY(self.moreView) - kDockH);
    if (self.calendar.scope == FSCalendarScopeWeek) {
        self.arrowImg.image = GetImage(@"home_icon_arrow_down");
    }else{
        self.arrowImg.image = GetImage(@"home_icon_arrow");
    }
    // Do other updates here
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchSheetArr.count;
    }else{
        return self.sheetDataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        OCCourseSheetSearchCell *cell = [OCCourseSheetSearchCell initOCCourseSheetSearchCellWithTableView:tableView cellForAtIndexPath:indexPath];
        cell.sheetModel = self.searchSheetArr[indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        OCCourseSheetCell *cell = [OCCourseSheetCell initWithOCCourseSheetCellTableView:tableView cellForAtIndexPath:indexPath];
        cell.sheetModel = self.sheetDataArr[indexPath.row];
        cell.delegate = self;
        self.sheetCell = cell;
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        return 200*FITWIDTH;
    }else{
        return self.sheetCell.cellH;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.calendar.scope == FSCalendarScopeMonth) {
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
    } else {
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
    }
//    newCalenderViewController *vc = [[newCalenderViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - cell delegate
-(void)selectedCell:(OCCourseSheetCell *)cell withIsOpen:(BOOL)isOpen{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OCCourseSheetModel *model = self.sheetDataArr[indexPath.row];
    model.isOpen = !isOpen;
    
    [self.tableView reloadData];
}

-(void)courseSheetLookWithModel:(OCSearchCourseSheetModel *)model{
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/timetable/%@",kURL,APICollegeURL,model.ID) parameters:@{}
                          success:^(id responseObject) {
                              BOOL flag = [OCPublicMethodManager checkUserPermission:OCUserPermissionCourseSheetDetail];
                              if (flag) {
                                  OCClassroomDetailViewController *vc = [[OCClassroomDetailViewController alloc] init];
                                  vc.currentCourseSheetArr = responseObject;
                                  [wself.navigationController pushViewController:vc animated:YES];
                              }else{
                                  [MBProgressHUD showText:PermissionAlertString];
                              } 
                          } stateError:^(id responseObject) {
                          } failure:^(NSError *error) {
                          } viewController:self needCache:NO];
}

-(void)courseSheetCollectWithModel:(OCSearchCourseSheetModel *)model withForCell:(OCCourseSheetSearchCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [MBProgressHUD showMessage:@""];
    if (model.isCollect == 0) { // 收藏课表
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"code"] = model.courseCode;
        params[@"name"] = model.name;
        params[@"tbId"] = model.ID;
        Weak;
        [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/collect/timetable",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
            if (responseObject) {
                if (model.isCollect == 0) {
                    model.isCollect = 1;
                }else{
                    model.isCollect = 0;
                }
                [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            NSLog(@"%@",responseObject);
        } stateError:^(id responseObject) {
        } failure:^(NSError *error) {
        } viewController:self];
    }else{ // 取消收藏课表
        Weak;
        [APPRequest deleteRequestWithURLStr:NSStringFormat(@"%@/%@v1/collect/timetable/%@",kURL,APICollegeURL,model.ID) paramDic:@{} success:^(id responseObject) {
            if (responseObject) {
                if (model.isCollect == 0) {
                    model.isCollect = 1;
                }else{
                    model.isCollect = 0;
                }
                [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            NSLog(@"%@",responseObject);
        } error:^(id responseObject) {
        } failure:^(NSError *error) {
        } controller:self];
    }
    
}

-(void)courseSheetCollectWithModel:(OCSearchCourseSheetModel *)model{
    
}

-(void)toScannerVc{
    
    Weak;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        [wself studentSignRequestWithToken:stringValue];
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}


#pragma mark - UITextField实时监听获取输入内容，中文状态去除预输入拼音
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        self.page = 1;
        [self requestSearchCourseSheetData:textField.text];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tableView.mj_footer.hidden = NO;
    self.isSearch = YES;
    [self.tableView reloadData];
    self.addBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.page = 1;
    [self requestSearchCourseSheetData:textField.text];

}


#pragma mark - action method
-(void)noticePullRefresh{
    if (self.isSearch) {
        self.page = 1;
        [self requestSearchCourseSheetData:self.searchTextField.text];
    }else{
        [self requestSheetDataWithTime:self.currentTime];
    }
}

- (void)noticeDropRefresh {
    if (self.isSearch) {
        _page ++;
        if (_page > _totalPage) {
            _page --;
            SLEndRefreshing(_tableView);
            return;
        }
        [self requestSearchCourseSheetData:self.searchTextField.text];
    }
    
}

-(void)cancelClick{
    self.tableView.mj_footer.hidden = YES;
    self.isSearch = NO;
    [self.tableView reloadData];
    self.addBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.searchTextField.text = @"";
    [self.view endEditing:YES];
}

-(void)moreClick{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBarBadge" object:nil];

//    OCOrderSeatViewController *vc = [[OCOrderSeatViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.pushView = [[OCCourseSheetPushView alloc] initWithFrame:self.view.bounds];
    Weak;
    self.pushView.block = ^(NSInteger type) {
        if (type == 0) { // 扫一扫
//            OCSubmitWorkorderViewController *vc = [[OCSubmitWorkorderViewController alloc] init];
//            [wself.navigationController pushViewController:vc animated:YES];
            [wself toScannerVc];
        }else{ // 日期
            [wself calenderClick];
        }
    };
    [keyWindow addSubview:self.pushView];

}

-(void)calenderClick{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.calenderView = [[OCCourseSheetCalenderView alloc] initWithFrame:self.view.bounds];
    self.calenderView.selectedDateModel = self.selectModel;
    NSArray *tempArr = [self.currentTimeStr componentsSeparatedByString:@"-"];
    if (tempArr.count>0) {
        self.calenderView.selectedDateModel.year = [[tempArr firstObject] integerValue];
        self.calenderView.selectedDateModel.month = [tempArr[1] integerValue];
        self.calenderView.selectedDateModel.day = [[tempArr lastObject] integerValue];
    }else{
        NSString *nowTimeStr = [NSString getNowTime];
        NSArray *temp = [nowTimeStr componentsSeparatedByString:@"-"];
        self.calenderView.selectedDateModel.year = [[temp firstObject] integerValue];
        self.calenderView.selectedDateModel.month = [temp[1] integerValue];
        self.calenderView.selectedDateModel.day = [[temp lastObject] integerValue];
    }
    Weak;
    self.calenderView.block = ^(LXCalendarDayModel * _Nonnull dateModel) {
        wself.selectModel = dateModel;
        NSString *dateStr = NSStringFormat(@"%ld-%ld-%ld",dateModel.year,dateModel.month,dateModel.day);
        wself.currentTimeStr = dateStr;
        long time = [NSString gettimeStamp:dateStr];
        wself.currentTime = time;
        [wself.tableView.mj_header beginRefreshing];
    };
    [keyWindow addSubview:self.calenderView];
}

#pragma mark - 网络请求
-(void)studentSignRequestWithToken:(NSString *)signToken{
    [MBProgressHUD showMessage:@""];
    NSString *userId = [kUserDefaults valueForKey:@"userId"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sign"] = @"1";
    params[@"studentId"] = userId;
    params[@"token"] = signToken;
    params[@"type"] = @"1";
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/sign",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        OCCourseInteractionEnterViewController *vc = [[OCCourseInteractionEnterViewController alloc] init];
        vc.signDict = responseObject;
        [kUserDefaults setValue:responseObject[@"clazzId"] forKey:@"signClazzId"];
        if (SINGLE.userModel.type == 1) {
            [JPUSHService addTags:[NSSet setWithObject:responseObject[@"clazzId"]] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                
            } seq:0];
        }
        [wself.navigationController pushViewController:vc animated:YES];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)requestSheetDataWithTime:(long)time{
    
    BOOL isTeacher = NO;
    for (NSDictionary *dict in SINGLE.userModel.roleList) {
        if ([dict[@"name"] isEqualToString:@"教师"]) {
            isTeacher = YES;
        }
    }
    
    
    if (isTeacher) { // 老师
        Weak;
        [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/timetable/teacher/%@/%ld",kURL,APICollegeURL,SINGLE.userModel.userNumber,time) parameters:@{} success:^(id responseObject) {
            SLEndRefreshing(wself.tableView);
            wself.sheetDataArr = [[OCCourseSheetModel objectArrayWithKeyValuesArray:responseObject] mutableCopy];
            [wself.tableView reloadData];
        } stateError:^(id responseObject) {
            SLEndRefreshing(wself.tableView);
        } failure:^(NSError *error) {
            SLEndRefreshing(wself.tableView);
        } viewController:self needCache:NO];
    }else{
        Weak;
        [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/timetable/%@/%ld",kURL,APICollegeURL,SINGLE.userModel.userNumber,time) parameters:@{} success:^(id responseObject) {
            SLEndRefreshing(wself.tableView);
            wself.sheetDataArr = [[OCCourseSheetModel objectArrayWithKeyValuesArray:responseObject] mutableCopy];
            [wself.tableView reloadData];
        } stateError:^(id responseObject) {
            SLEndRefreshing(wself.tableView);
        } failure:^(NSError *error) {
            SLEndRefreshing(wself.tableView);
        } viewController:self needCache:NO];
    }
    
}

-(void)requestSearchCourseSheetData:(NSString *)contentStr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    params[@"keyword"] = contentStr;
    
//    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/timetable/search",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCSearchCourseSheetModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        if (wself.page == 1) {
            [wself.searchSheetArr removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.page >= wself.totalPage) {
            wself.tableView.mj_footer.hidden = YES;
        }else{
            wself.tableView.mj_footer.hidden = NO;
        }
        [wself.searchSheetArr addObjectsFromArray:list];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.tableView);
    } viewController:self];
}

@end
