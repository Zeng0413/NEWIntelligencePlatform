//
//  OCClassSheetClassroomModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClassSheetClassroomModel : NSObject
@property (copy, nonatomic) NSString *roomCode;
@property (strong, nonatomic) NSArray *times;


@end

NS_ASSUME_NONNULL_END
