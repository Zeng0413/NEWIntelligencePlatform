//
//  OCCourseVideoListModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/27.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseVideoListModel : NSObject

@property (copy, nonatomic) NSString *addTime;
@property (copy, nonatomic) NSString *categoryId;
@property (copy, nonatomic) NSString *categoryName;
@property (copy, nonatomic) NSString *categorySectionId;
@property (copy, nonatomic) NSString *categorySectionName;
@property (copy, nonatomic) NSString *coursesLevelName;
@property (copy, nonatomic) NSString *coursesLevelNo;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *coverHash;
@property (copy, nonatomic) NSString *coverUri;
@property (copy, nonatomic) NSString *videoReviewStatusTip;
@property (copy, nonatomic) NSString *videoSpeaker;
@property (copy, nonatomic) NSString *videoTitle;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *no;
@property (copy, nonatomic) NSString *reviewStatusTip;
@property (copy, nonatomic) NSString *speaker;
@property (copy, nonatomic) NSString *startTimeAndEndTimeTip;

@property (strong, nonatomic) NSDictionary *endTime;
@property (strong, nonatomic) NSDictionary *startTime;

@property (assign, nonatomic) NSInteger collectCount;
@property (assign, nonatomic) NSInteger commentCount;
@property (assign, nonatomic) NSInteger period;
@property (assign, nonatomic) NSInteger reviewStatus;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger term;
@property (assign, nonatomic) NSInteger videoCount;
@property (assign, nonatomic) NSInteger viewCount;
@property (assign, nonatomic) NSInteger yearNo;

@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
