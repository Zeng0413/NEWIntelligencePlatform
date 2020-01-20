//
//  bindingPhoneViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/31.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^changePhonebackBlock)(void);

@interface bindingPhoneViewController : UIViewController

@property (copy, nonatomic) changePhonebackBlock block;
-(void)returnBlock:(changePhonebackBlock)block;

@end

