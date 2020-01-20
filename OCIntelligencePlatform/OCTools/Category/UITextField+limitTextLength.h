//
//  UITextField+limitTextLength.h
//  QHPay
//
//  Created by Alan on 2017/12/13.
//  Copyright © 2017年 Luobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (limitTextLength)

/** 最大字数 */

@property (nonatomic, assign) NSInteger textMax;

- (void)addNotification;

/** 小数点后最大位数 **/

@property (nonatomic, assign) NSInteger pointMax;

- (void)addPointMaxNotification;


@end
