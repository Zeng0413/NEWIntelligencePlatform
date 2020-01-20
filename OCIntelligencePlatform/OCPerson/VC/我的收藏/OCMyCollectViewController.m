//
//  OCMyCollectViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCMyCollectViewController.h"
#import "WaterFlowLayout.h"
#import "OCVideoListCollectionViewCell.h"
#import "OCVideoTopView.h"
#import "OCAcademyClassListViewController.h"
#import "OCCouseVideoModel.h"
@interface OCMyCollectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowLayoutDelegate>
{
    NSIndexPath *lastIndexPath;

}
@property (strong, nonatomic) OCVideoListCollectionViewCell *collectCell;
@property (strong, nonatomic) OCVideoTopView *topView;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSMutableArray *dataArr;

@property (assign, nonatomic) BOOL isNoCancel;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (assign, nonatomic) NSInteger cancelCount;
@end

@implementation OCMyCollectViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNoCancel = YES;
    self.cancelCount = 0;
    self.view.backgroundColor = kBACKCOLOR;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"我的收藏" rightTitle:@"管理" rightAction:^{
        [wself rightClick];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;
    
    NSArray *titleArr = @[@"A", @"B", @"C", @"D", @"E"];
    for (int i = 0; i < titleArr.count; i++) {
        OCCourseVideoListModel *model = [[OCCourseVideoListModel alloc] init];
        model.name = titleArr[i];
        model.speaker = @"张三";
        model.videoCount = 23;
        [self.dataArr addObject:model];
    }
    [self menuTopView];
    [self setupCollectionView];
}

#pragma mark -- view figure
-(void)menuTopView{
    if (!self.topView) {
        self.topView = [[OCVideoTopView alloc] initWithTopViewFrame:CGRectMake(0, kNavH, kViewW-kNavH, 39*FITWIDTH) titleName:@[@"全部",@"马哲学院",@"文学院",@"理学院",@"法学院",@"艺术学院",@"建筑学院",@"医学院",@"环境与生物技术学院"]];
        [self.view addSubview:self.topView];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setBackgroundImage:GetImage(@"online_btn_classify") forState:UIControlStateNormal];
        moreBtn.frame = Rect(kViewW-14*FITWIDTH-20*FITWIDTH, 0, 14*FITWIDTH, 14*FITWIDTH);
        moreBtn.centerY = self.topView.centerY;
        [moreBtn addTarget:self action:@selector(moreClick)];
        [self.view addSubview:moreBtn];
        
        Weak;
        _topView.block = ^(NSInteger tag) {
            wself.selectedIndex = tag;
            //            daySelectedIndex = tag;
            //            [selfVc changeOrderList];
        };
        
        // 默认选中订单类型
        [self.topView selectedWithIndex:0];
        self.selectedIndex = 0;
    }
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:Rect(0, MaxY(self.topView), kViewW, kViewH - MaxY(self.topView)) collectionViewLayout:layout];
    collectionView.backgroundColor = kBACKCOLOR;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[OCVideoListCollectionViewCell class] forCellWithReuseIdentifier:@"OCVideoListCollectionViewCellID"];
    collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"" titleStr:@"" detailStr:@"暂无收藏"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

}

#pragma mark - collectionView delegate
-(CGFloat)waterFlow:(WaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath{
    return 92*FITWIDTH+46*FITWIDTH+27*FITWIDTH;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifier = @"OCVideoListCollectionViewCellID";
    OCVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = kBACKCOLOR;
    cell.videoModel = self.dataArr[indexPath.row];
    if (self.isNoCancel) {
        cell.selectedBtn.hidden = YES;
    }else{
        cell.selectedBtn.hidden = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isNoCancel) {
        OCCourseVideoListModel *model = self.dataArr[indexPath.row];
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

#pragma mark - action method
-(void)rightClick{
    NSLog(@"statusH = %f",kStatusH);
    self.isNoCancel = !self.isNoCancel;
    if (self.isNoCancel) {
        self.ts_navgationBar.rightButton.title = @"管理";
    }else{
        NSString *str = NSStringFormat(@"删除（%ld）",self.cancelCount);
        self.ts_navgationBar.rightButton.title = str;
        CGSize btnSize = [str sizeWithFont:kFont(14)];
        self.ts_navgationBar.rightButton.frame = Rect(kViewW - 15 - btnSize.width, kStatusH+5, btnSize.width, 30);
        
    }
    
    [self.collectionView reloadData];
    
}

-(void)moreClick{
    OCAcademyClassListViewController *vc = [[OCAcademyClassListViewController alloc] init];
    vc.selectedIndex = self.selectedIndex;
    Weak;
    [vc returnBlock:^(NSInteger index) {
        wself.selectedIndex = index;
        [wself.topView selectedWithIndex:index];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
