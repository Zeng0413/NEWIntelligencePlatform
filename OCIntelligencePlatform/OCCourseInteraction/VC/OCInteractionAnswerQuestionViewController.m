//
//  OCInteractionAnswerQuestionViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCInteractionAnswerQuestionViewController.h"
#import "OCSubObjQuestionModel.h"
#import "OCCourseOptionModel.h"
@interface OCInteractionAnswerQuestionViewController ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) OCSubObjQuestionModel *dataModel;

@property (copy, nonatomic) NSString *selectedOptionID;

@property (strong, nonatomic) NSMutableArray *btnArr;
@property (strong, nonatomic) UILabel *resultStatus;
@property (strong, nonatomic) UIImageView *contentImg;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIButton *submitBtn;

@property (strong, nonatomic) UIButton *objSubmitBtn;

@property (strong, nonatomic) NSDictionary *lastDict;

@property (strong, nonatomic) NSMutableArray *answerArr;

@end

@implementation OCInteractionAnswerQuestionViewController

-(NSMutableArray *)answerArr{
    if (!_answerArr) {
        _answerArr = [NSMutableArray array];
    }
    return _answerArr;
}

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
    
    if (self.isObj) {
        [self requestObjQuestionData];
    }else{
        [self requestSubjQuestionData];
    }
    
    [kNotificationCenter addObserver:self selector:@selector(receiveMessage:) name:@"socktReceiveMessageNotification" object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];



}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

#pragma mark - view figure
-(void)setSubjUI{
    if (self.dataModel.type == 1) {
        self.ts_navgationBar.titleLabel.text = @"问答题";
    }else if (self.dataModel.type == 2){
        self.ts_navgationBar.titleLabel.text = @"分组讨论";
    }else{
        self.ts_navgationBar.titleLabel.text = @"自由讨论";
    }
    [self.ts_navgationBar.rightButton setTitle:NSStringFormat(@"%ld分",self.dataModel.score) forState:UIControlStateNormal];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, kNavH+24*FITWIDTH, kViewW, kViewH-(kNavH+24*FITWIDTH)- 80*FITWIDTH)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    self.titleLab = [UILabel labelWithText:self.dataModel.title font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH,0, 100, 18*FITWIDTH)];
    self.titleLab.font = kBoldFont(18*FITWIDTH);
    self.titleLab.numberOfLines = 0;
    self.titleLab.size = [self.titleLab.text sizeWithFont:kBoldFont(18*FITWIDTH) maxW:kViewW-40*FITWIDTH];
    [scrollView addSubview:self.titleLab];
    
    NSString *imageUrl = [self.dataModel.imgsList firstObject];
    
    UIScrollView *imgScrollView = [UIScrollView scrollViewWithBgColor:WHITE frame:Rect(self.titleLab.x, MaxY(self.titleLab)+24*FITWIDTH, kViewW-40*FITWIDTH, 189*FITWIDTH)];
    for (int i = 0; i<self.dataModel.imgsList.count; i++) {
        CGFloat imgH = 169*FITWIDTH;
        if (self.dataModel.imgsList.count==1) {
            imgH = 189*FITWIDTH;
        }
        UIImageView *img = [UIImageView imageViewWithUrl:[NSURL URLWithString:self.dataModel.imgsList[i]] frame:Rect(0, (imgH+10*FITWIDTH)*i, imgScrollView.width, imgH)];
        img.layer.cornerRadius = 4;
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.backgroundColor = [UIColor clearColor];
        [imgScrollView addSubview:img];
        
        if (i == self.dataModel.imgsList.count - 1) {
            imgScrollView.contentSize = CGSizeMake(0, MaxY(img));
        }
    }
    [scrollView addSubview:imgScrollView];
    
    self.contentTextView = [[UITextView alloc] initWithFrame:Rect(self.titleLab.x, MaxY(self.contentImg)+24*FITWIDTH, kViewW-40*FITWIDTH, 189*FITWIDTH)];
    if (self.dataModel.imgsList.count == 0) {
        self.contentImg.hidden = YES;
        self.contentTextView.y = MaxY(self.titleLab)+24*FITWIDTH;
    }else{
        self.contentImg.hidden = NO;
        self.contentTextView.y = MaxY(imgScrollView)+24*FITWIDTH;
    }
    self.contentTextView.zw_placeHolder = @"请输入发言";
    self.contentTextView.zw_placeHolderColor = TEXT_COLOR_GRAY;
    self.contentTextView.layer.borderColor = kBACKCOLOR.CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 4;
    self.contentTextView.font = kFont(14*FITWIDTH);
    [scrollView addSubview:self.contentTextView];
    
    scrollView.contentSize = CGSizeMake(0, MaxY(self.contentTextView)+12*FITWIDTH);
    [self.view addSubview:scrollView];
    
    self.submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:nil target:self action:@selector(subjSubmitClick:) frame:Rect(40*FITWIDTH, kViewH-32*FITWIDTH-48*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    self.submitBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:self.submitBtn];
}

-(void)setupObjUI{
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
    self.titleLab.numberOfLines = 0;
    self.titleLab.size = [self.titleLab.text sizeWithFont:kBoldFont(18*FITWIDTH) maxW:kViewW-40*FITWIDTH];
    [self.view addSubview:self.titleLab];
    
    self.objSubmitBtn = [UIButton buttonWithTitle:@"提交" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:nil frame:Rect(40*FITWIDTH, kViewH - 32*FITWIDTH - 48*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    [self.objSubmitBtn addTarget:self action:@selector(objSubmitClick:)];
    self.objSubmitBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:self.objSubmitBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, MaxY(self.titleLab)+30*FITWIDTH, kViewW, kViewH - (MaxY(self.titleLab)+30*FITWIDTH) - 80*FITWIDTH)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    UIButton *lastBtn = nil;
    for (int i = 0; i<self.dataModel.optionList.count; i++) {
        OCCourseOptionModel *model = self.dataModel.optionList[i];
        UIButton *btn = [UIButton buttonWithTitle:NSStringFormat(@"%@.%@",model.opKey,model.opValue) titleColor:TEXT_COLOR_BLACK backgroundColor:RGBA(244, 244, 244, 1) font:16*FITWIDTH image:@"" target:self action:@selector(chooseClick:) frame:CGRectZero];
        btn.titleLabel.numberOfLines = 0;
        btn.x = 20*FITWIDTH;
        
        CGSize btnSize = [btn.titleLabel.text sizeWithFont:kFont(16*FITWIDTH) maxW:kViewW-40*FITWIDTH];
        
        btn.size = CGSizeMake(kViewW - 40*FITWIDTH, btnSize.height+20*FITWIDTH);
        if (i == 0) {
            btn.y = 20*FITWIDTH;
        }else{
            btn.y = MaxY(lastBtn)+24*FITWIDTH;
        }
        btn.tag = 100+i;
        btn.layer.cornerRadius = 5;
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16*FITWIDTH, 0, 0);
        [self.btnArr addObject:btn];
        [scrollView addSubview:btn];
        lastBtn = btn;
        
        if (i == self.dataModel.optionList.count - 1) {
            self.resultStatus = [UILabel labelWithText:@"" font:16*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(0, MaxY(btn)+48*FITWIDTH, kViewW, 16*FITWIDTH)];
            self.resultStatus.textAlignment = NSTextAlignmentCenter;
            self.resultStatus.hidden = YES;
            [scrollView addSubview:self.resultStatus];
            
            scrollView.contentSize = CGSizeMake(0, MaxY(self.resultStatus)+10*FITWIDTH);
        }
    }
    [self.view addSubview:scrollView];
}

-(void)hideAnswer{
    for (UIButton *btn in self.btnArr) {
        btn.backgroundColor = RGBA(244, 244, 244, 1);
    }
    self.resultStatus.hidden = YES;
}

-(void)showAnswer{
    BOOL haveError = NO;
    
    NSInteger selectCorrectNum = 0;
    NSInteger correctNum = 0;
    NSArray *optionIdList = [self.selectedOptionID componentsSeparatedByString:@","];
    for (int i = 0; i<self.dataModel.optionList.count; i++) {
        OCCourseOptionModel *model = self.dataModel.optionList[i];
        UIButton *btn = self.btnArr[i];
        if (model.correct == 1) {
            btn.backgroundColor = RGBA(95, 232, 154, 1);
        }
        if (model.correct==1) {
            correctNum = correctNum + 1;
        }
        
        for (int j = 0; j<optionIdList.count; j++) {
            NSInteger selectID = [optionIdList[j] integerValue];
            if (model.correct == 0 && selectID == model.optionId){
                btn.backgroundColor = RGBA(255, 141, 148, 1);
                haveError = YES;
            }else if (model.correct == 1 && selectID == model.optionId){
                selectCorrectNum = selectCorrectNum+1;
            }
        }
        
    }
    
    self.objSubmitBtn.hidden = YES;
    self.resultStatus.hidden = NO;
    self.resultStatus.text = haveError?@"回答错误":@"回答正确";
    if (self.isMoreChoose) {
        self.resultStatus.text = selectCorrectNum==correctNum?@"回答正确":@"回答错误";
    }
    if (self.selectedOptionID.length == 0) {
        self.resultStatus.text = @"未回答";
    }
}

#pragma mark - action method

-(void)subjSubmitClick:(UIButton *)sender{
    if (self.contentTextView.text.length==0) {
        [MBProgressHUD showText:@"请输入内容！"];
        return;
    }
    
    sender.alpha = 0.5;
    sender.userInteractionEnabled = NO;
    [sender setTitle:@"已提交" forState:UIControlStateNormal];
    
    self.contentTextView.userInteractionEnabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"answerContent"] = self.contentTextView.text;
    params[@"discussId"] = NSStringFormat(@"%ld",self.questionID);
    params[@"clazzId"] = NSStringFormat(@"%ld",self.classID);
    
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/question/subjective/commit",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)chooseClick:(UIButton *)sender{
    OCCourseOptionModel *model = self.dataModel.optionList[sender.tag - 100];
    
    if (self.isMoreChoose) {
        if (sender.selected) {
            sender.backgroundColor = RGBA(244, 244, 244, 1);
            if (self.answerArr.count>0) {
                [self.answerArr removeObject:model];
            }
            
            
        }else{
            [self.answerArr addObject:model];
            sender.backgroundColor = RGBA(198, 221, 255, 1);
        }
//            [self.answerArr addObject:model];
//            sender.backgroundColor = RGBA(198, 221, 255, 1);
        
        sender.selected = !sender.selected;

    }else{
        self.selectedBtn.backgroundColor = RGBA(244, 244, 244, 1);
        sender.backgroundColor = RGBA(198, 221, 255, 1);
        self.selectedBtn = sender;
        self.selectedOptionID = NSStringFormat(@"%ld",model.optionId);
    }
}

-(void)objSubmitClick:(UIButton *)sender{
    
    if (self.isMoreChoose) {
        for (OCCourseOptionModel *model in self.answerArr) {
            if (self.selectedOptionID.length == 0) {
                self.selectedOptionID = NSStringFormat(@"%ld",model.optionId);
            }else{
                self.selectedOptionID = [self.selectedOptionID stringByAppendingString:[NSString stringWithFormat:@",%ld",model.optionId]];
            }
        }
    }
    
    if (self.selectedOptionID.length==0) {
        [MBProgressHUD showText:@"请选择答案！"];
        return;
    }
    
    sender.alpha = 0.5;
    sender.userInteractionEnabled = NO;
    [sender setTitle:@"已提交" forState:UIControlStateNormal];
    
    for (UIButton *btn in self.btnArr) {
        btn.userInteractionEnabled = NO;
    }
    
    NSDictionary *params = @{@"optionId":self.selectedOptionID, @"questionId":NSStringFormat(@"%ld",self.questionID), @"clazzId":NSStringFormat(@"%ld",self.classID)};
   
    [self.answerArr removeAllObjects];
    
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/question/objective/commit",kURL,APIInteractiveURl) parameters:params success:^(id responseObject) {
        
    } stateError:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } viewController:self];
}

#pragma mark - 监听
-(void)receiveMessage:(NSNotification *)notification{
    NSDictionary *messageDic = notification.userInfo;
    
    if ([messageDic[@"type"] integerValue] == 8) {// 心跳返回数据
        return;
    }
    if (![messageDic isEqual:self.lastDict]) {
        NSInteger questionType = [messageDic[@"question_type"] integerValue];
        if (questionType == 1 || questionType == 2 || questionType == 3) { // 0客观题
            self.isObj = YES;
        }else{
            self.isObj = NO;
        }
        
        if (self.isObj) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSInteger questionType = [messageDic[@"question_type"] integerValue];
                
                if ([messageDic[@"type"] integerValue] == 5) { // 结束答题
                    [MBProgressHUD showText:@"答题结束"];
                    
                }else if ([messageDic[@"type"] integerValue] == 6){ // 公布答案
                    [self showAnswer];
                }else if ([messageDic[@"type"] integerValue] == 7){ // 隐藏答案
                    [self hideAnswer];
                }else{
                    self.selectedOptionID = @"";
                    self.selectedBtn = nil;
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
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([messageDic[@"type"] integerValue] == 5) {
                    [MBProgressHUD showText:@"答题结束"];
                }else if ([messageDic[@"type"] integerValue] == 6){ // 公布答案
                    return ;
                }else if ([messageDic[@"type"] integerValue] == 7){ // 隐藏答案
                    return ;
                }else{
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
                    [self requestSubjQuestionData];
                }
            });
        }
    }
    if ([messageDic[@"type"] integerValue] != 5 || [messageDic[@"type"] integerValue] != 6 || [messageDic[@"type"] integerValue] != 7) {
        self.lastDict = messageDic;
    }else{
        self.lastDict = nil;
    }
    
}

#pragma mark - 网络请求
-(void)requestSubjQuestionData{
    Weak;
    
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/question/subjective/%ld",kURL,APIInteractiveURl,self.questionID) parameters:@{} success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        wself.dataModel = [OCSubObjQuestionModel objectWithKeyValues:dict];
        [wself setSubjUI];
        
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}
// 请求客观题数据
-(void)requestObjQuestionData{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/question/objective/%ld",kURL,APIInteractiveURl,self.questionID) parameters:@{} success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        wself.dataModel = [OCSubObjQuestionModel objectWithKeyValues:dict];
        wself.isMoreChoose = wself.dataModel.type==2?YES:NO;
        [wself setupObjUI];
        
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

@end
