//
//  OCSolutionTypeQuestionViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSolutionTypeQuestionViewController.h"
#import "OCSubObjQuestionModel.h"

@interface OCSolutionTypeQuestionViewController ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIImageView *contentImg;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) OCSubObjQuestionModel *dataModel;

@end

@implementation OCSolutionTypeQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"简答题" rightTitle:@"1分" rightAction:^{
        
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.ts_navgationBar.rightButton.titleLabel.font = kFont(12*FITWIDTH);
    [self.ts_navgationBar.rightButton setTitleColor:TEXT_COLOR_GRAY forState:UIControlStateNormal];
    [kNotificationCenter addObserver:self selector:@selector(receiveMessage:) name:@"socktReceiveMessageNotification" object:nil];
    
    [self requestSubjQuestionData];
    [self setupUI];
}

-(void)receiveMessage:(NSNotification *)notification{
    NSDictionary *messageDic = notification.userInfo;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([messageDic[@"type"] integerValue] == 5) {
       
        }else{
            if ([messageDic[@"type"] integerValue] == 3) {
                NSDictionary *contentDic = [NSString stringConvertToDic:messageDic[@"content"]];
                self.classID = [contentDic[@"clazz_id"] integerValue];
            }
            self.questionID = [messageDic[@"question_id"] integerValue];
            
            [self requestSubjQuestionData];
        }
    });
    
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

-(void)setupUI{
    self.titleLab = [UILabel labelWithText:@"最好的编程语言是什么？" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH,kNavH + 24*FITWIDTH, 100, 18*FITWIDTH)];
    self.titleLab.font = kBoldFont(18*FITWIDTH);
    self.titleLab.size = [self.titleLab.text sizeWithFont:kBoldFont(18*FITWIDTH) maxW:kViewW-40*FITWIDTH];
    [self.view addSubview:self.titleLab];
    
    self.contentImg = [UIImageView imageViewWithUrl:nil frame:Rect(self.titleLab.x, MaxY(self.titleLab)+24*FITWIDTH, kViewW-40*FITWIDTH, 189*FITWIDTH)];
    self.contentImg.layer.cornerRadius = 4;
    self.contentImg.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.contentImg];
    
    self.contentTextView = [[UITextView alloc] initWithFrame:Rect(self.contentImg.x, MaxY(self.contentImg)+24*FITWIDTH, kViewW-40*FITWIDTH, 189*FITWIDTH)];
    self.contentTextView.zw_placeHolder = @"请输入发言";
    self.contentTextView.zw_placeHolderColor = TEXT_COLOR_GRAY;
    self.contentTextView.layer.borderColor = kBACKCOLOR.CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 4;
    self.contentTextView.font = kFont(14*FITWIDTH);
    [self.view addSubview:self.contentTextView];
    
    self.submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:nil target:self action:@selector(submitClick:) frame:Rect(40*FITWIDTH, kViewH-32*FITWIDTH-48*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    self.submitBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:self.submitBtn];
}

#pragma mark - 网络请求
-(void)requestSubjQuestionData{
    Weak;
    
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/question/subjective/%ld",kURL,APIInteractiveURl,self.questionID) parameters:@{} success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        wself.dataModel = [OCSubObjQuestionModel objectWithKeyValues:dict];
        wself.titleLab.text = wself.dataModel.title;
        [wself.contentImg sd_setImageWithURL:[NSURL URLWithString:[wself.dataModel.imgsList firstObject]]];
        [wself.ts_navgationBar.rightButton setTitle:NSStringFormat(@"%ld分",self.dataModel.score) forState:UIControlStateNormal];
        
        wself.submitBtn.userInteractionEnabled = YES;
        wself.submitBtn.alpha = 1.0;
        wself.contentTextView.userInteractionEnabled = YES;
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

-(void)submitClick:(UIButton *)sender{
    Weak;
    [OCPublicMethodManager checkWordsWithContent:self.contentTextView.text complete:^(id  _Nonnull result) {
        NSArray * illegalList = result[@"sensitiveWordsList"];
        if (illegalList.count > 0) {
            [MBProgressHUD showError:NSStringFormat(@"检测到敏感字符 %@",illegalList[0])];
        }else {
            sender.alpha = 0.5;
            sender.userInteractionEnabled = NO;
            [sender setTitle:@"已提交" forState:UIControlStateNormal];
            [wself submitAnswer];
        }
    }];
    
    
    
    
}

-(void)submitAnswer{
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

@end
