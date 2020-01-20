//
//  OCPersonViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPersonViewController.h"
#import "OCMyListCell.h"
#import "OCMessageListViewController.h"
#import "OCOpinionViewController.h"
#import "loginViewController.h"
#import "OCForgetPwdViewController.h"
#import "bindingPhoneViewController.h"
#import "OCAboutAsUViewController.h"
#import "OCSettingsViewController.h"
#import "OCPersonInformationViewController.h"
#import "OCMyCollectViewController.h"
#import "OCPersonSpaceViewController.h"
#import "OCSystemNotificationViewController.h"
#import "OCClassroomApproveViewController.h"
#import "OCSystemLogViewController.h"
#import "OCClassroomBorrowViewController.h"
#import "OCCollegeNotificationViewController.h"
#import "OCTourClassRecordViewController.h"
#import "OCOrderSeatViewController.h"
#import "OCOrderSeatListViewController.h"
#import "OCOrderedSeatViewController.h"

@interface OCPersonViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *academyLab; //学院
@property (strong, nonatomic) UILabel *classLab;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation OCPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;

    NSArray *array1 = @[@{@"img":@"mine_icon_collect", @"title":@"我的收藏"},@{@"img":@"mine_icon_zone", @"title":@"个人空间"}];
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:@[@{@"img":@"mine_icon_message", @"title":@"系统通知"},@{@"img":@"mine_icon_collegeMessage", @"title":@"校园通知"}]];
    
    BOOL isClassroomApproved = [OCPublicMethodManager checkUserPermission:OCUserPermissionClassroomApproved];
    BOOL isTourClassRecord = [OCPublicMethodManager checkUserPermission:OCUserPermissionTourClassRecord];
    if (isClassroomApproved && !isTourClassRecord) {
        [array2 addObject:@{@"img":@"mine_icon_approve", @"title":@"教室审批"}];
    }else if (!isClassroomApproved && isTourClassRecord){
        [array2 addObject:@{@"img":@"mine_icon_record", @"title":@"巡课记录"}];
    }else if (isClassroomApproved && isTourClassRecord){
        [array2 addObject:@{@"img":@"mine_icon_approve", @"title":@"教室审批"}];
        [array2 addObject:@{@"img":@"mine_icon_record", @"title":@"巡课记录"}];
    }
    
    BOOL flag = [[kUserDefaults valueForKey:@"haveCourseSheet"] integerValue];
    if (flag) {
        [array2 addObject:@{@"img":@"mine_icon_seat", @"title":@"已预约座位"}];
    }
    self.dataArray = @[array1,array2];
//    if ([SINGLE.userModel.userRole integerValue] == 1) {
//        self.dataArray = @[@[@{@"img":@"mine_icon_collect", @"title":@"我的收藏"},@{@"img":@"mine_icon_zone", @"title":@"个人空间"}], @[@{@"img":@"mine_icon_message", @"title":@"系统通知"},@{@"img":@"mine_icon_approve", @"title":@"教室审批"},@{@"img":@"mine_icon_record", @"title":@"巡课记录"}]];
//    }else{
//        self.dataArray = @[@[@{@"img":@"mine_icon_collect", @"title":@"我的收藏"},@{@"img":@"mine_icon_zone", @"title":@"个人空间"}], @[@{@"img":@"mine_icon_message", @"title":@"系统通知"},@{@"img":@"mine_icon_collegeMessage", @"title":@"校园通知"}]];
//    }
    
    [self setupTableView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
    
    if (self.iconImg) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:SINGLE.userModel.headImg]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}

-(UIView *)setHeadView{
    UIImageView *backView = [UIImageView imageViewWithImage:GetImage(@"mine_bg") frame:Rect(0, 0, kViewW, 182*FITWIDTH)];
    backView.userInteractionEnabled = YES;
    
    self.iconImg = [UIImageView imageViewWithUrl:[NSURL URLWithString:SINGLE.userModel.headImg] frame:Rect(20*FITWIDTH, 72*FITWIDTH, 80*FITWIDTH, 80*FITWIDTH)];
    self.iconImg.userInteractionEnabled = YES;
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = 40*FITWIDTH;
    self.iconImg.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:self.iconImg];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserImageAction)];
    [self.iconImg addGestureRecognizer:tap];
    
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = Rect(kViewW - 44*FITWIDTH, 33*FITWIDTH, 24*FITWIDTH, 24*FITWIDTH);
    [setBtn setBackgroundImage:GetImage(@"mine_icon_set") forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setClick)];
    [backView addSubview:setBtn];
    
    self.nameLab = [UILabel labelWithText:SINGLE.userModel.userName font:20 textColor:WHITE frame:Rect(MaxX(self.iconImg)+24*FITWIDTH, self.iconImg.y+5*FITWIDTH, kViewW-self.nameLab.x, 20*FITWIDTH)];
    self.nameLab.font = kBoldFont(20*FITWIDTH);
    [backView addSubview:self.nameLab];
    
    self.academyLab = [UILabel labelWithText:SINGLE.userModel.majorName font:14*FITWIDTH textColor:WHITE frame:Rect(self.nameLab.x, MaxY(self.nameLab)+17*FITWIDTH, 200*FITWIDTH, 14*FITWIDTH)];
    [backView addSubview:self.academyLab];
    
    self.classLab = [UILabel labelWithText:NSStringFormat(@"%ld级%@",SINGLE.userModel.enrollmentYear,SINGLE.userModel.clazzName) font:12*FITWIDTH textColor:WHITE frame:Rect(self.academyLab.x, MaxY(self.academyLab)+7*FITWIDTH, 150, 12*FITWIDTH)];
    if (SINGLE.userModel.enrollmentYear == 0) {
        self.classLab.text = @"";
    }
    [backView addSubview:self.classLab];
    
    return backView;
}


-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, -kStatusH, kViewW, kViewH+kStatusH-kDockH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView .rowHeight = 50*FITWIDTH;
    tableView.backgroundColor = kBACKCOLOR;
    tableView.tableHeaderView = [self setHeadView];
    [tableView registerNib:[UINib nibWithNibName:@"OCMyListCell" bundle:nil] forCellReuseIdentifier:@"OCMyListCellID"];
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];

}

#pragma mark - action method
-(void)clickUserImageAction{
    OCPersonInformationViewController *vc = [[OCPersonInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)setClick{
    OCSettingsViewController *vc = [[OCSettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp = self.dataArray[section];
    return temp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr = self.dataArray[indexPath.section];
    NSDictionary *dataDict = tempArr[indexPath.row];
    OCMyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCMyListCellID"];
    cell.img.image = [UIImage imageNamed:dataDict[@"img"]];
    cell.titleLab.text = dataDict[@"title"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isClassroomApproved = [OCPublicMethodManager checkUserPermission:OCUserPermissionClassroomApproved];
    BOOL isTourClassRecord = [OCPublicMethodManager checkUserPermission:OCUserPermissionTourClassRecord];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        OCMyCollectViewController *vc = [[OCMyCollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        OCPersonSpaceViewController *vc = [[OCPersonSpaceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        OCSystemNotificationViewController *vc = [[OCSystemNotificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        OCCollegeNotificationViewController *vc = [[OCCollegeNotificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    if (isClassroomApproved && !isTourClassRecord) {
        if (indexPath.section == 1 && indexPath.row == 2) {
            OCClassroomApproveViewController *vc = [[OCClassroomApproveViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (!isClassroomApproved && isTourClassRecord){
        if (indexPath.section == 1 && indexPath.row == 2) {
            OCTourClassRecordViewController *vc = [[OCTourClassRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (isClassroomApproved && isTourClassRecord){
        if (indexPath.section == 1 && indexPath.row == 2) {
            OCClassroomApproveViewController *vc = [[OCClassroomApproveViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 3){
            OCTourClassRecordViewController *vc = [[OCTourClassRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        NSArray *tempArr = self.dataArray[1];
        BOOL flag = [[kUserDefaults valueForKey:@"haveCourseSheet"] integerValue];
        if (flag) {
            if (indexPath.row == tempArr.count-1) {
                OCOrderedSeatViewController *vc = [[OCOrderedSeatViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
    
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, kViewW, 25*FITWIDTH)];
        UIView *liveView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 17*FITWIDTH, kViewW, 8*FITWIDTH)];
        [backView addSubview:liveView];
        return backView;
    }else{
        UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, kViewW, 15*FITWIDTH)];
        return backView;

    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 26*FITWIDTH;
    }
    return 15*FITWIDTH;
}


@end
