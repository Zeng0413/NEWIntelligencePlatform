//
//  OCCourseWareModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseWareModel : NSObject
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger lessonId;
@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger createTime;


@property (assign, nonatomic) NSInteger allowSee;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *wareId;


@end

NS_ASSUME_NONNULL_END
