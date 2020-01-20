//
//  OCChooseTypeQuestionViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCChooseTypeQuestionViewController : UIViewController

@property (assign, nonatomic) BOOL isMoreChoose;

@property (assign, nonatomic) NSInteger questionID;
@property (assign, nonatomic) NSInteger classID;

@end

NS_ASSUME_NONNULL_END
