//
//  OCLessonQuestionAllModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCLessonQuestionAllModel.h"
#import "OCSubObjQuestionModel.h"

@implementation OCLessonQuestionAllModel

+(NSDictionary *)objectClassInArray{
    return @{@"subObjList":[OCSubObjQuestionModel class]};
}

@end
