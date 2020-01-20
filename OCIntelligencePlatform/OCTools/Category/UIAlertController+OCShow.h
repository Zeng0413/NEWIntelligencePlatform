//
//  UIAlertController+OCShow.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/2.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
typedef void(^ActionHandler)(UIAlertAction *action);
@interface UIAlertController (OCShow)
/**
 UIAlertControllerStyleAlert
 
 @param title 标题
 @param msg 详情
 @param sure 确定标题
 @param cancel 取消标题
 @param sureHandler 确定回调
 @param cacelHandler 取消回调
 @return UIAlertController(类型为UIAlertControllerStyleAlert)
 */
+ (UIAlertController *)bme_alertWithTitle:(NSString *)title
                                  message:(NSString *)msg
                                sureTitle:(NSString *)sure
                              cancelTitle:(NSString *)cancel
                              sureHandler:(ActionHandler)sureHandler
                            cancelHandler:(ActionHandler)cacelHandler;
@end

NS_ASSUME_NONNULL_END
