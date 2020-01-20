//
//  OCCollegeSubject.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCollegeSubject.h"

@implementation BRAcademyModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

@implementation BRSubjectModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end

@implementation BRProfessionModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end
