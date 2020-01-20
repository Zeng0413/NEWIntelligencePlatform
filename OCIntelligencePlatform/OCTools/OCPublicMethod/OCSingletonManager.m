//
//  OCSingletonManager.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSingletonManager.h"

@implementation OCSingletonManager

+ (OCSingletonManager *)shared {
    static OCSingletonManager * user = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        user  = [[OCSingletonManager alloc] init];
    });
    
    return user;
}
@end
