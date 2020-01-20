//
//  OCVideoListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCVideoListViewController.h"
#import "WaterFlowLayout.h"
#import "OCVideoListCollectionViewCell.h"
#import "OCVideoTopView.h"
#import "OCAcademyClassListViewController.h"
#import "OCAcademyModel.h"
#import "OCCouseVideoModel.h"
#import "OCPlayVideoViewController.h"
#import "OCCourseVideoListModel.h"

@interface OCVideoListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowLayoutDelegate>

@property (strong, nonatomic) OCVideoListCollectionViewCell *collectCell;
@property (strong, nonatomic) OCVideoTopView *topView;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *academyListArr;
@property (strong, nonatomic) NSMutableArray *titleArr;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (strong, nonatomic) NSMutableArray *videoCourseDataList;

@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation OCVideoListViewController

-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

-(NSMutableArray *)videoCourseDataList{
    if (!_videoCourseDataList) {
        _videoCourseDataList = [NSMutableArray array];
    }
    return _videoCourseDataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;

    self.page = 1;
    self.totalPage = 1;
    // 查询学院列表
    [self requestAcademyList];
//    [self menuTopView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.videoCourseDataList.count == 0) {
        NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

            if ([has integerValue] == 1) {
                self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无视频~"];
            }else{
                self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
    }
    
}

#pragma mark -- view figure

-(void)menuTopView{
    if (!self.topView) {
        [self.titleArr addObject:@"全部"];
        for (OCAcademyModel *model in self.academyListArr) {
            [self.titleArr addObject:model.name];
        }
        
        self.topView = [[OCVideoTopView alloc] initWithTopViewFrame:CGRectMake(0, 35, kViewW-44*FITWIDTH, 39*FITWIDTH) titleName:self.titleArr];
        [self.view addSubview:self.topView];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setBackgroundImage:GetImage(@"online_btn_classify") forState:UIControlStateNormal];
        moreBtn.frame = Rect(kViewW-14*FITWIDTH-20*FITWIDTH, 0, 14*FITWIDTH, 14*FITWIDTH);
        moreBtn.centerY = self.topView.centerY;
        [moreBtn addTarget:self action:@selector(moreClick)];
        [self.view addSubview:moreBtn];
        
        Weak;
        _topView.block = ^(NSInteger tag) {
            if (tag == 0) {
                wself.selectedIndex = tag;
            }else{
                OCAcademyModel *model = wself.academyListArr[tag-1];
                wself.selectedIndex = model.ID;
            }
            [wself requestVideoCourseData];
        };
        
        // 默认选中订单类型
        [self.topView selectedWithIndex:0];
        self.selectedIndex = 0;
    }
}

-(void)setupCollectionView{
    if (self.collectionView) {
        return;
    }
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.insetSpace = UIEdgeInsetsMake(0, 20*FITWIDTH, 0, 20*FITWIDTH);
    layout.distance = 11*FITWIDTH;
    layout.headerSpace = 0;
    layout.colum = 2;
    layout.cellWidth = (kViewW - 40*FITWIDTH - 11*FITWIDTH)/2;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:Rect(0, MaxY(self.topView), kViewW, kViewH - kStatusH - 35 - kDockH - 15 - self.topView.height) collectionViewLayout:layout];
    collectionView.backgroundColor = kBACKCOLOR;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[OCVideoListCollectionViewCell class] forCellWithReuseIdentifier:@"OCVideoListCollectionViewCellID"];
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    Weak;
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

        if (wself.videoCourseDataList.count == 0) {
            if ([has integerValue] == 1) {
                collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无视频~"];
            }else{
                collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
        }
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - collectionView delegate
-(CGFloat)waterFlow:(WaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath{
    
    return 92*FITWIDTH+46*FITWIDTH+27*FITWIDTH;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoCourseDataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *indentifier = @"OCVideoListCollectionViewCellID";
    OCVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = kBACKCOLOR;
    cell.videoModel = self.videoCourseDataList[indexPath.row];
    cell.selectedBtn.hidden = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseVideoListModel *model = self.videoCourseDataList[indexPath.row];
    OCPlayVideoViewController *vc = [[OCPlayVideoViewController alloc] init];
    vc.courseListVideoModel = model;
//    vc.commadArr = self.videoCourseDataList;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 网络请求
-(void)requestAcademyList{
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizCategorySectionListWithCategory/%@",[kUserDefaults valueForKey:kInsideURL],APICourseURL,SINGLE.userModel.schoolId) parameters:@{} success:^(id responseObject) {
        NSDictionary *dataDict = [NSString stringConvertToDic:responseObject];
        wself.academyListArr = [OCAcademyModel objectArrayWithKeyValuesArray:dataDict[@"data"][@"data"][@"categorySection"]];
        [wself menuTopView];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

-(void)requestVideoCourseData{
    Weak;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageIndex"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"1000";
    params[@"parentCategorySection"] = self.selectedIndex == 0 ? @"" : NSStringFormat(@"%ld",self.selectedIndex);
    params[@"schoolId"] = SINGLE.userModel.schoolId;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizCoursesList",[kUserDefaults valueForKey:kInsideURL],APICourseURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(self.collectionView);
        NSDictionary *dataDict = [NSString stringConvertToDic:responseObject];
        wself.videoCourseDataList = [[OCCourseVideoListModel objectArrayWithKeyValuesArray:dataDict[@"data"][@"list"]] mutableCopy];
        [wself setupCollectionView];
        [wself.collectionView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(self.collectionView);
    } failure:^(NSError *error) {
        SLEndRefreshing(self.collectionView);
    } viewController:self];
}


#pragma mark - action method
-(void)moreClick{
    OCAcademyClassListViewController *vc = [[OCAcademyClassListViewController alloc] init];
    vc.selectedIndex = self.selectedIndex;
    vc.titleArray = [self.titleArr copy];
    Weak;
    [vc returnBlock:^(NSInteger index) {
        wself.selectedIndex = index;
        [wself.topView selectedWithIndex:index];
    }];
    [self presentViewController:vc animated:YES completion:nil];
//    [self.topView autoScollViewPoint];
}

-(void)pullRefresh{
    [self requestVideoCourseData];
}
@end
