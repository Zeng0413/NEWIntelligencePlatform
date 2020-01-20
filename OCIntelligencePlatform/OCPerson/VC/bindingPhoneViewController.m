//
//  bindingPhoneViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/31.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "bindingPhoneViewController.h"

@interface bindingPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) WGHCountDownButton *getCodeBtn;
@property (nonatomic, strong) NSString * captchaId;

@end

@implementation bindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"修改手机" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.submitBtn.layer.cornerRadius = 24;
    
    self.getCodeBtn = [[WGHCountDownButton alloc] initWithFrame:Rect(255, 136, 74, 45)];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.getCodeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCodeBtn];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)submitClick:(id)sender {
    if (_telphoneTextField.text.length < 11) {
        [MBProgressHUD showText:@"请输入正确的手机号码！"];
        return;
    }
    
    if (kStringIsEmpty(_captchaId)) {
        [MBProgressHUD showText:@"验证码状态错误！"];
        return;
    }
    
    if (_codeTextField.text.length < 4) {
        [MBProgressHUD showText:@"请输入正确的验证码！"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"captchaId"] = self.captchaId;
    params[@"code"] = self.codeTextField.text;
    params[@"mobile"] = self.telphoneTextField.text;
    params[@"type"] = @"3";
    
    Weak;
    [APPRequest putRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/changePhone",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        NSMutableDictionary *userData = [[NSDictionary bg_valueForKey:@"userInfoData"] mutableCopy];
        userData[@"phone"] = self.telphoneTextField.text;
        [NSDictionary bg_updateValue:userData forKey:@"userInfoData"];
        SINGLE.userModel = [OCUserModel objectWithKeyValues:userData];
        
        if (wself.block) {
            wself.block();
        }
        [MBProgressHUD showSuccess:@"修改成功！"];
        [wself.navigationController popViewControllerAnimated:YES];
    } stateError:^(id responseObject) {
        [MBProgressHUD showSuccess:responseObject[@"msg"]];
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)returnBlock:(changePhonebackBlock)block{
    self.block = block;
}
-(void)getCodeClick:(WGHCountDownButton *)sender{
    BOOL flag = [self.telphoneTextField.text validateMobile];
    if (!flag) {
        [MBProgressHUD showError:@"请输入正确的手机号码！"];
        return;
    }
    
    NSDictionary * dic = @{@"mobile":self.telphoneTextField.text,@"type":@"3"};
    
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/code",kURL,APIUserURL) parameters:dic success:^(id responseObject) {
        wself.captchaId = responseObject[@"captchaId"];
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
