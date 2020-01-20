//
//  OCTourClassRecordFiltrateView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCTourClassRecordFiltrateViewDelegate <NSObject>

-(void)tourClassSearchClickWithCourseName:(NSString *)courseName withTeachName:(NSString *)teachName withStarTime:(NSInteger)startTime withEndTime:(NSInteger)endTime;

@end

@interface OCTourClassRecordFiltrateView : UIView

+(OCTourClassRecordFiltrateView *)creatTourClassRecordFiltrateView;

@property (weak, nonatomic) id<OCTourClassRecordFiltrateViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
