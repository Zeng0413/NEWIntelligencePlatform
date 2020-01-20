//
//  OCOrderedSeatViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/11.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCOrderedSeatViewController.h"
#import "OCOrderedSeatListViewController.h"

@interface OCOrderedSeatViewController ()<LTSimpleScrollViewDelegate>

@property (nonatomic, strong) LTSimpleManager *managerView;
@property (nonatomic, strong) LTLayout *layout;

@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation OCOrderedSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"座位信息" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [self setUpManagerView];

    // Do any additional setup after loading the view.
}

-(void)setUpManagerView{
    NSMutableArray * titleName = [NSMutableArray arrayWithArray:@[@"已预约",@"已过期"]];
    self.titles = titleName;
    
    _viewControllers = [self setupViewControllers];
    _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, kNavH, kViewW,kViewH-kNavH) viewControllers:self.viewControllers titles:titleName.copy currentViewController:self layout:self.layout];
    _managerView.delegate = self;
    _managerView.hoverY = kNavH;
    [self.view addSubview:self.managerView];

    
}

- (NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        
        OCOrderedSeatListViewController *vc = [[OCOrderedSeatListViewController alloc] init];
        vc.index = index;
        [testVCS addObject:vc];

    }];
    return testVCS.copy;
}

#pragma mark - lazy
- (LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.sliderWidth = 18*FITWIDTH;
        _layout.titleColor = RGBA(153, 153, 153, 1);
        _layout.titleSelectColor = kAPPCOLOR;
        _layout.bottomLineColor = kAPPCOLOR;
        _layout.titleViewBgColor = WHITE;
        _layout.lrMargin = 109*FITWIDTH;
        _layout.titleMargin = 72*FITWIDTH;
        _layout.sliderHeight = 35;
        _layout.isNeedScale = NO;

    }
    return _layout;
}

@end
