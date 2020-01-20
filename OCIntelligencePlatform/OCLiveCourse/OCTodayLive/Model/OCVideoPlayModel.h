//
//  OCVideoPlayModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCVideoPlayModel : NSObject

@property (copy, nonatomic) NSString *speaker;
@property (copy, nonatomic) NSString *RecordEquipment;
@property (copy, nonatomic) NSString *startTimeTip;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *AgentServer;
@property (copy, nonatomic) NSString *endTimeTip;
@property (copy, nonatomic) NSString *Uri;
@property (copy, nonatomic) NSString *AgentServerCode;
@property (copy, nonatomic) NSString *RecordEquipmentCode;
@property (copy, nonatomic) NSString *Sub;
@end

NS_ASSUME_NONNULL_END
