//
//  OCDiscussModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCDiscussModel.h"
#import "OCDiscussContentModel.h"

@implementation OCDiscussModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+(NSDictionary *)objectClassInArray{
    return @{@"answerList":[OCDiscussContentModel class]};
}

@end
