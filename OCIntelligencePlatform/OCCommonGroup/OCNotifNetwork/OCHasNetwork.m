//
//  OCHasNetwork.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCHasNetwork.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"

@interface OCHasNetwork ()
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation OCHasNetwork

+ (void)ysy_hasNetwork:(void(^)(bool has))hasNet
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                hasNet(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNet(YES);
                break;
        }
    }];
    //结束监听
    [manager stopMonitoring];
}

@end
