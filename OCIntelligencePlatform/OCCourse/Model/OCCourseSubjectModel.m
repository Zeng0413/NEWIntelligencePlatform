//
//  OCCourseSubjectModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSubjectModel.h"
#import "OCSubjectAnswerModel.h"
@implementation OCCourseSubjectModel

+(NSDictionary *)objectClassInArray{
    return @{@"answerList":[OCSubjectAnswerModel class]};
}

@end
