//
//  OCCodeModificationPwdViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCodeModificationPwdViewController.h"
#import "OCPersonInformationViewController.h"

@interface OCCodeModificationPwdViewController ()
@property (strong, nonatomic) WGHCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, strong) NSString * captchaId;

@end

@implementation OCCodeModificationPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"修改密码" rightTitle:@"旧密码修改密码" rightAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.rightButton.titleFont = 10*FITWIDTH;
    [self.ts_navgationBar.rightButton setTitleColor:TEXT_COLOR_GRAY];
    
    self.telphoneTextField.text = SINGLE.userModel.phone;
    
    self.getCodeBtn = [[WGHCountDownButton alloc] initWithFrame:Rect(250, 163, 74, 45)];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.getCodeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCodeBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:@"" target:self action:@selector(confirmClick) frame:Rect(40*FITWIDTH, kViewH - 32*FITWIDTH - 48*FITWIDTH, kViewW - 80*FITWIDTH, 48*FITWIDTH)];
    confirmBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:confirmBtn];
}


#pragma mark - action method
-(void)confirmClick{
    if (self.telphoneTextField.text.length == 0) {
        [MBProgressHUD showText:@"请填写手机号码"];
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [MBProgressHUD showText:@"请填写验证码"];
        return;
    }
    
    if (![self.pwdTextField.text isEqualToString:self.againPwdTextField.text]) {
        [MBProgressHUD showText:@"两次输入的密码不一致"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"captchaId"] = self.captchaId;
    params[@"code"] = self.codeTextField.text;
    params[@"mobile"] = self.telphoneTextField.text;
    params[@"password"] = self.pwdTextField.text;
    Weak;
    [APPRequest putRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/changePassword",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"修改成功！"];
        [OCPublicMethodManager retureToViewcontroller:[OCPersonInformationViewController new] fromVC:self];
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)getCodeClick:(WGHCountDownButton *)sender{
    BOOL flag = [self.telphoneTextField.text validateMobile];
    if (!flag) {
        [MBProgressHUD showError:@"请输入正确的手机号码！"];
        return;
    }
    
    NSDictionary * dic = @{@"mobile":self.telphoneTextField.text,@"type":@"2"};
    
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/code",kURL,APIUserURL) parameters:dic success:^(id responseObject) {
        wself.captchaId = responseObject[@"captchaId"];
        wself.titleLab.text = @"已发送验证码到您的手机号";
        [MBProgressHUD showSuccess:@"验证码发送成功！"];
        [wself.codeTextField becomeFirstResponder];
        if (![OCPublicMethodManager isProduct]) {
            wself.codeTextField.text = NSStringFormat(@"%@",responseObject[@"code"]);
        }
        
        [sender countDownFromTime:60 unitTitle:@" s" completion:^(WGHCountDownButton *countDownButton) {
        }];
    } stateError:^(id  _Nonnull responseObject) {
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError * _Nonnull error) {
    } viewController:nil];
}

@end
