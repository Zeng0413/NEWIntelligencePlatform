//
//  OCLessonGroupModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCLessonGroupModel.h"

@implementation OCLessonGroupModel

+(NSDictionary *)objectClassInArray{
    return @{@"userList" : [OCUserModel class]};
}

@end
