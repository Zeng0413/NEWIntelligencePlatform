//
//  OCCourseSubjectModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseSubjectModel : NSObject

@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subjectImg;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *answerList;
@end

NS_ASSUME_NONNULL_END
