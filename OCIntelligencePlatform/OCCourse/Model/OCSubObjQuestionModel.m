//
//  OCSubObjQuestionModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSubObjQuestionModel.h"
#import "OCCourseOptionModel.h"

@implementation OCSubObjQuestionModel

+(NSDictionary *)objectClassInArray{
    return @{@"optionList":[OCCourseOptionModel class]};
}

@end
