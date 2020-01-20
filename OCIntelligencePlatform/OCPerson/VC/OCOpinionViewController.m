//
//  OCOpinionViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOpinionViewController.h"

@interface OCOpinionViewController ()

@property (strong, nonatomic) UITextView *contentTextView;


@end

@implementation OCOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"意见反馈" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [self setupUI];
}

-(void)setupUI{
    UIView *backView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(20*FITWIDTH, kNavH+24*FITWIDTH, kViewW-40*FITWIDTH, 231*FITWIDTH)];
    backView.layer.cornerRadius = 4;
    [self.view addSubview:backView];
    
    self.contentTextView = [[UITextView alloc] initWithFrame:Rect(16*FITWIDTH, 16*FITWIDTH, backView.width-32*FITWIDTH, backView.height-32*FITWIDTH)];
    self.contentTextView.zw_placeHolder = @"请填写你的意见或建议";
    self.contentTextView.zw_placeHolderColor = RGBA(153, 153, 153, 1);
    self.contentTextView.backgroundColor = kBACKCOLOR;
    self.contentTextView.font = kFont(14*FITWIDTH);
    [backView addSubview:self.contentTextView];
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"提交" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:nil target:self action:@selector(confirmClick) frame:Rect(40*FITWIDTH, kViewH-32*FITWIDTH-48*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    confirmBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:confirmBtn];
}

-(void)confirmClick{
    if (self.contentTextView.text.length == 0) {
        [MBProgressHUD showText:@"请输入内容！"];
        return;
    }
    Weak;
    [OCPublicMethodManager checkWordsWithContent:self.contentTextView.text complete:^(id  _Nonnull result) {
        NSArray * illegalList = result[@"sensitiveWordsList"];
        if (illegalList.count > 0) {
            [MBProgressHUD showError:NSStringFormat(@"检测到敏感字符 %@",illegalList[0])];
        }else {
            [wself submitOpinion];
        }
    }];
    NSLog(@"提交");
}

-(void)submitOpinion{
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/feedback",kURL,APIUserURL) parameters:@{@"content":self.contentTextView.text} success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"提交成功"];
        [wself.navigationController popViewControllerAnimated:YES];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}
@end
