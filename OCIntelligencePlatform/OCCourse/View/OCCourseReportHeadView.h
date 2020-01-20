//
//  OCCourseReportHeadView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCourseReportModel.h"
#import "OCLessonQuestionAllModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCCourseReportHeadView : UIView

@property (strong, nonatomic) OCLessonQuestionAllModel *dataModel;

@end

NS_ASSUME_NONNULL_END
