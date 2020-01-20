//
//  OCUserPermissionModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/12.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCUserPermissionModel : NSObject

@property (assign, nonatomic) NSInteger ID;

@property (assign, nonatomic) NSInteger parentId;

@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
