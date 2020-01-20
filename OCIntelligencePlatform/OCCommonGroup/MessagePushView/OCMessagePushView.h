//
//  OCMessagePushView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^viewClickAction)(void);
@interface OCMessagePushView : UIView

+(void)showMessagePushViewWithTitle:(NSString *)title messageText:(NSString *)message viewClick:(void (^)(void))viewClick;



@end

NS_ASSUME_NONNULL_END
