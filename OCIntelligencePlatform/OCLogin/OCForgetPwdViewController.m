//
//  OCForgetPwdViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCForgetPwdViewController.h"

@interface OCForgetPwdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *telphoneHeadBtn;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *securePwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmSecurePwdBtn;

@property (nonatomic, strong) NSString * captchaId;

@property (strong, nonatomic) WGHCountDownButton *getCodeBtn;

@end

@implementation OCForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    self.telphoneTextField.text = self.phoneStr;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:self.titleStr backAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.getCodeBtn = [[WGHCountDownButton alloc] initWithFrame:Rect(253, 149, 74, 45)];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.getCodeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCodeBtn];

    [self.securePwdBtn setImage:[UIImage imageNamed:@"login_btn_eye"] forState:UIControlStateNormal];
    [self.securePwdBtn setImage:[UIImage imageNamed:@"login_btn_eye_open"] forState:UIControlStateSelected];
    
    [self.confirmSecurePwdBtn setImage:[UIImage imageNamed:@"login_btn_eye"] forState:UIControlStateNormal];
    [self.confirmSecurePwdBtn setImage:[UIImage imageNamed:@"login_btn_eye_open"] forState:UIControlStateSelected];
    
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 24;

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)confirmClick:(UIButton *)sender {
    BOOL flag = [self.telphoneTextField.text validateMobile];
    if (!flag) {
        [MBProgressHUD showError:@"请输入正确的手机号码！"];
        return;
    }
    
    if (self.telphoneTextField.text.length == 0 || self.codeTextFiled.text.length == 0 || self.pwdTextField.text.length == 0 || self.confirmPwdTextField.text.length == 0) {
        [MBProgressHUD showError:@"请把信息填入完整！"];
        return;
    }
    
    if (![self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
        [MBProgressHUD showError:@"两次密码不一致！"];
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"captchaId"] = self.captchaId;
    params[@"code"] = self.codeTextFiled.text;
    params[@"mobile"] = self.telphoneTextField.text;
    params[@"password"] = self.confirmPwdTextField.text;
    Weak;
    [APPRequest putRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/changePassword",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"修改成功！"];
        [wself.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
    } viewController:self];
}

- (IBAction)pwdSecureSwitchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !self.pwdTextField.secureTextEntry;
}
- (IBAction)confirmPwdSecureSwitchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.confirmPwdTextField.secureTextEntry = !self.confirmPwdTextField.secureTextEntry;
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
        [MBProgressHUD showSuccess:@"验证码发送成功！"];
        [self.codeTextFiled becomeFirstResponder];
        if (![OCPublicMethodManager isProduct]) {
            self.codeTextFiled.text = NSStringFormat(@"%@",responseObject[@"code"]);
        }
        
        [sender countDownFromTime:60 unitTitle:@" s" completion:^(WGHCountDownButton *countDownButton) {
        }];
    } stateError:^(id  _Nonnull responseObject) {
        [MBProgressHUD showError:responseObject[@"msg"]];
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError * _Nonnull error) {
    } viewController:nil];

}
@end
