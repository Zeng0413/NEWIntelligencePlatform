//
//  OCClassSheetClassroomModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassSheetClassroomModel.h"
#import "OCClassSheetSubject.h"

@implementation OCClassSheetClassroomModel

+(NSDictionary *)objectClassInArray{
    return @{@"times":[OCClassSheetSubject class]};
}

@end
