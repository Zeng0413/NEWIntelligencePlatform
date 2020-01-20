//
//  OCCourseDetailViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseLessonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCCourseDetailViewController : UIViewController

@property (strong, nonatomic) OCCourseLessonModel *lessonModel;

@property (assign, nonatomic) NSInteger imgType;

@property (copy, nonatomic) NSString *lessonImg;
@end

NS_ASSUME_NONNULL_END
