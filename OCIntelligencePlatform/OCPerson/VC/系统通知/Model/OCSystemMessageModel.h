//
//  OCSystemMessageModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSystemMessageModel : NSObject
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger questionType;
@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSInteger createTime;

@property (copy, nonatomic) NSString *tips;
@property (assign, nonatomic) NSInteger questionId;
@property (assign, nonatomic) NSInteger clazzId;
@property (assign, nonatomic) NSInteger lessonId;
@property (copy, nonatomic) NSString *content;

@end

NS_ASSUME_NONNULL_END
