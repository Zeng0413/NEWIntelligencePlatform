//
//  OCCourseZgKgSubjectModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface kgSubjectModel : NSObject

@property (copy, nonatomic) NSString *count;
@property (copy, nonatomic) NSString *correctCount;
@property (copy, nonatomic) NSString *errorCount;
@property (copy, nonatomic) NSString *noAnswerCount;

@end

@interface zgSubjectModel : NSObject

@property (copy, nonatomic) NSString *count;
@property (copy, nonatomic) NSString *answeredCount;
@property (copy, nonatomic) NSString *noAnswerCount;

@end

NS_ASSUME_NONNULL_END
