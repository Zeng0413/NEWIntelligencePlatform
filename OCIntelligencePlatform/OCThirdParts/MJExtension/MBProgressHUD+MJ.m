//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"
#import "LOTAnimationView.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
    hud.label.text = text ? text : @"错误信息！";
    hud.label.textAlignment = NSTextAlignmentCenter;
    hud.label.numberOfLines = 2;
    // 设置图片
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
    if (!image) {
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = WHITE;
        image = GetImage(icon);
    }
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
//    [hud hide:YES afterDelay:2];
    [hud hideAnimated:YES afterDelay:text.length * 0.2];
}

- (void)hidHud {
    [MBProgressHUD hideHUD];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view icon:(NSString *)icon {
    [self show:success icon:icon view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
////    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
////    hud.bezelView.backgroundColor = RGBA(0, 0, 0, 0.4);
//    hud.label.text = message;
//    hud.minSize = CGSizeMake(100, 100);
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    
        LOTAnimationView *anmiation = [LOTAnimationView animationNamed:@"data"];
        anmiation.backgroundColor = [UIColor clearColor];
        anmiation.frame = CGRectMake(0, 0, 150, 30);
    anmiation.loopAnimation = YES;
    [anmiation playFromProgress:0.25 toProgress:1 withCompletion:^(BOOL animationFinished) {
            }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = CLEAR;
    hud.minSize = CGSizeMake(150,150);//定义弹窗的大小
//    UIImageView * mainImageView= [[UIImageView alloc] initWithImage:GetImage(@"loading_1")];
//    mainImageView.animationImages = [NSArray arrayWithObjects:
//                                     [UIImage imageNamed:@"loading_1"],
//                                     [UIImage imageNamed:@"loading_2"],nil];
//    [mainImageView setAnimationDuration:0.4f];
//    [mainImageView setAnimationRepeatCount:0];
//    [mainImageView startAnimating];
    hud.customView = anmiation;
    hud.animationType = MBProgressHUDAnimationFade;
    
    
    
    return hud;
}

//只显示提示信息
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view {
	if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
	
	if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
	
	// 快速显示一个提示信息
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	hud.mode = MBProgressHUDModeText;
	
	hud.animationType = MBProgressHUDAnimationZoom;
	
	hud.label.text = text;
    hud.label.numberOfLines = 0;
	// 隐藏时候从父控件中移除
	hud.removeFromSuperViewOnHide = YES;
	// YES代表需要蒙版效果
	hud.dimBackground = YES;
	
	CGFloat time = text.length * 0.2 > 4 ? 4 : text.length * 0.2;
	
	[hud hideAnimated:YES afterDelay:time];
	
	return hud;
}

+ (MBProgressHUD *)showText:(NSString *)text {
    if ([self firstViewIsMBHud]) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showText:text toView:nil];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showText:text toView:nil];
        });
    }
	return nil;
}


+ (void)showSuccess:(NSString *)success
{
    if ([self firstViewIsMBHud]) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showSuccess:success toView:nil];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSuccess:success toView:nil];
        });
    }
}

+ (void)showError:(NSString *)error
{
    if ([self firstViewIsMBHud]) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showError:error toView:nil];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showError:error toView:nil];
        });
    }
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
	if (kStringIsEmpty(message)) {
		message = @"";
	}
    
    if ([self firstViewIsMBHud]) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showMessage:message toView:nil];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:message toView:nil];
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showText:@"网络问题，请切换到内网"];
        [self hideHUD];
    });
    return nil;
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUDForView:view animated:YES];
    });
}

+ (void)hideHUD {
	
	[self hideHUDForView:nil];
}


+ (void)clearWindowWhenShowHud {
    if ([self firstViewIsMBHud]) {
        [self hideHUD];
    }
}

+ (BOOL)firstViewIsMBHud {
    UIView * view = [[UIApplication sharedApplication].windows lastObject];
    
    NSArray * subViews = view.subviews;
    for (NSInteger index = 0; index < subViews.count; index ++) {
        id object = subViews[index];
        if ([object isKindOfClass:[MBProgressHUD class]]) {
            return YES;
        }
    }
    return NO;
}

@end
