//
//  OCCourseOptionModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseOptionModel : NSObject

@property (assign, nonatomic) NSInteger correct;
@property (copy, nonatomic) NSString *opKey;
@property (copy, nonatomic) NSString *opValue;
@property (assign, nonatomic) NSInteger optionId;

@end

NS_ASSUME_NONNULL_END
