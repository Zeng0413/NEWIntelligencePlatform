//
//  OCAuthCodeManager.m
//  OCPhoenix
//
//  Created by Alan on 2019/4/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCAuthCodeManager.h"

@implementation OCAuthCodeManager

+ (void)getVerifyCodeWithType:(NSString *)type
                       mobile:(NSString *)mobile
                       sender:(WGHCountDownButton *)sender
                      success:(nonnull void (^)(id _Nonnull))success {
    if (kStringIsEmpty(mobile)) {
        WGHLog(@"mobile 为空!");
        return;
    }
    if (kStringIsEmpty(type)) {
        WGHLog(@"type 为空!");
        return;
    }
    
    NSDictionary * dic = @{@"mobile":mobile,@"type":type};
    
    [MBProgressHUD showMessage:@""];
    
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@/v1/user/login/code",kURL,APIUserURL) parameters:nil success:^(id responseObject) {
        success(responseObject);
        NSLog(@"验证码----%@",responseObject[@"code"]);
    } stateError:^(id  _Nonnull responseObject) {
        [MBProgressHUD showError:responseObject[@"msg"]];
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError * _Nonnull error) {
    } viewController:nil];
}

@end
