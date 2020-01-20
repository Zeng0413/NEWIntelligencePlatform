//
//  OCBaseWebViewController.h
//  OCVocationalEducationiOS
//
//  Created by Alan on 2019/12/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCBaseWebViewController : UIViewController

@property (assign, nonatomic) BOOL isHiddenNav;

@property (copy, nonatomic) NSString *urlStr;

@property (copy, nonatomic) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
