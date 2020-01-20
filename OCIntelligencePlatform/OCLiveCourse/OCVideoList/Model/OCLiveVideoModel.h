//
//  OCLiveVideoModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCLiveVideoModel : NSObject
@property (assign, nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *speaker;
@property (copy, nonatomic) NSString *startTimeTip;
@property (assign, nonatomic) NSInteger recordEquipmentId;
@property (copy, nonatomic) NSString *coverUri;
@property (copy, nonatomic) NSString *recordEquipmentOnlineCoverUri;

@property (copy, nonatomic) NSString *endTimeTip;
@property (copy, nonatomic) NSString *recordEquipmentName;

@property (assign, nonatomic) BOOL isLiving;
@property (assign, nonatomic) NSInteger wannaSee;

@end

NS_ASSUME_NONNULL_END
