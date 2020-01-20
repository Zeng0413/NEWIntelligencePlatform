//
//  OCSingletonManager.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCSingletonManager : NSObject
+ (OCSingletonManager *)shared;

@property (nonatomic, strong) NSString * userId;
//用户信息
@property (nonatomic, strong) OCUserModel * userModel;

@end

NS_ASSUME_NONNULL_END
