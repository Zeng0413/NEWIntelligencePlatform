//
//  OCLiveCourseViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCLiveCourseViewController.h"
#import "OCTodayLiveViewController.h"
#import "OCTomorrwLiveViewController.h"
#import "OCVideoListViewController.h"

@interface OCLiveCourseViewController ()<LTSimpleScrollViewDelegate>

@property (nonatomic, strong) LTLayout *layout;
@property (nonatomic, strong) LTSimpleManager *managerView;
@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation OCLiveCourseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    [self setUpManagerView];
    // Do any additional setup after loading the view.
}

#pragma mark ------------------------------------------ 初始化
- (void)setUpManagerView {
    NSMutableArray *titleName = [NSMutableArray array];
    BOOL isLive = [OCPublicMethodManager checkUserPermission:OCUserPermissionLive];
    BOOL isCourseVideo = [OCPublicMethodManager checkUserPermission:OCUserPermissionCourseVideo];
    if (isLive && !isCourseVideo) {
        titleName = [NSMutableArray arrayWithArray:@[@"今日直播",@"明日直播"]];
    }else if (!isLive && isCourseVideo){
        titleName = [NSMutableArray arrayWithArray:@[@"视频"]];
    }else if (isLive && isCourseVideo){
        titleName = [NSMutableArray arrayWithArray:@[@"今日直播",@"明日直播",@"视频"]];
    }
    self.titles = titleName;
    
    _viewControllers = [self setupViewControllers];
    _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, kStatusH, kViewW,kViewH - kDockH - kStatusH) viewControllers:self.viewControllers titles:titleName.copy currentViewController:self layout:self.layout];
    _managerView.delegate  = self;
    _managerView.backgroundColor = kBACKCOLOR;
    _managerView.hoverY = kNavH;
    
    [self.view addSubview:self.managerView];
}

- (NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        BOOL isLive = [OCPublicMethodManager checkUserPermission:OCUserPermissionLive];
        BOOL isCourseVideo = [OCPublicMethodManager checkUserPermission:OCUserPermissionCourseVideo];
        if (isLive && !isCourseVideo) {
            if (index == 0) {
                OCTodayLiveViewController * TodayLive = [[OCTodayLiveViewController alloc] init];
                [testVCS addObject:TodayLive];
            }else if (index == 1) {
                OCTomorrwLiveViewController * TomorrwLive = [[OCTomorrwLiveViewController alloc] init];
                [testVCS addObject:TomorrwLive];
            }
        }else if (!isLive && isCourseVideo){
            if (index == 0) {
                OCVideoListViewController * VideoList = [[OCVideoListViewController alloc] init];
                [testVCS addObject:VideoList];
            }
        }else if (isLive && isCourseVideo){
            if (index == 0) {
                OCTodayLiveViewController * TodayLive = [[OCTodayLiveViewController alloc] init];
                [testVCS addObject:TodayLive];
            }else if (index == 1) {
                OCTomorrwLiveViewController * TomorrwLive = [[OCTomorrwLiveViewController alloc] init];
                [testVCS addObject:TomorrwLive];
            }else {
                OCVideoListViewController * VideoList = [[OCVideoListViewController alloc] init];
                [testVCS addObject:VideoList];
            }
        }
        
    }];
    return testVCS.copy;
}

- (LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.sliderWidth = 20;
        _layout.scale = 1.2;
        _layout.titleColor = RGBA(153, 153, 153, 1);
        _layout.titleSelectColor = kAPPCOLOR;
        _layout.bottomLineColor = kAPPCOLOR;
        _layout.titleViewBgColor = kBACKCOLOR;
        _layout.titleFont = kBoldFont(17*FITWIDTH);
        _layout.sliderHeight = 35;
        _layout.lrMargin = 20;
        _layout.lrMargin = 76*FITWIDTH;
//        _layout.isAverage = YES;
    }
    return _layout;
}

@end
