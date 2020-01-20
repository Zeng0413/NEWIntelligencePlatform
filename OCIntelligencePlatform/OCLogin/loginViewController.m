//
//  loginViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "loginViewController.h"
#import "OCForgetPwdViewController.h"
#import "OCPersonInfoViewController.h"
#import "OCUserModel.h"
#import "OCRootViewControllerViewController.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
#import "YYKit.h"
#import "TextLinePositionModifier.h"
#import "OCBaseWebViewController.h"

#define codeStr @"验证码登录"
#define pwdStr @"密码登录"
@interface loginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *changeBackView;
@property (weak, nonatomic) IBOutlet UIButton *telphoneHeaderBtn;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) WGHCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIView *verLineView;
@property (nonatomic, strong) NSString * captchaId;

@property (strong, nonatomic) UIButton *codeLoginBtn;
@property (strong, nonatomic) UIButton *pwdLoginBtn;
@property (strong, nonatomic) UIView *lineView;

@property (assign, nonatomic) BOOL isCodeLogin;

@property (strong, nonatomic)YYLabel *proLab;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCodeLogin = NO;
    self.loginBtn.userInteractionEnabled = YES;
    self.loginBtn.alpha = 1;
    self.codeTextField.secureTextEntry = YES;

    [self setupUI];
    
}

-(void)setupUI{
    self.telphoneTextField.placeholder  = @"输入您的手机号码/工号";
    self.codeTextField.placeholder = @"输入密码";
    self.telphoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.codeTextField.keyboardType = UIKeyboardTypeDefault;

    self.verLineView.hidden = YES;
    self.getCodeBtn = [[WGHCountDownButton alloc] initWithFrame:Rect(250, 235, 74, 45)];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.getCodeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeBtn.hidden = YES;
    [self.getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCodeBtn];
    
    self.codeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    CGSize codeSize = [codeStr sizeWithFont:[UIFont systemFontOfSize:12]];
    self.codeLoginBtn.size = codeSize;
    self.codeLoginBtn.x = kViewW/2+24;
    self.codeLoginBtn.y = 0;
    [self.codeLoginBtn setTitle:codeStr forState:UIControlStateNormal];
    [self.codeLoginBtn setTitleColor:RGBA(153, 153, 153, 1)];
    [self.codeLoginBtn addTarget:self action:@selector(chooseCodeLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.changeBackView addSubview:self.codeLoginBtn];
    
    self.pwdLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pwdLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    CGSize pwdSize = [pwdStr sizeWithFont:[UIFont boldSystemFontOfSize:18]];
    self.pwdLoginBtn.size = pwdSize;
    self.pwdLoginBtn.x = kViewW/2 - self.pwdLoginBtn.width - 24;
    self.pwdLoginBtn.centerY = self.codeLoginBtn.centerY;
    [self.pwdLoginBtn setTitle:pwdStr forState:UIControlStateNormal];
    [self.pwdLoginBtn setTitleColor:kAPPCOLOR];
    [self.pwdLoginBtn addTarget:self action:@selector(choosePwdLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.changeBackView addSubview:self.pwdLoginBtn];
    
    self.lineView = [UIView viewWithBgColor:kAPPCOLOR frame:CGRectZero];
    self.lineView.size = CGSizeMake(self.pwdLoginBtn.width, 2);
    self.lineView.centerX = self.pwdLoginBtn.centerX;
    self.lineView.y = self.changeBackView.height - self.lineView.height;
    [self.changeBackView addSubview:self.lineView];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 24;
    
    NSString *proStr = @"未注册用户登录时将自动创建账号，且代表您已经同意《用户服务协议》和《隐私政策》";
    self.proLab = [YYLabel new];
    self.proLab.size = [proStr sizeWithFont:kFont(10*FITWIDTH) maxW:kViewW - 84*FITWIDTH];
    self.proLab.y = kViewH - self.proLab.height - 24*FITWIDTH;
    self.proLab.x = 42*FITWIDTH;
    self.proLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    self.proLab.displaysAsynchronously = YES;
    self.proLab.ignoreCommonProperties = YES;
    self.proLab.fadeOnAsynchronouslyDisplay = NO;
    self.proLab.fadeOnHighlight = NO;
    self.proLab.userInteractionEnabled = YES;
    Weak;
    self.proLab.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *tempStr = [text.string substringWithRange:range];
        OCBaseWebViewController *vc = [[OCBaseWebViewController alloc] init];
        
        if ([tempStr isEqualToString:@"《用户服务协议》"]) {
            vc.titleStr = @"用户协议";
            vc.urlStr = @"http://www.oczhkj.com/privacy/ip_app.html";
        }else{
            vc.titleStr = @"隐私政策";
            vc.urlStr = @"http://www.oczhkj.com/userAgreement/ip.html";
        }
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
    NSMutableAttributedString *attributeStr = [NSMutableAttributedString textWithStr:proStr fontSize:10*FITWIDTH textColor:RGBA(153, 153, 153, 1) withHightStrArr:@[@"《用户服务协议》",@"《隐私政策》"]];
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = kFont(10*FITWIDTH);
    modifier.paddingTop = 0;
    modifier.paddingBottom = 0;
    modifier.lineHeightMultiple = 1.34;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(self.proLab.width, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributeStr];
    self.proLab.textLayout = textLayout;
    
    [self.view addSubview:self.proLab];
}

#pragma mark -- textField delegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSInteger mobileCount = self.telphoneTextField.text.length;
//    NSInteger codeCount = self.codeTextField.text.length;
//    if ([textField isEqual:_telphoneTextField]) {
//        if (kStringIsEmpty(string)) {
//            mobileCount --;
//        }else {
//            mobileCount += string.length;
//        }
//    }else {
//        if (kStringIsEmpty(string)) {
//            codeCount --;
//        }else {
//            codeCount += string.length;
//        }
//    }
//    if (mobileCount >= 11 && codeCount >= 4) {
//        self.loginBtn.userInteractionEnabled = YES;
//        self.loginBtn.alpha = 1;
//    }else {
//        self.loginBtn.userInteractionEnabled = NO;
//        self.loginBtn.alpha = 0.5;
//    }
//    return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (_telphoneTextField.text.length >= 11 && _codeTextField.text.length >= 4) {
//        self.loginBtn.userInteractionEnabled = YES;
//        self.loginBtn.alpha = 1;
//    }else {
//        self.loginBtn.userInteractionEnabled = NO;
//        self.loginBtn.alpha = 0.5;
//    }
//}

#pragma mark -- action method
-(void)chooseCodeLogin{
    
    [self.view endEditing:YES];
    self.codeTextField.text = @"";
    self.isCodeLogin = YES;
    self.codeTextField.secureTextEntry = NO;
    
    self.codeLoginBtn.y = 0;
    self.codeLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.codeLoginBtn.size = [codeStr sizeWithFont:[UIFont boldSystemFontOfSize:18]];
    [self.codeLoginBtn setTitleColor:kAPPCOLOR];
    
    self.pwdLoginBtn.centerY = self.codeLoginBtn.centerY;
    self.pwdLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.pwdLoginBtn.size = [pwdStr sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.pwdLoginBtn setTitleColor:RGBA(153, 153, 153, 1)];
    
    self.telphoneTextField.placeholder = @"输入您的手机号码";
    self.codeTextField.placeholder = @"输入验证码";
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.getCodeBtn.hidden = NO;
    self.verLineView.hidden = NO;
    
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;

    Weak;
    [UIView animateWithDuration:0.5 animations:^{
        wself.lineView.size = CGSizeMake(wself.codeLoginBtn.width, 2);
        wself.lineView.centerX = wself.codeLoginBtn.centerX;
    } completion:nil];
    
}

-(void)choosePwdLogin{
    [self.view endEditing:YES];

    self.codeTextField.text = @"";
    self.isCodeLogin = NO;
    self.codeTextField.secureTextEntry = YES;
    
    self.pwdLoginBtn.y = 0;
    self.pwdLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.pwdLoginBtn.size = [pwdStr sizeWithFont:[UIFont boldSystemFontOfSize:18]];
    [self.pwdLoginBtn setTitleColor:kAPPCOLOR];
 
    self.codeLoginBtn.centerY = self.pwdLoginBtn.centerY;
    self.codeLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.codeLoginBtn.size = [codeStr sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.codeLoginBtn setTitleColor:RGBA(153, 153, 153, 1)];
    
    self.telphoneTextField.placeholder = @"输入您的手机号码/工号";
    self.codeTextField.placeholder = @"输入密码";
    self.codeTextField.keyboardType = UIKeyboardTypeDefault;

    self.getCodeBtn.hidden = YES;
    self.verLineView.hidden = YES;
    
    Weak;
    [UIView animateWithDuration:0.5 animations:^{
        wself.lineView.size = CGSizeMake(wself.pwdLoginBtn.width, 2);
        wself.lineView.centerX = wself.pwdLoginBtn.centerX;
    } completion:nil];
    
}
- (IBAction)loginAction:(id)sender {
    
    if (!self.isCodeLogin) {
        
        if (self.codeTextField.text.length==0) {
            [MBProgressHUD showError:@"请输入正确的密码！"];
            return;
        }
        
        NSDictionary *dic = @{@"phone":self.telphoneTextField.text, @"password":self.codeTextField.text};
        [self userPwdLogin:dic];
    }else{
        BOOL flag = [self.telphoneTextField.text validateMobile];
        if (!flag) {
            [MBProgressHUD showError:@"请输入正确的手机号码！"];
            return;
        }
        [self userCodeLogin];
    }
}
- (IBAction)forgetPwdClick:(id)sender {
    OCForgetPwdViewController *vc = [[OCForgetPwdViewController alloc] init];
    vc.titleStr = @"忘记密码";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------- 私有方法
-(void)userCodeLogin{
//    [self changeAppIconWithName:@"teacher"];

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
    params[@"type"] = @"1";
    [MBProgressHUD showMessage:@"正在登陆..."];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/login/codeLogin",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        
        [NSDictionary bg_removeValueForKey:@"userInfoData"];
        
        [OCUserModel handleLoginData:responseObject];
        SINGLE.userModel = [OCUserModel objectWithKeyValues:responseObject];

        [NSDictionary bg_setValue:responseObject forKey:@"userInfoData"];
        
        if ([SINGLE.userModel.isNewUser integerValue] == 1) {
            OCPersonInfoViewController *vc = [[OCPersonInfoViewController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            OCRootViewControllerViewController *rootTab = [[OCRootViewControllerViewController alloc] init];
            TSNavigationController *tabNav = [[TSNavigationController alloc] initWithRootViewController:rootTab];
            [UIApplication sharedApplication].delegate.window.rootViewController = tabNav;
        }
        
        [[SocketRocketUtility instance] SRSocketOpen];
        
        [wself setTageAndAlias];

    } stateError:^(id responseObject) {
        [MBProgressHUD showError:responseObject[@"msg"]];

        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
    } viewController:self];
}

- (void)changeAppIconWithName:(NSString *)iconName {
    if (@available(iOS 10.3, *)) {
        if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
            return;
        }
    } else {
        // Fallback on earlier versions
    }
    
    if ([iconName isEqualToString:@""]) {
        iconName = nil;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}

-(void)userPwdLogin:(NSDictionary *)dic{
//    [self changeAppIconWithName:@"1024"];
    
    if (!dic) {
        
        WGHLog(@"登录数据为空！");
        return;
    }
    NSString * newUrl = NSStringFormat(@"%@/%@v1/user/login",kURL,APIUserURL);
    [MBProgressHUD showMessage:@"正在登陆..."];
    
    Weak;
    [APPRequest postRequestWithUrl:newUrl parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [NSDictionary bg_removeValueForKey:@"userInfoData"];
        [OCUserModel handleLoginData:responseObject];
        SINGLE.userModel = [OCUserModel objectWithKeyValues:responseObject];
        [NSDictionary bg_setValue:responseObject forKey:@"userInfoData"];
        
        if ([SINGLE.userModel.isNewUser integerValue] == 1) {
            OCPersonInfoViewController *vc = [[OCPersonInfoViewController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            OCRootViewControllerViewController *rootTab = [[OCRootViewControllerViewController alloc] init];
            TSNavigationController *tabNav = [[TSNavigationController alloc] initWithRootViewController:rootTab];
            [UIApplication sharedApplication].delegate.window.rootViewController = tabNav;
        }
        
        [[SocketRocketUtility instance] SRSocketOpen];
        
        [wself setTageAndAlias];
    } stateError:^(id responseObject) {
        [MBProgressHUD showError:responseObject[@"msg"]];
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
    
    NSDictionary * dic = @{@"mobile":self.telphoneTextField.text,@"type":@"1"};
    
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

-(void)setTageAndAlias{
    if (SINGLE.userModel.type == 1) {
        [JPUSHService setTags:[NSSet setWithObjects:NSStringFormat(@"%ld",SINGLE.userModel.collegeId),NSStringFormat(@"%ld",SINGLE.userModel.clazzId), nil] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%tu,%@,%tu",iResCode,iTags,seq);
        } seq:0];
    }else{
        [JPUSHService setTags:[NSSet setWithObject:NSStringFormat(@"%ld",SINGLE.userModel.collegeId)] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%tu,%@,%tu",iResCode,iTags,seq);
        } seq:0];
    }
    
    
    [JPUSHService setAlias:SINGLE.userModel.userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"%tu,%@,%tu",iResCode,iAlias,seq);
    } seq:0];
}

+ (void)checkToken:(void (^)(BOOL success))success {
    NSString *token = [kUserDefaults valueForKey:@"token"];
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/app/checkToken/%@",kURL,APIUserURL,token) parameters:nil success:^(id responseObject) {
        NSInteger flag = [responseObject[@"available"] integerValue];
        success(flag);
    } stateError:^(id responseObject) {
        success(NO);
        [OCUserModel clearUserData];
    } failure:^(NSError *error) {
        success(NO);
        [OCUserModel clearUserData];
    } viewController:nil needCache:NO];
}


@end
