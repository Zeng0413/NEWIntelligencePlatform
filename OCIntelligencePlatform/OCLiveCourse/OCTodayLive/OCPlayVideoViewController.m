//
//  OCPlayVideoViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPlayVideoViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "OCVideoPlayModel.h"
#import "OCVideoControlBGView.h"
#import "OCLessonListModel.h"
#import "OCAcademyClassListViewController.h"
#import "OCCourseVideoListModel.h"
#import "OCVideoListCollectionViewCell.h"
#import "OCTourClassInfoView.h"
#import "OCVideoListViewController.h"
#import "OCCourseClassView.h"
#import "OCTourClassModel.h"
//#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/KSMediaPlayerManager.h>
@interface OCPlayVideoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) ZFPlayerController * player;
@property (nonatomic, strong) UIImageView * containerView;
@property (strong, nonatomic) OCVideoPlayModel *videoModel;
@property (strong, nonatomic) OCVideoControlBGView *controlView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *collectBtn;

@property (strong, nonatomic) NSArray *lessonList;
@property (strong, nonatomic) NSDictionary *videoDict;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *selectedBtn;

@property (assign, nonatomic) NSInteger selectedIndex;

//@property (strong, nonatomic) NSMutableArray *videoCourseDataList;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) OCTourClassInfoView *tourClassInfoView;
@property (strong, nonatomic) UIScrollView *contentScrollView;

@property (strong, nonatomic) OCTourClassModel *tourClassModel;


@end

@implementation OCPlayVideoViewController
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    if (self.isLive) {
        [self requestLiveVideoData];
    }else if (self.isTourClass){
        [self requestLiveVideoData];
        [self requestTourClassData];
    }else{
        [self requestlessonListData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

#pragma mark - View figure

-(void)setupTourClassUI{
    UIView *bottomBackView = [UIView viewWithBgColor:WHITE frame:Rect(0, kViewH - 80*FITWIDTH, kViewW, 88*FITWIDTH)];
    [self.view addSubview:bottomBackView];

    UIButton *operationBtn = [UIButton buttonWithTitle:@"编辑" titleColor:kAPPCOLOR backgroundColor:WHITE font:16*FITWIDTH image:nil target:self action:@selector(operationClick:) frame:Rect(40*FITWIDTH, 20*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    [operationBtn setTitle:@"保存" forState:UIControlStateSelected];
    [operationBtn setTitleColor:WHITE forState:UIControlStateSelected];
    operationBtn.layer.borderWidth = 1.0f;
    operationBtn.layer.borderColor = kAPPCOLOR.CGColor;
    operationBtn.layer.cornerRadius = 24*FITWIDTH;
    [bottomBackView addSubview:operationBtn];
    
    self.contentScrollView = [UIScrollView scrollViewWithBgColor:WHITE frame:Rect(0, 210*FITWIDTH, kViewW, kViewH - 210*FITWIDTH - bottomBackView.height)];
    [self.view addSubview:self.contentScrollView];
    
    self.tourClassInfoView = [[OCTourClassInfoView alloc] initWithFrame:Rect(0, 0, kViewW, 0)];
    [self.contentScrollView addSubview:self.tourClassInfoView];

    if (self.tourClassModel.summary.length==0) {
        [self operationClick:operationBtn];
    }else{
        self.tourClassInfoView.model = self.tourClassModel;
        self.tourClassInfoView.isEdit = NO;
        self.tourClassInfoView.height = self.tourClassInfoView.viewH;
        
        self.contentScrollView.contentSize = CGSizeMake(0, self.tourClassInfoView.height);
    }
    
    
    
    
}

-(void)videoPlayerViewInit{
    if (!self.containerView) {
        
        self.containerView = [[UIImageView alloc] initWithFrame:Rect(0, 0, kViewW, 210*FITWIDTH)];
        [self.view addSubview:self.containerView];
        [self.view addSubview:self.topView];
        
//        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        
//            ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
        if (self.isLive || self.isTourClass) {
            KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
            self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
                    self.player.controlView = self.controlView;
                    
            if (self.model) {
                self.controlView.liveModel = self.model;

            }
            /// 设置退到后台继续播放
            self.player.pauseWhenAppResignActive = NO;
        }else{
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
                    self.player.controlView = self.controlView;
                    
            if (self.model) {
                self.controlView.liveModel = self.model;

            }
            /// 设置退到后台继续播放
            self.player.pauseWhenAppResignActive = NO;
        }
        
        
                
    }
    
    
    
    if (self.videoModel) {
//        @"rtmp://202.69.69.180:443/webcast/bshdlive-pc"
        if (self.videoModel.Uri.length>0) {
            NSDictionary *dataDict = [NSString stringConvertToDic:self.videoModel.Uri];
            NSString *urlStr = dataDict[@"RTMP_H"];
            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            self.player.assetURL = [NSURL URLWithString:urlStr];
            self.player.assetURL = [NSURL URLWithString:urlStr];
        }
    }else{
        NSDictionary *urlDict = self.videoDict[@"data"];
        if (urlDict.allKeys.count>0) {
            if ([urlDict.allKeys containsObject:@"HLS_SH"]) {
                self.player.assetURL = [NSURL URLWithString:urlDict[@"HLS_SH"]];
            }else{
                self.player.assetURL = [NSURL URLWithString:urlDict[@"HLS"]];
            }
        }
    }
    
}

-(void)setupLessonView{
    UILabel *titleLab = [UILabel labelWithText:@"课讲选择" font:17*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, 234*FITWIDTH, 80*FITWIDTH, 17*FITWIDTH)];
    titleLab.font = kBoldFont(17*FITWIDTH);
    [self.view addSubview:titleLab];
    
    UIButton *moreBtn = [UIButton buttonWithTitle:@"查看全部" titleColor:TEXT_COLOR_GRAY backgroundColor:CLEAR font:12*FITWIDTH image:@"common_btn_more" frame:Rect(kViewW - 65*FITWIDTH - 20*FITWIDTH, 0, 65*FITWIDTH, 12*FITWIDTH)];
    moreBtn.centerY = titleLab.centerY;
    [moreBtn addTarget:self action:@selector(moreClick)];
    [moreBtn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageRight imageTitleSpacing:1*FITWIDTH];
    [self.view addSubview:moreBtn];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MaxY(titleLab)+15*FITWIDTH, kViewW, 30*FITWIDTH)];
    
    self.scrollView.backgroundColor = WHITE;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i<self.lessonList.count; i++) {
        OCLessonListModel *model = self.lessonList[i];
//        CGSize btnSize = [model.coursesName sizeWithFont:[UIFont systemFontOfSize:14*FITWIDTH]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(90*FITWIDTH, 30*FITWIDTH);
        btn.x = 20*FITWIDTH + (11*FITWIDTH + btn.width)*i;
        btn.y = 0;
        [btn setTitle:model.videoTitle forState:UIControlStateNormal];
        btn.titleLabel.font = kBoldFont(14*FITWIDTH);
        [btn setTitleColor:TEXT_COLOR_BLACK forState:UIControlStateNormal];
        [btn setTitleColor:kAPPCOLOR forState:UIControlStateDisabled];
        btn.tag = i;
        [btn setBackgroundColor:RGBA(234, 234, 234, 1)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.selectedIndex = 0;
            [self btnClick:btn];
        }
        [self.buttons addObject:btn];
        [self.scrollView addSubview:btn];
        
        
        if (i == self.lessonList.count-1) {
            self.scrollView.contentSize = CGSizeMake(MaxX(btn)+20*FITWIDTH, 0);
        }
    }
}

-(void)setupCollectionView{
    if (self.collectionView) {
        return;
    }
    
//    if (self.videoCourseDataList.count==0) {
//        NSArray *titleArr = @[@"A", @"B", @"C", @"D", @"E"];
//        for (int i = 0; i < titleArr.count; i++) {
//            OCCourseVideoListModel *model = [[OCCourseVideoListModel alloc] init];
//            model.name = titleArr[i];
//            model.speaker = @"张三";
//            model.videoCount = 23;
//            [self.videoCourseDataList addObject:model];
//        }
//    }
    
    UIView *lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, MaxY(self.scrollView)+24*FITWIDTH, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self.view addSubview:lineView];
    
    UILabel *commdTitle = [UILabel labelWithText:@"课程推荐" font:17*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, MaxY(lineView)+24*FITWIDTH, 100*FITWIDTH, 17*FITWIDTH)];
    commdTitle.font = kBoldFont(17*FITWIDTH);
    [self.view addSubview:commdTitle];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:Rect(0, MaxY(commdTitle)+5*FITWIDTH, kViewW, 92*FITWIDTH+46*FITWIDTH+27*FITWIDTH+20*FITWIDTH) collectionViewLayout:layout];
    collectionView.backgroundColor = WHITE;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [collectionView registerClass:[OCVideoListCollectionViewCell class] forCellWithReuseIdentifier:@"OCVideoListCollectionViewCellID"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

-(UIView *)topView{
    if (_topView) {
        return _topView;
    }
    
    _topView = [UIView viewWithBgColor:CLEAR frame:Rect(0, 0, kViewW, kStatusH+17+44)];
    _topView.userInteractionEnabled = YES;
    
    self.backBtn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:@"common_btn_back_white" frame:Rect(0, kStatusH + 5, 54, 44)];
    [self.backBtn addTarget:self action:@selector(backClick)];
    self.backBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 11, 10, 11);
    self.backBtn.adjustsImageWhenHighlighted = NO;
    [_topView addSubview:self.backBtn];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectBtn.size = CGSizeMake(28, 28);
    self.collectBtn.x = kViewW - 10 - self.collectBtn.width;
    self.collectBtn.centerY = self.backBtn.centerY;
    [self.collectBtn setImage:GetImage(@"online_btn_collect_nor") forState:UIControlStateNormal];
    [self.collectBtn setImage:GetImage(@"online_btn_collect_sel") forState:UIControlStateSelected];
    self.collectBtn.adjustsImageWhenHighlighted = NO;
    [_topView addSubview:self.collectBtn];
    
    return _topView;
}

//-(UIImageView *)containerView{
//    if (!_containerView) {
//        _containerView = [[UIImageView alloc] initWithFrame:Rect(0, 0, kViewW, 210*FITWIDTH)];
//    }
//    return _containerView;
//}

- (OCVideoControlBGView *)controlView {
    if (!_controlView) {
        _controlView = [[OCVideoControlBGView alloc] initWithFrame:self.containerView.bounds];
//        _controlView = [[OCVideoControlBGView alloc] initWithFrame:self.containerView.bounds withLiveModel:self.model];
    }
    return _controlView;
}

#pragma mark - collectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.videoCourseDataList.count;
    return self.commadArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifier = @"OCVideoListCollectionViewCellID";
    OCVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = WHITE;
    cell.videoModel = self.commadArr[indexPath.row];
    cell.selectedBtn.hidden = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseVideoListModel *model = self.commadArr[indexPath.row];
    OCPlayVideoViewController *vc = [[OCPlayVideoViewController alloc] init];
    vc.courseListVideoModel = model;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kViewW - 40*FITWIDTH - 11*FITWIDTH)/2, 92*FITWIDTH+46*FITWIDTH+27*FITWIDTH);
}

/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 20*FITWIDTH, 0, 20*FITWIDTH);
}

#pragma mark - action method

-(void)operationClick:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"summary"] = self.tourClassInfoView.courseContentTextView.text;
        params[@"evaluate"] = self.tourClassInfoView.adviseContentTextView.text;
        params[@"attitudeRemarks"] = self.tourClassInfoView.attitudeRemarkTextField.text;
        params[@"attitudeScore"] = self.tourClassInfoView.attitudeScroeTextField.text;
        params[@"contentsRemarks"] = self.tourClassInfoView.eduContentRemarkTextField.text;
        params[@"contentsScore"] = self.tourClassInfoView.eduScroeTextField.text;
        params[@"courseCode"] = self.classSheetModel.lessonCode;
        params[@"createTime"] = self.tourClassModel.createTime;
        params[@"roomCode"] = self.classSheetModel.roomCode;
        params[@"userId"] = SINGLE.userModel.userId;
        params[@"id"] = self.tourClassModel.ID;
        if (self.tourClassModel.summary.length == 0) { // 插入一条巡课记录
            
            
            
            [MBProgressHUD showMessage:@""];
            self.tourClassModel = [OCTourClassModel objectWithKeyValues:[params copy]];
            Weak;
            [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/patrolLesson",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
                wself.tourClassModel.ID = responseObject;
                wself.tourClassInfoView.model = wself.tourClassModel;
                wself.tourClassInfoView.isEdit = button.selected;
                wself.tourClassInfoView.height = wself.tourClassInfoView.viewH;
                wself.contentScrollView.contentSize = CGSizeMake(0, wself.tourClassInfoView.height);
            } stateError:^(id responseObject) {
            } failure:^(NSError *error) {
            } viewController:self];
        }else{
            [MBProgressHUD showMessage:@""];
            self.tourClassModel = [OCTourClassModel objectWithKeyValues:[params copy]];
            Weak;
            [APPRequest putRequestWithUrl:NSStringFormat(@"%@/%@v1/patrolLesson",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
                wself.tourClassInfoView.model = wself.tourClassModel;
                wself.tourClassInfoView.isEdit = button.selected;
                wself.tourClassInfoView.height = wself.tourClassInfoView.viewH;
                wself.contentScrollView.contentSize = CGSizeMake(0, wself.tourClassInfoView.height);
            } stateError:^(id responseObject) {
            } failure:^(NSError *error) {
            } viewController:self];
        }
    }
    if (button.selected) {
        self.tourClassInfoView.isEdit = YES;
        self.tourClassInfoView.height = self.tourClassInfoView.viewH;
        self.contentScrollView.contentSize = CGSizeMake(0, self.tourClassInfoView.height);
        [button setBackgroundColor:kAPPCOLOR];
        button.layer.borderColor = CLEAR.CGColor;
        button.layer.borderWidth = 0;
    }else{
        [button setBackgroundColor:WHITE];
        button.layer.borderColor = kAPPCOLOR.CGColor;
        button.layer.borderWidth = 1.0f;
    }
    
    
}

-(void)moreClick{
    NSMutableArray *titleArr = [NSMutableArray array];
    for (OCLessonListModel *model in self.lessonList) {
        [titleArr addObject:model.videoTitle];
    }
    OCCourseClassView *view = [[OCCourseClassView alloc] initWithFrame:Rect(0, kViewH, kViewW, kViewH - 210*FITWIDTH) withDataArray:titleArr withSelectedIndex:self.selectedIndex];
    
    Weak;
    __block OCCourseClassView *strongView = view;
    view.block = ^(NSInteger type, NSInteger index) {
        if (type == 0) { // 取消
            [UIView animateWithDuration:0.5 animations:^{
                strongView.y = kViewH;
            } completion:^(BOOL finished) {
                [strongView removeFromSuperview];
            }];
        }else{
            wself.selectedIndex = index;
            [wself selectedWithIndex:index];
        }
    };
    [self.view addSubview:view];
    
//    Weak;
    [UIView animateWithDuration:0.5 animations:^{
        strongView.y = 210*FITWIDTH;
    }];
//    OCAcademyClassListViewController *vc = [[OCAcademyClassListViewController alloc] init];
//    vc.selectedIndex = self.selectedIndex;
//
//    NSMutableArray *titleArr = [NSMutableArray array];
//    for (OCLessonListModel *model in self.lessonList) {
//        [titleArr addObject:model.videoTitle];
//    }
//
//    vc.titleArray = [titleArr copy];
//    Weak;
//    [vc returnBlock:^(NSInteger index) {
//        wself.selectedIndex = index;
//        [wself selectedWithIndex:index];
//    }];
//    [self presentViewController:vc animated:YES completion:nil];
}

-(void)selectedWithIndex:(NSInteger)index{
    UIButton *btn = self.buttons[index];
    [self btnClick:btn];
    
    if (self.buttons.count<6) {
        return;
    }
    CGFloat offsetX = btn.x-20*FITWIDTH;
    CGFloat maxOffsetX = self.scrollView.contentSize.width-self.scrollView.width;
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    self.scrollView.bouncesZoom = NO;
}

-(void)backClick{
//    OCVideoListViewController *vc = [[OCVideoListViewController alloc] init];
//    UIViewController *target = nil;
//    for (UIViewController *controllerVc in self.navigationController.viewControllers) {
//        if ([controllerVc isKindOfClass:[vc class]]) {
//            target = controllerVc;
//        }
//    }
//    if (target) {
//        [self.navigationController popToViewController:target animated:YES];
//    }
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

-(void)btnClick:(UIButton *)button{
    self.selectedIndex = button.tag;
    self.selectedBtn.backgroundColor = RGBA(234, 234, 234, 1);

    [self requestVideoData:self.lessonList[button.tag]];
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    button.backgroundColor = RGBA(229, 236, 247, 1);
}

#pragma mark - 网络请求
-(void)requestTourClassData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"courseCode"] = self.classSheetModel.lessonCode;
    params[@"roomCode"] = self.classSheetModel.roomCode;
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/patrolLesson/find",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        wself.tourClassModel = [OCTourClassModel objectWithKeyValues:responseObject];
        [wself setupTourClassUI];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)requestlessonListData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageIndex"] = @"1";
    params[@"pageSize"] = NSStringFormat(@"%ld",self.courseListVideoModel.videoCount);
    params[@"parentCourses"] = self.courseListVideoModel.no;
//    params[@"parentVideoTitle"] = self.courseListVideoModel.name;
    params[@"schoolId"] = SINGLE.userModel.schoolId;
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizCoursesVideoList",[kUserDefaults valueForKey:kInsideURL],APICourseURL) parameters:params success:^(id responseObject) {
        NSDictionary *dataDict = [NSString stringConvertToDic:responseObject];
        wself.lessonList = [[OCLessonListModel objectArrayWithKeyValuesArray:dataDict[@"data"][@"list"]] mutableCopy];
        [wself setupLessonView];
        [wself requestRecommdVideoList];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

// 获取课程视频详情
-(void)requestVideoData:(OCLessonListModel *)model{
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizVideoItemPlay/%ld/%@",[kUserDefaults valueForKey:kInsideURL],APICourseURL,model.videoId,SINGLE.userModel.schoolId) parameters:@{} success:^(id responseObject) {
        wself.videoDict = [NSString stringConvertToDic:responseObject];
        [wself videoPlayerViewInit];
        [wself requestVideoDetailData:model];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

// 获取课程视频详情
-(void)requestVideoDetailData:(OCLessonListModel *)model{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizVideoItem/%ld/%@",[kUserDefaults valueForKey:kInsideURL],APICourseURL,model.videoId,SINGLE.userModel.schoolId) parameters:@{} success:^(id responseObject) {
        NSDictionary *dict = [NSString stringConvertToDic:responseObject];
        wself.controlView.dataDict = dict[@"data"];
        NSLog(@"%@",dict);
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

-(void)requestRecommdVideoList{
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/live/bizCoursesListSimilar",[kUserDefaults valueForKey:kInsideURL],APICourseURL) parameters:@{@"pageSize":@"1000", @"no":self.courseListVideoModel.no, @"schoolId":SINGLE.userModel.schoolId} success:^(id responseObject) {
        NSDictionary *dict = [NSString stringConvertToDic:responseObject];
        wself.commadArr = [[OCCourseVideoListModel objectArrayWithKeyValuesArray:dict[@"data"][@"list"]] mutableCopy];
        [wself setupCollectionView];
        [wself.collectionView reloadData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

// 获取直播数据
-(void)requestLiveVideoData{
    [MBProgressHUD showMessage:@""];
    
    NSDictionary *params = @{@"id":NSStringFormat(@"%ld",self.isLive? self.model.recordEquipmentId : [self.classSheetModel.equipmentId integerValue]), @"nocache":@"0", @"schoolId":SINGLE.userModel.schoolId};
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/live/pubRecordEquipmentStateList",[kUserDefaults valueForKey:kInsideURL],APICourseURL) parameters:params success:^(id responseObject) {
        NSDictionary *dataDict = [NSString stringConvertToDic:responseObject];
        wself.videoModel = [OCVideoPlayModel objectWithKeyValues:dataDict[@"data"][@"1"]];
        [wself videoPlayerViewInit];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}
@end
