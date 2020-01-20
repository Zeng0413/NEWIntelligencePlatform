//
//  OCClassroomPushView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/8.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCClassSheetSubject.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCClassroomPushView : UIView

+(OCClassroomPushView *)creatClassroomPushView;

typedef void(^lookCourseBlock)(void);
typedef void(^lookLiveVideoBlock)(OCClassSheetSubject *model);
@property (copy, nonatomic) lookCourseBlock block;
@property (copy, nonatomic) lookLiveVideoBlock liveBlock;

@property (weak, nonatomic) IBOutlet UIView *contenBackVIew;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *tourCourseBtn;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *videoStatusLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHLay;

@property (strong, nonatomic) OCClassSheetSubject *subjectModel;
@end

NS_ASSUME_NONNULL_END
