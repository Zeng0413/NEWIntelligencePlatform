//
//  OCClassroomListViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/20.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomListViewController.h"
#import "OCClassroomDetailViewController.h"
#import "OCClassroomBorrowViewController.h"
#import "OCCampusClassroomModel.h"
#import "OCClassroomListCell.h"
#import "OCClassroomHeadView.h"
#import "WSLWaterFlowLayout.h"
#import "OCClassroomListHeadView.h"
#import "OCSearchViewController.h"
#import "HMScannerController.h"
#import "OCCourseInteractionEnterViewController.h"
#import "JPUSHService.h"
#import "OCOrderSeatListViewController.h"

#define collectHeadIndentifier @"headIndentifier"
@interface OCClassroomListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WSLWaterFlowLayoutDelegate, OCClassroomListHeadViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *headArray;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIView *topSearchView;

@property (assign, nonatomic) NSInteger haveCourseSheet;
@end

@implementation OCClassroomListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBACKCOLOR;

    self.haveCourseSheet = [[kUserDefaults valueForKey:@"haveCourseSheet"] integerValue];
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"" rightTitle:@"教室借用" rightAction:^{
        BOOL flag = [OCPublicMethodManager checkUserPermission:OCUserPermissionClassroomApply];
        if (flag) {
            OCClassroomBorrowViewController *vc = [[OCClassroomBorrowViewController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showText:PermissionAlertString];
        }
        
    } backAction:^{
        
    }];
    self.ts_navgationBar.rightButton.size = CGSizeMake(72*FITWIDTH, 30*FITWIDTH);
    self.ts_navgationBar.rightButton.x = kViewW - 20*FITWIDTH - 72*FITWIDTH;
    self.ts_navgationBar.rightButton.y = kStatusH+4*FITWIDTH;
    self.ts_navgationBar.rightButton.backgroundColor = kAPPCOLOR;
    self.ts_navgationBar.rightButton.titleLabel.font = kBoldFont(12*FITWIDTH);
    [self.ts_navgationBar.rightButton setTitleColor:WHITE forState:UIControlStateNormal];
    self.ts_navgationBar.rightButton.layer.cornerRadius = 3*FITWIDTH;
    self.ts_navgationBar.backButton.hidden = YES;
    
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;
    [self requestDataList];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
    
    if (self.dataArray.count == 0) {
        NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];

            if ([has integerValue] == 1) {
                self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无教室信息~"];
            }else{
                self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"哎呀，您的网络还在沉睡中" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
}

-(void)setupCollectionView{
    if (self.collectionView) {
        return;
    }
    
    WSLWaterFlowLayout *layout = [[WSLWaterFlowLayout alloc] init];
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    layout.delegate = self;

    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:Rect(0, self.haveCourseSheet?kNavH : -kStatusH, kViewW, self.haveCourseSheet?kViewH-kNavH-kDockH : kViewH + kStatusH - kDockH - 10*FITWIDTH) collectionViewLayout:layout];
    collectionView.backgroundColor = kBACKCOLOR;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[OCClassroomListCell class] forCellWithReuseIdentifier:@"OCClassroomListCellID"];
    [collectionView registerClass:[OCClassroomHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectHeadIndentifier];
    [collectionView registerClass:[OCClassroomListHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classroomCellID"];
 
    Weak;
    NSString *has = [kUserDefaults valueForKey:kNetWorkAlertStr];
    
        if (wself.dataArray.count == 0) {
            if ([has integerValue] == 1) {
                collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"" detailStr:@"暂无教室信息~"];
            }else{
                collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"哎呀，您的网络还在沉睡中" detailStr:@"请找个开阔的的地方再试试哦～"];
            }
        }
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    if (!self.haveCourseSheet) {
        self.topSearchView = [UIView viewWithBgColor:RGBA(12, 94, 210, 1) frame:Rect(0, -kStatusH, kViewW, 70*FITWIDTH+kStatusH)];
        self.topSearchView.alpha = 0;
        [self.view addSubview:self.topSearchView];
        
        UIButton *tvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tvBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
        tvBtn.x = kViewW - 20*FITWIDTH - tvBtn.width;
        tvBtn.y = 32*FITWIDTH + kStatusH;
        tvBtn.image = @"common_btn_tv_mini";
        tvBtn.tag = 4;
        [tvBtn addTarget:self action:@selector(btnClick:)];
        [self.topSearchView addSubview:tvBtn];
        
        UIButton *seatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seatBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
        seatBtn.x = CGRectGetMinX(tvBtn.frame) - 20*FITWIDTH - seatBtn.width;
        seatBtn.y = tvBtn.y;
        seatBtn.image = @"common_btn_seat_mini ";
        seatBtn.tag = 3;
        [seatBtn addTarget:self action:@selector(btnClick:)];
        [self.topSearchView addSubview:seatBtn];
        
        UIButton *borrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        borrowBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
        borrowBtn.x = CGRectGetMinX(seatBtn.frame) - 20*FITWIDTH - borrowBtn.width;
        borrowBtn.y = tvBtn.y;
        borrowBtn.image = @"home_icon_borrow_mini";
        borrowBtn.tag = 2;
        [borrowBtn addTarget:self action:@selector(btnClick:)];
        [self.topSearchView addSubview:borrowBtn];
        
        UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scanBtn.size = CGSizeMake(26*FITWIDTH, 26*FITWIDTH);
        scanBtn.x = CGRectGetMinX(borrowBtn.frame) - 20*FITWIDTH - scanBtn.width;
        scanBtn.y = tvBtn.y;
        scanBtn.image = @"common_btn_scan_mini";
        scanBtn.tag = 1;
        [scanBtn addTarget:self action:@selector(btnClick:)];
        [self.topSearchView addSubview:scanBtn];
        
        UIView *searchBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
        searchBackView.x = 20*FITWIDTH;
        searchBackView.width = CGRectGetMinX(scanBtn.frame) - 24*FITWIDTH - 20*FITWIDTH;
        searchBackView.height = 30*FITWIDTH;
        searchBackView.centerY = scanBtn.centerY;
        searchBackView.layer.masksToBounds = YES;
        searchBackView.layer.cornerRadius = 3;
        searchBackView.userInteractionEnabled = YES;
        [self.topSearchView addSubview:searchBackView];

        UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewClick)];
        [searchBackView addGestureRecognizer:searchTap];
        
        UIImageView *searchIconImg = [UIImageView imageViewWithImage:GetImage(@"common_btn_search") frame:CGRectZero];
        searchIconImg.x = 12*FITWIDTH;
        searchIconImg.size = CGSizeMake(14*FITWIDTH, 14*FITWIDTH);
        searchIconImg.centerY = searchBackView.height/2;
        [searchBackView addSubview:searchIconImg];

        UILabel *searchLab = [UILabel labelWithText:@"搜索" font:14*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(MaxX(searchIconImg)+8*FITWIDTH, 0, 50*FITWIDTH, searchBackView.height)];
        [searchBackView addSubview:searchLab];
    }
    
}

-(void)pullRefresh{
    [self requestDataList];
}
#pragma mark - collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (!self.haveCourseSheet) {
        return self.dataArray.count + 1;
    }else{
        return self.dataArray.count;
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.haveCourseSheet) {
        if (section == 0) {
            return 0;
        }else{
            NSArray *tempArr = self.dataArray[section-1];
            return tempArr.count;
        }
    }else{
        NSArray *tempArr = self.dataArray[section];
        return tempArr.count;
    }
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.haveCourseSheet) {
        if (indexPath.section == 0) {
            return nil;
        }else{
            static NSString *indentifier = @"OCClassroomListCellID";
            OCClassroomListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
            NSArray *tempArr = self.dataArray[indexPath.section-1];
            cell.dataModel = tempArr[indexPath.row];
            if ((indexPath.row+1)%2 == 0) {
                cell.img.image = GetImage(@"tourclass_teachbuild_img_two");
            }else{
                cell.img.image = GetImage(@"tourclass_teachbuild_img_one");
            }
            cell.contentView.backgroundColor = kBACKCOLOR;
            return cell;
        }
    }else{
        static NSString *indentifier = @"OCClassroomListCellID";
        OCClassroomListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
        NSArray *tempArr = self.dataArray[indexPath.section];
        cell.dataModel = tempArr[indexPath.row];
        if ((indexPath.row+1)%2 == 0) {
            cell.img.image = GetImage(@"tourclass_teachbuild_img_two");
        }else{
            cell.img.image = GetImage(@"tourclass_teachbuild_img_one");
        }
        cell.contentView.backgroundColor = kBACKCOLOR;
        return cell;
    }
    
    
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (!self.haveCourseSheet) {
            if (indexPath.section == 0) {
                OCClassroomListHeadView *listHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classroomCellID" forIndexPath:indexPath];
                listHeadView.delegate = self;
                reusableView = listHeadView;
            }else{
                OCClassroomHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectHeadIndentifier forIndexPath:indexPath];
                header.headeLab.text = NSStringFormat(@"%@校区",self.headArray[indexPath.section-1]);
                reusableView = header;
            }
        }else{
            OCClassroomHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectHeadIndentifier forIndexPath:indexPath];
            header.headeLab.text = NSStringFormat(@"%@校区",self.headArray[indexPath.section]);
            reusableView = header;
        }
        
        
    }
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BOOL flag = [OCPublicMethodManager checkUserPermission:OCUserPermissionClassroomLook];
    if (flag) {
        NSArray *tempArr = self.dataArray[self.haveCourseSheet?indexPath.section : indexPath.section-1];
        OCClassroomDetailViewController *vc = [[OCClassroomDetailViewController alloc] init];
        vc.campusModel = tempArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD showText:PermissionAlertString];
    }
    
}

#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    
    self.topSearchView.alpha = y/100*FITWIDTH;
}

#pragma mark - action click
-(void)btnClick:(UIButton *)button{
    [self topViewBtnClickWithType:button.tag];
}

-(void)searchViewClick{
    [self topViewBtnClickWithType:0];
}

#pragma mark - headView delegate
-(void)topViewBtnClickWithType:(NSInteger)typeIndex{
    if (typeIndex == 0) { // 搜索
        OCSearchViewController *vc = [[OCSearchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (typeIndex == 1){ // 扫一扫
        Weak;
        HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
            [wself studentSignRequestWithToken:stringValue];
            
        }];
        
        [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        [self showDetailViewController:scanner sender:nil];
    }else if (typeIndex == 2){ // 教室借用
        BOOL flag = [OCPublicMethodManager checkUserPermission:OCUserPermissionClassroomApply];
        if (flag) {
            OCClassroomBorrowViewController *vc = [[OCClassroomBorrowViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showText:PermissionAlertString];
        }
    }else if (typeIndex == 3){ // 预约座位
        OCOrderSeatListViewController *seatListVc = [[OCOrderSeatListViewController alloc] init];
        [self.navigationController pushViewController:seatListVc animated:YES];
    }else if (typeIndex == 4){ // 投屏
        
    }
}

#pragma mark - WSLWaterFlowLayoutDelegate
-(CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake((kViewW - 40*FITWIDTH - 11*FITWIDTH)/2, 209*FITWIDTH);
    return CGSizeMake((kViewW - 40*FITWIDTH - 11*FITWIDTH)/2, 186*FITWIDTH);

}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    if (!self.haveCourseSheet) {
        if (section == 0) {
            return CGSizeMake(kViewW, 149*FITWIDTH);
        }else{
            return CGSizeMake(kViewW, 27*FITWIDTH);
        }
    }else{
        return CGSizeMake(kViewW, 27*FITWIDTH);
    }
    
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 11*FITWIDTH;
}

/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10*FITWIDTH;
}

/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, 20*FITWIDTH, 0, 20*FITWIDTH);
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
        [[OCPublicMethodManager getCurrentVC].navigationController pushViewController:vc animated:YES];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:[OCPublicMethodManager getCurrentVC]];
}

-(void)requestDataList{
    
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/classroominfo/list",kURL,APICollegeURL) parameters:@{} success:^(id responseObject) {
        SLEndRefreshing(wself.collectionView);
        wself.headArray = [NSMutableArray array];
        wself.dataArray = [NSMutableArray array];
        NSArray *tempArr = [OCCampusClassroomModel objectArrayWithKeyValuesArray:responseObject];
        
        if (tempArr.count>0) {
            OCCampusClassroomModel *lastModel = [tempArr firstObject];
            [wself.headArray addObject:lastModel.campus];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i<tempArr.count; i++) {
                OCCampusClassroomModel *model = tempArr[i];
                
                if ([model.campus isEqualToString:lastModel.campus]) {
                    [arr addObject:model];
                }else{
                    [wself.headArray addObject:model.campus];
                    [wself.dataArray addObject:arr];
                    arr = [NSMutableArray array];
                    [arr addObject:model];
                    lastModel = model;
                }
                
                if (i == tempArr.count - 1) {
                    [wself.dataArray addObject:arr];
                }
            }
            [wself setupCollectionView];

            [wself.collectionView reloadData];
        }
        
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.collectionView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.collectionView);
    } viewController:self needCache:NO];
}

@end
