//
//  OCOamNormalViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOamNormalViewController.h"
#import "OCOamNormalListViewController.h"

@interface OCOamNormalViewController ()<LTSimpleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, strong) LTLayout *layout;
@property (nonatomic, strong) LTSimpleManager *managerView;

@end

@implementation OCOamNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    [self setUpManagerView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}

#pragma mark ------------------------------------------ 初始化
- (void)setUpManagerView {
    NSMutableArray * titleName = [NSMutableArray arrayWithArray:@[@"未处理",@"处理中",@"已完成"]];
    self.titles = titleName;
    
    _viewControllers = [self setupViewControllers];
    _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, kStatusH + 15, kViewW,kViewH - kDockH - kStatusH - 15) viewControllers:self.viewControllers titles:titleName.copy currentViewController:self layout:self.layout];
    _managerView.delegate  = self;
    _managerView.hoverY = kNavH;
    [self.view addSubview:self.managerView];

}

- (NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        OCOamNormalListViewController *vc = [[OCOamNormalListViewController alloc] init];
        vc.type = index;
        [testVCS addObject:vc];
    }];
    return testVCS.copy;
}

#pragma mark ---------------------------------------------------- 懒加载
- (LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.sliderWidth = 48;
        //        _layout.bottomLineHeight = 100;
        _layout.titleColor = TEXT_COLOR_GRAY;
        _layout.titleSelectColor = kAPPCOLOR;
        _layout.bottomLineColor = kAPPCOLOR;
        _layout.titleViewBgColor  = WHITE;
        _layout.lrMargin = 80;
        _layout.titleFont = kFont(14);
        _layout.bottomLineHeight = 2;
        _layout.isAverage = YES;
        _layout.showsHorizontalScrollIndicator = NO;
        _layout.scale = 1;
        
    }
    return _layout;
}
@end
