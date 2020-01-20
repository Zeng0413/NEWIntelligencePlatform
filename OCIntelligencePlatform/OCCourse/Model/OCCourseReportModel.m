//
//  OCCourseReportModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseReportModel.h"
#import "OCCourseSubjectModel.h"
@implementation OCCourseReportModel

+(NSDictionary *)objectClassInArray{
    return @{@"subjectList":[OCCourseSubjectModel class]};
}

@end


