//
//  TSNavigationController.m
//  AntMaintenance
//
//  Created by Seven Lv on 16/3/29.
//  Copyright © 2016年 Toocms. All rights reserved.
//

static CGFloat kDistance = 80.0f;
#import "AppDelegate.h"
#import "TSNavigationController.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"

@interface TSNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenShotArray = [NSMutableArray array];
    self.navigationBar.hidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
//    self.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    self.fd_fullscreenPopGestureRecognizer.delegate = self;
//    [self.fd_fullscreenPopGestureRecognizer addTarget:self action:@selector(panGesIng:)];
//    [self.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIViewController * currentVC = self.viewControllers.lastObject;
    if (currentVC.ts_navgationBar.notNeedPanPopReturn) {
//        [self.view removeGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
        return NO;
    }
    return YES;
}


- (void)panGesIng:(UIPanGestureRecognizer *)panGes {
    
    if (self.viewControllers.count <= 1) {
        return;
    }
    UIViewController * currentVC = self.viewControllers.lastObject;
    if (currentVC.ts_navgationBar.notNeedPanPopReturn) {
//        [self.view removeGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
        return;
    }
    
    CGPoint pt = [panGes translationInView:self.view];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
           
    if (panGes.state == UIGestureRecognizerStateBegan) {
//        appdelegate.screenShotView.hidden = NO;
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        if (pt.x >= 10) {
            [UIView animateWithDuration:0.2 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
            }];
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        CGPoint pt = [panGes translationInView:self.view];
        if (pt.x >= kDistance)
        {
            [UIView animateWithDuration:0.15 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(kViewW, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(kViewW, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
//                appdelegate.screenShotView.hidden = YES;
            }];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil]; 
            [UIView animateWithDuration:0.15 animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
//                appdelegate.screenShotView.hidden = YES;
            }];
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //    if (self.viewControllers.count == 0) {
    //        [super pushViewController:viewController animated:animated];
    //    }
    
    if (self.viewControllers.count > 0) {
        ///第二层viewcontroller 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
    }
    
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(appdelegate.window.size.width, appdelegate.window.size.height), YES, 0);
//
//    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.screenShotArray addObject:viewImage];
//
//    appdelegate.screenShotView.imageView.image = viewImage;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    [self.screenShotArray removeLastObject];
//
//    UIImage *image = [self.screenShotArray lastObject];
//
//    if (image) {
//        appdelegate.screenShotView.imageView.image = image;
//    }
//    if (self.viewControllers.count == 2) {
//        self.hidesBottomBarWhenPushed = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
//    }
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (self.screenShotArray.count > 2) {
        [self.screenShotArray removeObjectsInRange:NSMakeRange(1, self.screenShotArray.count - 1)];
    }
    
    UIImage *image = [self.screenShotArray lastObject];
    if (image) {
//        appdelegate.screenShotView.imageView.image = image;
    }
    
//    if (self.viewControllers.count == 0) {
//        self.hidesBottomBarWhenPushed = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
//    }
    
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSArray *arr = [super popToViewController:viewController animated:animated];
    
    if (self.screenShotArray.count > arr.count)
    {
        for (int i = 0; i < arr.count; i++) {
            [self.screenShotArray removeLastObject];
        }
    }
    
//    if (self.viewControllers.count == 2) {
//        self.hidesBottomBarWhenPushed = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
//    }
    
    return arr;
}

+ (instancetype)naviWithRootViewController:(UIViewController *)aviewController {
    return [[self alloc] initWithRootViewController:aviewController];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return SINGLE.statusBarStyle;
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return SINGLE.hiddenStatusBar;
//}


@end
