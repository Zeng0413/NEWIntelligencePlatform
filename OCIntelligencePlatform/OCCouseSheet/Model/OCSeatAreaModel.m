//
//  OCSeatAreaModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/9.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCSeatAreaModel.h"
#import "OCSeatsModel.h"

@implementation OCSeatAreaModel

+(NSDictionary *)objectClassInArray{
    return @{@"seatList" : [OCSeatsModel class]};
}

@end
