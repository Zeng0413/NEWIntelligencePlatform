//
//  WGHCountDownButton.h
//  HSHShangcheng
//
//  Created by Alan on 2017/10/24.
//  Copyright © 2017年 luobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WGHCountDownButton;

typedef void(^Completion)(WGHCountDownButton *countDownButton);


@interface WGHCountDownButton : UIButton

@property (nonatomic, assign) NSInteger remainTime;

- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(Completion)completion;
- (void)cancelCountDown;

@end
