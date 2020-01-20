//
//  OCRootViewControllerViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCRootViewControllerViewController.h"
#import "HomeViewController.h"
#import "OCPersonViewController.h"
#import "OCCourseSheetViewController.h"
#import "OCLiveCourseViewController.h"
#import "OCClassroomListViewController.h"
#import "OCUserPermissionModel.h"
#import "OCOamGroupLeaderViewController.h"
#import "OCOamNormalViewController.h"

#import "newCalenderViewController.h"
@interface OCRootViewControllerViewController ()

@property (strong, nonatomic) NSMutableArray *vcArray;

@end

@implementation OCRootViewControllerViewController

-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
    }
    return _vcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [kUserDefaults setValue:@"0" forKey:@"haveCourseSheet"];
    BOOL isHaveCourseSheet = NO;
    BOOL isHaveClassroom = NO;
    BOOL isHaveLive = NO;
    NSArray *permissionArr = SINGLE.userModel.permissionList;
    for (OCUserPermissionModel *permissionModel in permissionArr) {
        if (permissionModel.parentId == 0) {
            if (permissionModel.type == 4) { // 个人课表
                [self.vcArray addObject:@"OCCourseSheetViewController"];
                [kUserDefaults setValue:@"1" forKey:@"haveCourseSheet"];
                isHaveCourseSheet = YES;
            }else if (permissionModel.type == 1){ // 教室管理
                [self.vcArray addObject:@"OCClassroomListViewController"];
            }else if (permissionModel.type == 8){ // 运维管理
//                [self.vcArray addObject:@"OCOamGroupLeaderViewController"];
                [self.vcArray addObject:@"OCOamNormalViewController"];
            }else if (permissionModel.type == 6){ // 互动管理
                [self.vcArray addObject:@"HomeViewController"];
            }
        }else if ([permissionModel.url integerValue] == 10001){
            [self.vcArray addObject:@"OCClassroomListViewController"];
            isHaveClassroom = YES;
        }else if ([permissionModel.url integerValue] == 20001 || [permissionModel.url integerValue] == 20002){
            isHaveLive = YES;
            [self.vcArray addObject:@"OCLiveCourseViewController"];
        }
    }
    [self.vcArray addObject:@"OCPersonViewController"];
    
    if (isHaveCourseSheet) {
        [self.vcArray removeObject:@"OCCourseSheetViewController"];
        [self.vcArray insertObject:@"OCCourseSheetViewController" atIndex:0];
        if (isHaveClassroom) {
            [self.vcArray removeObject:@"OCClassroomListViewController"];
            [self.vcArray insertObject:@"OCClassroomListViewController" atIndex:1];
            
            [self.vcArray removeObject:@"OCLiveCourseViewController"];
            [self.vcArray insertObject:@"OCLiveCourseViewController" atIndex:2];
        }else{
            [self.vcArray removeObject:@"OCLiveCourseViewController"];
            [self.vcArray insertObject:@"OCLiveCourseViewController" atIndex:1];
        }
    }else if (isHaveClassroom) {
        [self.vcArray removeObject:@"OCClassroomListViewController"];
        [self.vcArray insertObject:@"OCClassroomListViewController" atIndex:0];
        if (isHaveLive) {
            [self.vcArray removeObject:@"OCLiveCourseViewController"];
            [self.vcArray insertObject:@"OCLiveCourseViewController" atIndex:1];
        }
    }else{
        if (isHaveLive) {
            [self.vcArray removeObject:@"OCLiveCourseViewController"];
            [self.vcArray insertObject:@"OCLiveCourseViewController" atIndex:0];
        }
        
    }
    
    [self initViewControllers];
    self.tabBar.backgroundColor = WHITE;

    for (NSInteger i = 0; i<self.vcArray.count; i++) {
        UIViewController *controller = self.viewControllers[i];
        controller.yp_tabItem.badge = 0;

    }
    
//    UIViewController *controller1 = self.viewControllers[0];
//    UIViewController *controller2 = self.viewControllers[1];
//    UIViewController *controller3 = self.viewControllers[2];
//    UIViewController *controller4 = self.viewControllers[3];
//    if ([SINGLE.userModel.userRole integerValue] != 1) {
//        UIViewController *controller5 = self.viewControllers[4];
//        controller5.yp_tabItem.badge = 0;
//    }
//    controller1.yp_tabItem.badge = 0;
//    controller2.yp_tabItem.badge = 0;
//    controller3.yp_tabItem.badge = 0;
//    controller4.yp_tabItem.badge = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabBar) name:@"hiddenTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"showTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBarBadge) name:@"showTabBarBadge" object:nil];

}

-(void)showTabBarBadge{
    UIViewController *controller4 = self.viewControllers[3];
    controller4.yp_tabItem.badge = 1;
    controller4.yp_tabItem.badgeStyle = YPTabItemBadgeStyleDot;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)initViewControllers{
    
    NSArray *dataArr = @[@{@"titleName":@"课表", @"defImg":@"common_table_icon_schedule_nor", @"selImg":@"common_table_icon_schedule_sel", @"vcName":@"OCCourseSheetViewController"},
                         @{@"titleName":@"教室情况", @"defImg":@"common_table_icon_classroom_nor", @"selImg":@"common_table_icon_classroom_sel", @"vcName":@"OCClassroomListViewController"},
                         @{@"titleName":@"在线课堂", @"defImg":@"common_table_icon_online_nor", @"selImg":@"common_table_icon_online_sel", @"vcName":@"OCLiveCourseViewController"},
                         @{@"titleName":@"运维管理", @"defImg":@"common_table_icon_yw_nor", @"selImg":@"common_table_icon_yw_sel", @"vcName":@"OCOamNormalViewController"},
                         @{@"titleName":@"互动课堂", @"defImg":@"common_table_icon_interact_nor", @"selImg":@"common_table_icon_interact_sel", @"vcName":@"HomeViewController"},
                         @{@"titleName":@"我的", @"defImg":@"common_table_icon_mine_nor", @"selImg":@"common_table_icon_mine_sel", @"vcName":@"OCPersonViewController"}];
    NSMutableArray *vcArr = [NSMutableArray array];
    for (NSString *vcStr in self.vcArray) {
        Class class = NSClassFromString(vcStr);
        UIViewController *vc = [[class alloc] init];
        TSNavigationController *vcNav = [[TSNavigationController alloc] initWithRootViewController:vc];
        for (NSDictionary *dict in dataArr) {
            if ([dict[@"vcName"] isEqualToString:vcStr]) {
                vcNav.yp_tabItemTitle = dict[@"titleName"];
                vcNav.yp_tabItemImage = [UIImage imageNamed:dict[@"defImg"]];
                vcNav.yp_tabItemSelectedImage = [UIImage imageNamed:dict[@"selImg"]];
                break;
            }
        }
        [vcArr addObject:vcNav];
    }
    self.viewControllers = vcArr;
    
}



@end
