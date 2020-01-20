//
//  OCCourseSheetModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseSheetModel : NSObject

@property (assign, nonatomic) BOOL isHaveOpen;
@property (assign, nonatomic) BOOL isOpen;

@property (assign, nonatomic) NSInteger attendanceStatus;
@property (copy, nonatomic) NSString *classroom;
@property (copy, nonatomic) NSString *college;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *teacherName;
@property (copy, nonatomic) NSString *time;
@property (strong, nonatomic) NSArray *courseware;
@end

NS_ASSUME_NONNULL_END
