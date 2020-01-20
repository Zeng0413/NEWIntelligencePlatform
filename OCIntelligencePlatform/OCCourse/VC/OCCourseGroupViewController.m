//
//  OCCourseGroupViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseGroupViewController.h"
#import "WaterFlowLayout.h"
#import "OCGroupPersonHeadCollectionViewCell.h"
#import "OCLessonGroupModel.h"
@interface OCCourseGroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowLayoutDelegate>

@property (strong, nonatomic) UILabel *scoreLab;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSDictionary *dataDict;

@property (strong, nonatomic) OCLessonGroupModel *groupModel;
@end

@implementation OCCourseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSDictionary *dict = @{@"id":@"1", @"name":@"第二组", @"score":@"67",
//                           @"userList":@[@{@"headImg":@"", @"score":@"5", @"userName":@"周杰伦", @"userNumber":@"5674", @"leader":@"0"},
//                                         @{@"headImg":@"", @"score":@"3", @"userName":@"小张", @"userNumber":@"2567", @"leader":@"0"},
//                                         @{@"headImg":@"", @"score":@"1", @"userName":@"小李", @"userNumber":@"456", @"leader":@"0"},
//                                         @{@"headImg":@"", @"score":@"8", @"userName":@"小明", @"userNumber":@"9876", @"leader":@"0"},
//                                         @{@"headImg":@"", @"score":@"5", @"userName":@"小智", @"userNumber":@"34567", @"leader":@"1"},
//                                         @{@"headImg":@"", @"score":@"4", @"userName":@"小杰", @"userNumber":@"7654", @"leader":@"0"}]
//                           };
    self.view.backgroundColor = kBACKCOLOR;
    [self requestGroupData];
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:self.tempDict[@"name"] backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.backButton.image = @"common_btn_back_white";
    self.ts_navgationBar.backgroundColor = CLEAR;
    self.ts_navgationBar.titleLabel.textColor = WHITE;
}

#pragma mark -- view figure
-(void)setupCollectionView{
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.insetSpace = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.distance = 0;
    layout.headerSpace = 0;
    layout.colum = 3;
    layout.cellHeight = 148;
    layout.cellWidth = kViewW/3;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:Rect(0, 166*FITWIDTH, kViewW, kViewH-166*FITWIDTH) collectionViewLayout:layout];
    collectionView.backgroundColor = WHITE;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"OCGroupPersonHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OCGroupPersonHeadCollectionViewCellID"];
    [self.view addSubview:collectionView];
}

-(void)setupHeadView{
    UIView *headView = [UIView viewWithBgColor:kAPPCOLOR frame:Rect(0, 0, kViewW, 166*FITWIDTH)];
    [self.view insertSubview:headView atIndex:0];
    
    UILabel *descLab = [UILabel labelWithText:@"小组本次得分" font:12*FITWIDTH textColor:RGBA(137, 181, 236, 1) frame:CGRectZero];
    descLab.size = [descLab.text sizeWithFont:kFont(12*FITWIDTH)];
    descLab.x = (kViewW - descLab.width)/2;
    descLab.y = headView.height - descLab.height - 24*FITWIDTH;
    [headView addSubview:descLab];
    
    self.scoreLab = [UILabel labelWithText:NSStringFormat(@"%ld",self.groupModel.score) font:18 textColor:WHITE frame:CGRectZero];
    self.scoreLab.font = kBoldFont(30*FITWIDTH);
    self.scoreLab.size = [self.scoreLab.text sizeWithFont:kBoldFont(30*FITWIDTH)];
    self.scoreLab.x = (kViewW - self.scoreLab.width)/2;
    self.scoreLab.y = descLab.y-self.scoreLab.height-12*FITWIDTH;
    [headView addSubview:self.scoreLab];
    
}

#pragma mark - collectionView delegate
-(CGFloat)waterFlow:(WaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath{
    return layout.cellHeight;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.groupModel.userList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OCGroupPersonHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCGroupPersonHeadCollectionViewCellID" forIndexPath:indexPath];
    cell.userModel = self.groupModel.userList[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
}

#pragma mark - 网络请求
-(void)requestGroupData{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/lesson/group/%ld/%ld",kURL,APIInteractiveURl,self.lessonID,[self.tempDict[@"id"] integerValue]) parameters:@{} success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        
        wself.groupModel = [OCLessonGroupModel objectWithKeyValues:dict];
        [wself setupHeadView];
        [wself setupCollectionView];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

#pragma mark -- lazy

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
