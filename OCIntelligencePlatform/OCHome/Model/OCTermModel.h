//
//  OCTermModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/27.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTermModel : NSObject
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *termName;

@property (assign, nonatomic) NSInteger endYear;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger schoolId;
@property (assign, nonatomic) NSInteger startYear;
@end

NS_ASSUME_NONNULL_END
