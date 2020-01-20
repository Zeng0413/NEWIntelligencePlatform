//
//  OCCourseReportModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCCourseZgKgSubjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseReportModel : NSObject

@property (copy, nonatomic) NSString *totalScore; //总得分
@property (copy, nonatomic) NSString *totalQuestion; //总题目数
@property (strong, nonatomic) kgSubjectModel *kgSubject;
@property (strong, nonatomic) zgSubjectModel *zgSubject;

@property (copy, nonatomic) NSArray *subjectList;
@end
NS_ASSUME_NONNULL_END
