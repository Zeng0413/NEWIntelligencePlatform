//
//  UIViewController+OCAdditonProperty.h
//  OCPhoenix
//
//  Created by Alan on 2019/5/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (OCAdditonProperty)

/** 参数配置 */

@property (nonatomic, strong) NSDictionary * params;

@end

NS_ASSUME_NONNULL_END
