//
//  OCInteractionAnswerQuestionViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCInteractionAnswerQuestionViewController : UIViewController

@property (assign, nonatomic) BOOL isMoreChoose;

@property (assign, nonatomic) NSInteger questionID;
@property (assign, nonatomic) NSInteger classID;

@property (assign, nonatomic) BOOL isObj;


@end

NS_ASSUME_NONNULL_END
