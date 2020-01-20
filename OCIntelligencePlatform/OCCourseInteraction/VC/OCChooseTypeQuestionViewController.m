//
//  OCChooseTypeQuestionViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCChooseTypeQuestionViewController.h"
#import "OCSubObjQuestionModel.h"
#import "OCCourseOptionModel.h"
@interface OCChooseTypeQuestionViewController ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) OCSubObjQuestionModel *dataModel;

@property (copy, nonatomic) NSString *selectedOptionID;

@property (strong, nonatomic) NSMutableArray *btnArr;
@end

@implementation OCChooseTypeQuestionViewController

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"单选题" rightTitle:@"1分" rightAction:^{
        
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.ts_navgationBar.rightButton.titleLabel.font = kFont(12*FITWIDTH);
    [self.ts_navgationBar.rightButton setTitleColor:TEXT_COLOR_GRAY forState:UIControlStateNormal];

    
    [self requestObjQuestionData];
    
    [kNotificationCenter addObserver:self selector:@selector(receiveMessage:) name:@"socktReceiveMessageNotification" object:nil];
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

-(void)setupUI{
    if (self.dataModel.type == 1) {
        self.ts_navgationBar.titleLabel.text = @"单选题";
    }else if (self.dataModel.type == 2){
        self.ts_navgationBar.titleLabel.text = @"多选题";
    }else{
        self.ts_navgationBar.titleLabel.text = @"判断题";
    }
    
    [self.ts_navgationBar.rightButton setTitle:NSStringFormat(@"%ld分",self.dataModel.score) forState:UIControlStateNormal];
    
    self.titleLab = [UILabel labelWithText:self.dataModel.title font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH,kNavH + 24*FITWIDTH, 100, 18*FITWIDTH)];
    self.titleLab.font = kBoldFont(18*FITWIDTH);
    self.titleLab.size = [self.titleLab.text sizeWithFont:kBoldFont(18*FITWIDTH) maxW:kViewW-40*FITWIDTH];
    [self.view addSubview:self.titleLab];
    
    for (int i = 0; i<self.dataModel.optionList.count; i++) {
        OCCourseOptionModel *model = self.dataModel.optionList[i];
        UIButton *btn = [UIButton buttonWithTitle:NSStringFormat(@"%@.%@",model.opKey,model.opValue) titleColor:TEXT_COLOR_BLACK backgroundColor:RGBA(244, 244, 244, 1) font:16*FITWIDTH image:@"" target:self action:@selector(chooseClick:) frame:CGRectZero];
        btn.x = 20*FITWIDTH;
        btn.size = CGSizeMake(kViewW - 40*FITWIDTH, 48*FITWIDTH);
        btn.y = MaxY(self.titleLab)+40*FITWIDTH + (btn.height + 24*FITWIDTH)*i;
        btn.tag = 100+i;
        btn.layer.cornerRadius = 5;
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16*FITWIDTH, 0, 0);
        [self.btnArr addObject:btn];
        [self.view addSubview:btn];
    }
    
    
    UIButton *submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:nil frame:Rect(40*FITWIDTH, kViewH - 32*FITWIDTH - 48*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    [submitBtn addTarget:self action:@selector(submitClick:)];
    submitBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:submitBtn];
}

-(void)showAnswer{

    NSArray *optionIdList = [self.selectedOptionID componentsSeparatedByString:@","];
    for (int i = 0; i<self.dataModel.optionList.count; i++) {
        OCCourseOptionModel *model = self.dataModel.optionList[i];
        UIButton *btn = self.btnArr[i];
        if (model.correct == 1) {
            btn.backgroundColor = RGBA(95, 232, 154, 1);
        }

        for (int j = 0; j<optionIdList.count; j++) {
            NSInteger selectID = [optionIdList[j] integerValue];
            if (model.correct == 0 && selectID == model.optionId){
                btn.backgroundColor = RGBA(255, 141, 148, 1);
            }
        }

    }


}


#pragma mark - 网络请求
// 客观题详情
-(void)requestObjQuestionData{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/question/objective/%ld",kURL,APIInteractiveURl,self.questionID) parameters:@{} success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        wself.dataModel = [OCSubObjQuestionModel objectWithKeyValues:dict];
        [wself setupUI];
        
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

#pragma mark - 监听
-(void)receiveMessage:(NSNotification *)notification{
    NSDictionary *messageDic = notification.userInfo;

    dispatch_sync(dispatch_get_main_queue(), ^{
        NSInteger questionType = [messageDic[@"question_type"] integerValue];

        if ([messageDic[@"type"] integerValue] == 5) {
            [self showAnswer];
        }else{
            if (questionType == 2) {
                self.isMoreChoose = YES;
            }
            if ([messageDic[@"type"] integerValue] == 3) {
                NSDictionary *contentDic = [NSString stringConvertToDic:messageDic[@"content"]];
                self.classID = [contentDic[@"clazz_id"] integerValue];
            }
            self.questionID = [messageDic[@"question_id"] integerValue];
            
            for (UIView *view in self.view.subviews) {
                if (![view isKindOfClass:[TSNavigationBar class]]) {
                   [view removeFromSuperview];
                }
            }
            
            [self.btnArr removeAllObjects];
            [self requestObjQuestionData];
        }
    });
    
}
#pragma mark - action method
-(void)chooseClick:(UIButton *)sender{
    OCCourseOptionModel *model = self.dataModel.optionList[sender.tag - 100];

    if (self.isMoreChoose) {
        sender.backgroundColor = RGBA(198, 221, 255, 1);
        if (self.selectedOptionID.length == 0) {
            self.selectedOptionID = NSStringFormat(@"%ld",model.optionId);
        }else{
            self.selectedOptionID = [self.selectedOptionID stringByAppendingString:[NSString stringWithFormat:@",%ld",model.optionId]];
        }
    }else{
        self.selectedBtn.backgroundColor = RGBA(244, 244, 244, 1);
        sender.backgroundColor = RGBA(198, 221, 255, 1);
        self.selectedBtn = sender;
        self.selectedOptionID = NSStringFormat(@"%ld",model.optionId);
    }
}


-(void)submitClick:(UIButton *)sender{
    sender.alpha = 0.5;
    sender.userInteractionEnabled = NO;
    [sender setTitle:@"已提交" forState:UIControlStateNormal];
    
    for (UIButton *btn in self.btnArr) {
        btn.userInteractionEnabled = NO;
    }
    NSDictionary *params = @{@"optionId":self.selectedOptionID, @"questionId":NSStringFormat(@"%ld",self.questionID), @"clazzId":NSStringFormat(@"%ld",self.classID)};
    NSLog(@"%@",params);
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/question/objective/commit",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {

    } stateError:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } viewController:self];
}
@end
