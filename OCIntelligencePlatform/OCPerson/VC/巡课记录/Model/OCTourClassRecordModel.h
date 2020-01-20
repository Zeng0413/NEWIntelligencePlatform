//
//  OCTourClassRecordModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTourClassRecordModel : NSObject

@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *teachName;
@property (assign, nonatomic) NSInteger createTime;
@property (assign, nonatomic) NSInteger score;


@end

NS_ASSUME_NONNULL_END
