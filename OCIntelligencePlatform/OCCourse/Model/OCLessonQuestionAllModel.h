//
//  OCLessonQuestionAllModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCLessonQuestionAllModel : NSObject

@property (assign, nonatomic) NSInteger lessonId; // 课讲ID
@property (assign, nonatomic) NSInteger objCorrectCount; // 客观题正确数量
@property (assign, nonatomic) NSInteger objCount; // 客观题数量
@property (assign, nonatomic) NSInteger objErrorCount; // 客观题错误数量
@property (copy, nonatomic) NSString *name; // 名称

@property (assign, nonatomic) NSInteger objNoAnswerCount; // 客观题未作答数量
@property (assign, nonatomic) NSInteger score; // 得分
@property (assign, nonatomic) NSInteger subjAnswerCount; // 主观题回答数量
@property (assign, nonatomic) NSInteger subjCount; // 主观题数量
@property (assign, nonatomic) NSInteger subjNoAnswerCount; // 主观题未回答数量

@property (strong, nonatomic) NSArray *subObjList;

@end

NS_ASSUME_NONNULL_END
