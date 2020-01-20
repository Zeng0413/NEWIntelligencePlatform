//
//  OCUserModel.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCUserModel.h"
#import "OCUserPermissionModel.h"
#import "JPUSHService.h"

@implementation OCUserModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"isNewUser":@"newUser"};
}

+(NSDictionary *)objectClassInArray{
    return @{@"permissionList" : [OCUserPermissionModel class]};
}

+ (void)handleLoginData:(NSDictionary *)responseObject {
    [kUserDefaults setObject:NSStringFormat(@"%@",responseObject[@"userId"]) forKey:@"userId"];
    [kUserDefaults setObject:NSStringFormat(@"%@",responseObject[@"token"]) forKey:@"token"];
    [kUserDefaults setObject:NSStringFormat(@"%@",responseObject[@"mobile"]) forKey:@"phone"];
    
    NSArray *tempArr = responseObject[@"service"];
    for (NSDictionary *dict in tempArr) {
        NSString *typeStr = dict[@"serviceName"];
        if ([typeStr isEqualToString:@"service"]) {
            [kUserDefaults setObject:dict[@"serviceUrl"] forKey:kServiceStr];
        }else if ([typeStr isEqualToString:@"intranet_gateway"]){
            [kUserDefaults setObject:dict[@"serviceUrl"] forKey:kInsideURL];
        }
    }
}

+ (void)clearUserData {
    [[SocketRocketUtility instance]SRSocketClose];
    [NSDictionary bg_removeValueForKey:@"userInfoData"];
    SINGLE.userModel = nil;
    [kUserDefaults removeObjectForKey:@"token"];
    [kUserDefaults removeObjectForKey:@"userId"];
    
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"%tu,%@,%tu",iResCode,iTags,seq);
    } seq:1];
}
@end
