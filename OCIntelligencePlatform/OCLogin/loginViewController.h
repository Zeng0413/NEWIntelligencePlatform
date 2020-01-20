//
//  loginViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface loginViewController : UIViewController

//token检验
+ (void)checkToken:(void (^)(BOOL success))success;
@end

NS_ASSUME_NONNULL_END
