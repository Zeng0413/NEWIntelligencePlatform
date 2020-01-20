//
//  OCCourseInteractionEnterViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseInteractionEnterViewController.h"
#import "OCCourseResourceCell.h"
#import "OCChooseTypeQuestionViewController.h"
#import "OCSolutionTypeQuestionViewController.h"
#import "OCMyAnswerPaperViewController.h"
#import "OCCourseWareModel.h"
#import "WKWebViewController.h"
#import "OCInteractionAnswerQuestionViewController.h"
#import "HMScannerController.h"
@interface OCCourseInteractionEnterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *interactionBtn;
@property (strong, nonatomic) UIButton *lookAnswerPaper;

@property (strong, nonatomic) NSArray *courseWareArr;

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation OCCourseInteractionEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"课件下载" rightTitle:@"" rightAction:^{
        [wself toScannerVc];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [self.ts_navgationBar.rightButton setTitleColor:kAPPCOLOR forState:UIControlStateNormal];
    
    
    
    [self requestCourseWareList];
    
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isNoClass) {
        [self requestCourseStatus:NO];
    }
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH - 92*FITWIDTH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 67*FITWIDTH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"OCCourseResourceCell" bundle:nil] forCellReuseIdentifier:@"OCCourseResourceCellID"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.interactionBtn = [UIButton buttonWithTitle:@"进入互动" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:nil target:self action:@selector(interactionClick) frame:Rect(28*FITWIDTH, kViewH - 32*FITWIDTH - 48*FITWIDTH, kViewW - 56*FITWIDTH, 48*FITWIDTH)];
    self.interactionBtn.layer.cornerRadius = self.interactionBtn.height/2;
    self.interactionBtn.hidden = YES;
    [self.view addSubview:self.interactionBtn];
    
    self.lookAnswerPaper = [UIButton buttonWithTitle:@"查看我的答题卡" titleColor:kAPPCOLOR backgroundColor:CLEAR font:16*FITWIDTH image:nil target:self action:@selector(lookAnswerPaperClick) frame:Rect(40*FITWIDTH, self.interactionBtn.y - 48*FITWIDTH - 12*FITWIDTH, kViewW - 80*FITWIDTH, 48*FITWIDTH)];
    self.lookAnswerPaper.hidden = YES;
    
    [self.view addSubview:self.lookAnswerPaper];
    
}

#pragma mark - action method
-(void)lookAnswerPaperClick{
    OCMyAnswerPaperViewController *vc = [[OCMyAnswerPaperViewController alloc] init];
    vc.lessonID = [self.dataDict[@"lessonId"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)interactionClick{
    
    if ([self.dataDict[@"myStatus"] integerValue] != 2){
        [MBProgressHUD showText:@"未发起互动"];
        return;
    }
    [self requestCourseStatus:YES];
    
    
    
    
}

-(void)openFileWithPath:(NSString *)pathStr{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    vc.urlStr1 = pathStr;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)toScannerVc{
    
    Weak;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        [wself studentSignRequestWithToken:stringValue];
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}
#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseWareArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCCourseResourceCellID"];
    cell.dataModel = self.courseWareArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseWareModel *model = self.courseWareArr[indexPath.row];
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:model.url.lastPathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [self openFileWithPath:filePath];
    }else{
        Weak;
        [MBProgressHUD showMessage:@""];
        [APPRequest downloadFileWithFileName:model.name filePath:filePath requestUrlStr:model.url success:^(id responseObject) {
            [MBProgressHUD hideHUD];
            [wself openFileWithPath:responseObject];
        }];
    }
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
        [MBProgressHUD showSuccess:@"签到成功"];
        [wself requestCourseStatus:NO];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

// 课件列表
-(void)requestCourseWareList{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/lesson/courseware/list/%ld",kURL,APIInteractiveURl,self.lessonModel?self.lessonModel.ID : [self.signDict[@"lessonId"] integerValue]) parameters:@{} success:^(id responseObject) {
        wself.courseWareArr = [OCCourseWareModel objectArrayWithKeyValuesArray:responseObject];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

// 查看我的上课状态
-(void)requestCourseStatus:(BOOL)isToInteraction{
    NSString *signClassId = NSStringFormat(@"%ld",[[kUserDefaults valueForKey:@"signClazzId"] integerValue]);
    
    NSDictionary *params = self.lessonModel?@{@"clazzId":signClassId.length==0?@"0":signClassId, @"lessonId":NSStringFormat(@"%ld",self.lessonModel.ID)} : self.signDict;
    
    if (isToInteraction) {
        [MBProgressHUD showMessage:@""];
    }
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/lesson/status/my",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        wself.dataDict = responseObject;
        wself.interactionBtn.hidden = NO;
        
        [MBProgressHUD hideHUD];
        if (!isToInteraction) {
            //            if ([responseObject[@"myStatus"] integerValue] == 2) {
            wself.interactionBtn.alpha = 1;
            wself.interactionBtn.userInteractionEnabled = YES;
            wself.lookAnswerPaper.hidden = NO;
            wself.lookAnswerPaper.frame = Rect(29*FITWIDTH, wself.interactionBtn.y, (kViewW - 56*FITWIDTH)/2, wself.interactionBtn.height);
            [wself.lookAnswerPaper setBackgroundImage:GetImage(@"common_btn_left") forState:UIControlStateNormal];
            [wself.interactionBtn setTitle:@"进入互动" forState:UIControlStateNormal];
            
            wself.interactionBtn.frame = Rect(MaxX(wself.lookAnswerPaper), wself.interactionBtn.y, (kViewW - 56*FITWIDTH)/2, wself.interactionBtn.height);
            [wself.interactionBtn setBackgroundImage:GetImage(@"common_btn_right") forState:UIControlStateNormal];
            //            }else{
            //                wself.lookAnswerPaper.hidden = YES;
            //
            //                [wself.interactionBtn setTitle:@"未发起互动" forState:UIControlStateNormal];
            //                wself.interactionBtn.alpha = 0.5;
            //                wself.interactionBtn.userInteractionEnabled = NO;
            //            }
            if ([responseObject[@"myStatus"] integerValue] == 0) {
                [wself.ts_navgationBar.rightButton setTitle:@"签到" forState:UIControlStateNormal];
                wself.ts_navgationBar.rightButton.userInteractionEnabled = YES;
            }else{
                [wself.ts_navgationBar.rightButton setTitle:@"已签到" forState:UIControlStateNormal];
                [wself.ts_navgationBar.rightButton setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
                wself.ts_navgationBar.rightButton.userInteractionEnabled = NO;
            }
            
            CGSize rightSize = [wself.ts_navgationBar.rightButton.titleLabel.text sizeWithFont:kBoldFont(14)];
            wself.ts_navgationBar.rightButton.size = CGSizeMake(rightSize.width, rightSize.height+16);
        }else{
            
            OCInteractionAnswerQuestionViewController *vc = [[OCInteractionAnswerQuestionViewController alloc] init];
            vc.classID = [[kUserDefaults valueForKey:@"signClazzId"] integerValue];
            vc.questionID = [self.dataDict[@"questionId"] integerValue];
            if ([wself.dataDict[@"type"] integerValue] == 1) {
                vc.isObj = YES;
            }else{
                vc.isObj = NO;
            }
            
            [wself.navigationController pushViewController:vc animated:YES];
        }
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}


@end
