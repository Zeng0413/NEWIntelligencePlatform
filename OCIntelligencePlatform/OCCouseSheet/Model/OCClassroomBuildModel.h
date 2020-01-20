//
//  OCClassroomBuildModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/10.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClassroomBuildModel : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *buildingName;

@property (copy, nonatomic) NSString *roomName;

@property (assign, nonatomic) NSInteger seatCount;

@property (assign, nonatomic) NSInteger unavailableCount; // 已被选座位数量


@end

NS_ASSUME_NONNULL_END
