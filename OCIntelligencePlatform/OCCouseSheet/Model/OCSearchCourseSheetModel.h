//
//  OCSearchCourseSheetModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/7.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSearchCourseSheetModel : NSObject
@property (copy, nonatomic) NSString *classroom;
@property (copy, nonatomic) NSString *college;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *week;
@property (copy, nonatomic) NSString *teacher;
@property (assign, nonatomic) NSInteger compulsory; // 是否是自己的课程
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *courseCode;
@property (assign, nonatomic) NSInteger isCollect;


@end

NS_ASSUME_NONNULL_END
