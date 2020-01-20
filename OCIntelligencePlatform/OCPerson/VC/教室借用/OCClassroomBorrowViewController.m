//
//  OCClassroomBorrowViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomBorrowViewController.h"
#import "WaterFlowLayout.h"
#import "OCClassroomBorrowCell.h"
#import "OCClassroomApplyViewController.h"
#import "OCClassroomBorrowModel.h"

@interface OCClassroomBorrowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowLayoutDelegate, OCClassroomBorrowCellDelegate>
@property (assign, nonatomic) BOOL isNoCancel;
@property (assign, nonatomic) NSInteger cancelCount;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) OCClassroomBorrowModel *borrowModel;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@end

@implementation OCClassroomBorrowViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBACKCOLOR;
    
    self.page = 1;
    self.totalPage = 1;
    self.isNoCancel = YES;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"教室借用" rightTitle:@"管理" rightAction:^{
        [wself rightClick];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;
    
    [self setupCollectionView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
//    [self requestClassroomBorrowList];
}

-(void)setupCollectionView{
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.insetSpace = UIEdgeInsetsMake(0, 20*FITWIDTH, 0, 20*FITWIDTH);
    layout.distance = 11*FITWIDTH;
    layout.headerSpace = 0;
    layout.colum = 2;
    //    layout.cellHeight = 148;
    layout.cellWidth = (kViewW - 40*FITWIDTH - 11*FITWIDTH)/2;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH) collectionViewLayout:layout];
    collectionView.backgroundColor = kBACKCOLOR;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[OCClassroomBorrowCell class] forCellWithReuseIdentifier:@"OCClassroomBorrowCellID"];
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}
#pragma mark ------------------------------------------------------- 交互事件
- (void)noticePullRefresh {
    _page = 1;
    [self requestClassroomBorrowList];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_collectionView);
        return;
    }
    [self requestClassroomBorrowList];
}

#pragma mark - collectionView delegate
-(CGFloat)waterFlow:(WaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath{
    return 139*FITWIDTH;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifier = @"OCClassroomBorrowCellID";
    OCClassroomBorrowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = kBACKCOLOR;
    if (indexPath.row == 0) {
        cell.isNoData = YES;
    }else{
        cell.isNoData = NO;
    }
    
    
    if (self.isNoCancel) {
        cell.selectedBtn.hidden = YES;
    }else{
        if (indexPath.row == 0) {
            cell.selectedBtn.hidden = YES;
        }else{
            cell.selectedBtn.hidden = NO;
        }
    }
    
    cell.delegate = self;
    cell.borrowModel = self.dataArray[indexPath.row-1];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        OCClassroomApplyViewController *vc = [[OCClassroomApplyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (!self.isNoCancel) {
            OCClassroomBorrowModel *model = self.dataArray[indexPath.row-1];
            model.isSelected = !model.isSelected;
            
            if (model.isSelected) {
                self.cancelCount = self.cancelCount+1;
            }else{
                self.cancelCount = self.cancelCount-1;
            }
            
            NSString *str = NSStringFormat(@"删除（%ld）",self.cancelCount);
            self.ts_navgationBar.rightButton.title = str;
            CGSize btnSize = [str sizeWithFont:kFont(14)];
            self.ts_navgationBar.rightButton.frame = Rect(kViewW - 15 - btnSize.width, 26, btnSize.width, 30);
            [self.collectionView reloadData];
        }
    }
    NSLog(@"%ld",indexPath.row);
}

#pragma mark - cell delegate
-(void)selectedCell:(OCClassroomBorrowCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    OCClassroomBorrowModel *model = self.dataArray[indexPath.row-1];
    model.isSelected = !model.isSelected;
    
    if (model.isSelected) {
        self.cancelCount = self.cancelCount+1;
    }else{
        self.cancelCount = self.cancelCount-1;
    }
    
    NSString *str = NSStringFormat(@"删除（%ld）",self.cancelCount);
    self.ts_navgationBar.rightButton.title = str;
    CGSize btnSize = [str sizeWithFont:kFont(14)];
    self.ts_navgationBar.rightButton.frame = Rect(kViewW - 15 - btnSize.width, 26, btnSize.width, 30);
    [self.collectionView reloadData];
}

#pragma mark - 网络请求
-(void)requestClassroomBorrowList{
    Weak;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    
//    [MBProgressHUD showMessage:@""];
    
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/classroom/borrow/list",kURL,APICollegeURL) parameters:@{} success:^(id responseObject) {
        SLEndRefreshing(wself.collectionView);

        NSArray *list = [OCClassroomBorrowModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        
        if (wself.page == 1) {
            [wself.dataArray removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.page >= wself.totalPage) {
            wself.collectionView.mj_footer.hidden = YES;
        }else{
            wself.collectionView.mj_footer.hidden = NO;
        }
        [wself.dataArray addObjectsFromArray:list];
        [wself.collectionView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.collectionView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.collectionView);
    } viewController:self];
}

-(void)cancelClassroomBorrow{
    NSString *idStr = @"";
    for (int i = 0; i<self.dataArray.count; i++) {
        OCClassroomBorrowModel *model = self.dataArray[i];
        if (model.isSelected) {
            if (idStr.length == 0) {
                idStr = model.borrowId;
            }else{
                idStr = [idStr stringByAppendingString:NSStringFormat(@",%@",model.borrowId)];
            }
        }
    }
    NSLog(@"%@",idStr);
    Weak;
    [APPRequest deleteRequestWithURLStr:NSStringFormat(@"%@/%@v1/classroom/borrow/%@",kURL,APICollegeURL,idStr) paramDic:@{}
                                success:^(id responseObject) {
                                    if (responseObject) {
                                        wself.cancelCount = 0;
                                        wself.page = 1;
                                        [wself requestClassroomBorrowList];
                                    }
                                } error:^(id responseObject) {
                                } failure:^(NSError *error) {
                                } controller:self];
}

#pragma mark - action method
-(void)rightClick{
    self.isNoCancel = !self.isNoCancel;
    if (self.isNoCancel) {
        self.ts_navgationBar.rightButton.title = @"管理";
        if (self.cancelCount>0) {
            Weak;
            [UIAlertController bme_alertWithTitle:@"提示" message:@"确定要删除吗？" sureTitle:@"确定" cancelTitle:@"取消" sureHandler:^(UIAlertAction * _Nonnull action) {
                [wself cancelClassroomBorrow];
            } cancelHandler:^(UIAlertAction * _Nonnull action) {
                
            }];
        }
        
    }else{
        NSString *str = NSStringFormat(@"删除（%ld）",self.cancelCount);
        self.ts_navgationBar.rightButton.title = str;
        CGSize btnSize = [str sizeWithFont:kFont(14)];
        self.ts_navgationBar.rightButton.frame = Rect(kViewW - 15 - btnSize.width, kStatusH+5, btnSize.width, 30);
        
    }
    
    [self.collectionView reloadData];
    
}
@end
