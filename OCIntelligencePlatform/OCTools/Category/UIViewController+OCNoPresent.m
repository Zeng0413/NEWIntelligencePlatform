//
//  UIViewController+OCNoPresent.m
//  OCElocutionSys_iOS
//
//  Created by roselifeye on 2018/12/9.
//  Copyright © 2018 OCZHKJ. All rights reserved.
//

#import "UIViewController+OCNoPresent.h"
#import <objc/runtime.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@implementation UIViewController (OCNoPresent)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(oc_presentViewController:animated:completion:));
        
        method_exchangeImplementations(presentM, presentSwizzlingM);
        
        Class class = [self class];
        hbd_exchangeImplementations(class, @selector(viewWillAppear:), @selector(hbd_viewWillAppear:));
        hbd_exchangeImplementations(class, @selector(viewDidAppear:), @selector(hbd_viewDidAppear:));
        hbd_exchangeImplementations(class, @selector(viewWillDisappear:), @selector(hbd_viewWillDisappear:));
        hbd_exchangeImplementations(class, @selector(viewDidDisappear:), @selector(hbd_viewDidDisappear:));
        hbd_exchangeImplementations(class, @selector(viewWillTransitionToSize:withTransitionCoordinator:), @selector(hbd_viewWillTransitionToSize:withTransitionCoordinator:));
    });
}

- (void)oc_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        //        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        //        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            return;
        }
    }
    [self oc_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark ----------------------------------------------------------- statusBar

UIKIT_STATIC_INLINE void hbd_exchangeImplementations(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

BOOL isIphoneX() {
    NSArray *xrs =@[ @812, @896 ];
    BOOL isIPhoneX = [xrs containsObject:@([UIScreen mainScreen].bounds.size.height)];
    return isIPhoneX;
}

- (BOOL)hbd_inCall {
    if (isIphoneX()) {
        CTCallCenter *callCenter = [[CTCallCenter alloc] init] ;
        for (CTCall *call in callCenter.currentCalls)  {
            if (call.callState == CTCallStateConnected) {
                return YES;
            }
        }
        return NO;
    } else {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        return statusBarHeight == 40;
    }
}

- (BOOL)hbd_statusBarHidden {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : NO;
}

- (void)setHbd_statusBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(hbd_statusBarHidden), @(hidden), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)hbd_viewWillAppear:(BOOL)animated {
    [self hbd_viewWillAppear:animated];
    [self hbd_setNeedsStatusBarHiddenUpdate];
}

-(void)hbd_viewDidAppear:(BOOL)animated {
    [self hbd_viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hbd_statusBarFrameWillChange:)name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)hbd_viewWillDisappear:(BOOL)animated {
    [self hbd_viewWillDisappear:animated];
}

-(void)hbd_viewDidDisappear:(BOOL)animated {
    [self hbd_viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)hbd_viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self hbd_viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([self hbd_isRootViewController]) {
            [self hbd_setNeedsStatusBarHiddenUpdate];
        }
    } completion:nil];
}

- (void)hbd_statusBarFrameWillChange:(NSNotification*)notification {
    if ([self hbd_isRootViewController]) {
        [self hbd_setNeedsStatusBarHiddenUpdate];
    }
}

- (BOOL)hbd_isRootViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = keyWindow.rootViewController;
    return self == rootViewController;
}

- (void)hbd_setNeedsStatusBarHiddenUpdate {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = keyWindow.rootViewController;
    
    if (!rootViewController) {
        return;
    }
    
    if ( self != rootViewController) {
        [rootViewController hbd_setNeedsStatusBarHiddenUpdate];
        return;
    }
    
    UIViewController *vc = self.childViewControllerForStatusBarHidden;
    while (vc.childViewControllerForStatusBarHidden) {
        vc = vc.childViewControllerForStatusBarHidden;
    }
    
    if (!vc) {
        vc = self;
    }
    
    [self hbd_setStatusBarHidden:vc.hbd_statusBarHidden forViewController:vc];
}

- (void)hbd_setStatusBarHidden:(BOOL)hidden forViewController:(UIViewController *)vc {
    hidden = hidden && !self.hbd_inCall;
    UIWindow *statusBar = [[UIApplication sharedApplication] keyWindow];
    if (!statusBar) {
        return;
    }
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UIStatusBarAnimation animation = vc.preferredStatusBarUpdateAnimation;
    if (animation == UIStatusBarAnimationFade) {
        if (!CGAffineTransformIsIdentity(statusBar.transform) && !hidden) {
            statusBar.alpha = 1.0;
            [UIView animateWithDuration:0.35 animations:^{
                statusBar.transform = CGAffineTransformIdentity;
            }];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                statusBar.alpha = hidden ? 0 : 1.0;
            }];
        }
    } else if (animation == UIStatusBarAnimationSlide) {
        if (!hidden && statusBar.alpha == 0) {
            statusBar.alpha = 1.0;
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            statusBar.transform = hidden ? CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -statusBarHeight) : CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (!self.hbd_inCall) {
                statusBar.alpha = hidden ? 0 : 1.0;
            }
        }] ;
    } else {
        statusBar.transform = hidden ? CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -statusBarHeight) : CGAffineTransformIdentity;
        statusBar.alpha = hidden ? 0 : 1.0;
    }
}


@end
