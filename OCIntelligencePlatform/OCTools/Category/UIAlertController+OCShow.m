//
//  UIAlertController+OCShow.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/2.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "UIAlertController+OCShow.h"

@implementation UIAlertController (OCShow)
+ (UIAlertController *)bme_alertWithTitle:(NSString *)title
                                  message:(NSString *)msg
                                sureTitle:(NSString *)sure
                              cancelTitle:(NSString *)cancel
                              sureHandler:(ActionHandler)sureHandler
                            cancelHandler:(ActionHandler)cacelHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (sure) {
        UIAlertAction *s = [UIAlertAction actionWithTitle:sure
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (sureHandler) {
                                                          sureHandler(action);
                                                      }
                                                  }];
        [alert addAction:s];
    }
    
    if (cancel) {
        
        UIAlertAction *c = [UIAlertAction actionWithTitle:cancel
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (cacelHandler) {
                                                          cacelHandler(action);
                                                      }
                                                  }];
        
        [alert addAction:c];
    }
    
    UIViewController *current = [OCPublicMethodManager getCurrentVC];
    [current presentViewController:alert animated:true completion:nil];
    
    return alert;
}
@end
