//
//  UIViewController+OCNoPresent.h
//  OCElocutionSys_iOS
//
//  Created by roselifeye on 2018/12/9.
//  Copyright © 2018 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (OCNoPresent)

+ (void)load;

@property (nonatomic, assign) BOOL hbd_statusBarHidden;
@property (nonatomic, assign, readonly) BOOL hbd_inCall;

- (void)hbd_setNeedsStatusBarHiddenUpdate;

@end

NS_ASSUME_NONNULL_END
