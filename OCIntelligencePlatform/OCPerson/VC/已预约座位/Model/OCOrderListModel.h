//
//  OCOrderListModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/11.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCOrderListModel : NSObject

@property (copy, nonatomic) NSString *seatCode;

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *seatName;

@property (copy, nonatomic) NSString *seatArea;

@property (assign, nonatomic) NSInteger endTime;

@property (assign, nonatomic) NSInteger status;

@property (assign, nonatomic) NSInteger starTime;

@property (copy, nonatomic) NSString *buildingName;

@property (copy, nonatomic) NSString *roomName;

@end

NS_ASSUME_NONNULL_END
