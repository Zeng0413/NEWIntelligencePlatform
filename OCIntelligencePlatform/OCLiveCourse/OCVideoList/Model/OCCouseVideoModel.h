//
//  OCCouseVideoModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/27.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCouseVideoModel : NSObject
@property (copy, nonatomic) NSString *categoryName;
@property (copy, nonatomic) NSString *categorySectionName;
@property (copy, nonatomic) NSString *coursesName;
@property (copy, nonatomic) NSString *liveTimeTip;
@property (copy, nonatomic) NSString *videoCover;
@property (copy, nonatomic) NSString *videoCoverHash;
@property (copy, nonatomic) NSString *videoCoverUri;
@property (copy, nonatomic) NSString *videoCreateTimeTip;
@property (copy, nonatomic) NSString *videoPeriod;
@property (copy, nonatomic) NSString *videoPeriodTip;
@property (copy, nonatomic) NSString *videoReviewStatusTip;
@property (copy, nonatomic) NSString *videoSpeaker;
@property (copy, nonatomic) NSString *videoTitle;

@property (strong, nonatomic) NSDictionary *videoCreateTime;

@property (assign, nonatomic) NSInteger categoryId;
@property (assign, nonatomic) NSInteger categorySectionId;
@property (assign, nonatomic) NSInteger coursesNo;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger sortNumber;
@property (assign, nonatomic) NSInteger videoId;
@property (assign, nonatomic) NSInteger videoReviewStatus;
@property (assign, nonatomic) NSInteger videoViewCount;

@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
