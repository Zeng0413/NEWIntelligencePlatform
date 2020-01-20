//
//  OCCourseReportViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseLessonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCCourseReportViewController : UIViewController
@property (strong, nonatomic) NSDictionary *tempDict;

@property (strong, nonatomic) OCCourseLessonModel *dataModel;
@end

NS_ASSUME_NONNULL_END
