//
//  OCClassroomPushView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/8.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomPushView.h"

@interface OCClassroomPushView ()


@end

@implementation OCClassroomPushView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.6;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.backView addGestureRecognizer:tapGesture];
    
    self.videoStatusLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *videoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoClick)];
    [self.videoStatusLab addGestureRecognizer:videoGesture];
}

-(void)videoClick{
    if (self.liveBlock) {
        self.liveBlock(self.subjectModel);
    }
}

-(void)setSubjectModel:(OCClassSheetSubject *)subjectModel{
    _subjectModel = subjectModel;
    
    if (subjectModel.weeks.length == 0) {
        self.courseNameLab.text = NSStringFormat(@"课程：%@",subjectModel.lessonName);
        self.teacherNameLab.text = NSStringFormat(@"教师：%@",subjectModel.teacher);
        
    }else{
        self.courseNameLab.text = NSStringFormat(@"教师：%@",subjectModel.teacher);
        self.teacherNameLab.text = NSStringFormat(@"周次：%@",subjectModel.weeks);
        self.videoTitleLab.text = @"地点：";
        self.videoStatusLab.text = subjectModel.lessonCode;
        self.videoStatusLab.textColor = RGBA(102, 102, 102, 1);
        self.videoStatusLab.font = kFont(14);
    }
    
    
}

- (void) tapGesture
{
    [self removeFromSuperview];
}

+(OCClassroomPushView *)creatClassroomPushView{
    OCClassroomPushView *view = [OCClassroomPushView creatViewFromNib];
    return view;
}

- (IBAction)lookCourseClick:(id)sender {
    
    if (self.block) {
        self.block();
    }
}

@end
