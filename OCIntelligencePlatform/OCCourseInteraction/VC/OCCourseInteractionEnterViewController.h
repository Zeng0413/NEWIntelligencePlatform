//
//  OCCourseInteractionEnterViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseLessonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseInteractionEnterViewController : UIViewController

@property (strong, nonatomic) NSDictionary *signDict;

@property (strong, nonatomic) OCCourseLessonModel *lessonModel;

@property (assign, nonatomic) BOOL isNoClass;
@end

NS_ASSUME_NONNULL_END
