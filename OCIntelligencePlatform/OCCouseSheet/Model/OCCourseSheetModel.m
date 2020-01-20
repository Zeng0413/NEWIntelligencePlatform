//
//  OCCourseSheetModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSheetModel.h"
#import "OCCourseWareModel.h"
@implementation OCCourseSheetModel

+(NSDictionary *)objectClassInArray{
    return @{@"courseware" : [OCCourseWareModel class]};
}


@end
