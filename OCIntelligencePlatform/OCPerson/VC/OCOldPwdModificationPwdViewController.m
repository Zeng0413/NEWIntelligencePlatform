//
//  OCOldPwdModificationPwdViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOldPwdModificationPwdViewController.h"
#import "OCCodeModificationPwdViewController.h"

@interface OCOldPwdModificationPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *againNewPwdTextField;

@end

@implementation OCOldPwdModificationPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"修改密码" rightTitle:@"验证码修改密码" rightAction:^{
        OCCodeModificationPwdViewController *vc = [[OCCodeModificationPwdViewController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    } backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    self.ts_navgationBar.rightButton.titleFont = 10*FITWIDTH;
    [self.ts_navgationBar.rightButton setTitleColor:TEXT_COLOR_GRAY];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:WHITE backgroundColor:kAPPCOLOR font:16*FITWIDTH image:@"" target:self action:@selector(confirmClick) frame:Rect(40*FITWIDTH, kViewH - 32*FITWIDTH - 48*FITWIDTH, kViewW - 80*FITWIDTH, 48*FITWIDTH)];
    confirmBtn.layer.cornerRadius = 24*FITWIDTH;
    [self.view addSubview:confirmBtn];
}

-(void)confirmClick{
    if (self.oldPwdTextField.text.length == 0) {
        [MBProgressHUD showText:@"请填写原密码"];
        return;
    }
    
    if (self.NewPwdTextField.text.length == 0) {
        [MBProgressHUD showText:@"请填写新密码"];
        return;
    }
    
    if (self.againNewPwdTextField.text.length == 0) {
        [MBProgressHUD showText:@"请再次填写新密码"];
        return;
    }
    
    if (![self.NewPwdTextField.text isEqualToString:self.againNewPwdTextField.text]) {
        [MBProgressHUD showText:@"两次输入的密码不一致"];
        return;
    }
    
    Weak;
    [MBProgressHUD showMessage:@""];
    NSDictionary *params = @{@"password":self.NewPwdTextField.text, @"passwordOld":self.oldPwdTextField.text};
    [APPRequest putRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/changePwd/old",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        if (responseObject) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [wself.navigationController popViewControllerAnimated:YES];
        }
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
