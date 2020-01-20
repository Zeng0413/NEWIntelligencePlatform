//
//  OCCourseListModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseListModel : NSObject

@property (copy, nonatomic) NSString *courseImg;

@property (copy, nonatomic) NSString *courseName;

@property (assign, nonatomic) NSInteger ID;

@property (assign, nonatomic) NSInteger lessonCount;
@property (copy, nonatomic) NSString *lessonImg;
@property (assign, nonatomic) NSInteger lessonImgType;

@end

NS_ASSUME_NONNULL_END
