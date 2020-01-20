//
//  OCTourClassModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/18.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTourClassModel : NSObject

@property (copy, nonatomic) NSString *attitudeRemarks; // 教学态度备注

@property (copy, nonatomic) NSString *attitudeScore; // 教学态度评分

@property (copy, nonatomic) NSString *contentsRemarks; // 教学内容备注

@property (copy, nonatomic) NSString *courseCode; // 课程代码
@property (copy, nonatomic) NSString *createTime; // 创建时间
@property (copy, nonatomic) NSString *evaluate; // 评价建议
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *roomCode; // 教室code
@property (copy, nonatomic) NSString *summary; // 授课内容提要

@property (assign, nonatomic) NSInteger contentsScore; // 教学内容评分
@property (assign, nonatomic) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
