//
//  OCCourseReportHeadView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseReportHeadView.h"

@interface OCCourseReportHeadView ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *kgTitleLab;
@property (strong, nonatomic) UILabel *zgTitleLab;
@property (strong, nonatomic) UILabel *kgCorrectLab;
@property (strong, nonatomic) UILabel *kgErrorLab;
@property (strong, nonatomic) UILabel *kgNoAnswerLab;
@property (strong, nonatomic) UILabel *zgAnsweredLab;
@property (strong, nonatomic) UILabel *zgNoAnswerLab;

@end

@implementation OCCourseReportHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBACKCOLOR;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.titleLab = [UILabel labelWithText:@"本讲得分：5分" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, 24*FITWIDTH, kViewW - 30*FITWIDTH, 18*FITWIDTH)];
    self.titleLab.font = kBoldFont(18*FITWIDTH);
    [self addSubview:self.titleLab];
    
    UIView *kgBackView = [UIView viewWithBgColor:WHITE frame:Rect(self.titleLab.x, MaxY(self.titleLab)+12*FITWIDTH, 196*FITWIDTH, 136*FITWIDTH)];
    kgBackView.layer.cornerRadius = 4;
    [self addSubview:kgBackView];
    
    self.kgTitleLab = [UILabel labelWithText:@"客观题 5道" font:12*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(16*FITWIDTH, 24*FITWIDTH, kgBackView.width - 16*FITWIDTH, 12*FITWIDTH)];
    [kgBackView addSubview:self.kgTitleLab];
    
    CGFloat labW = (kgBackView.width-2*FITWIDTH)/3;
    self.kgCorrectLab = [UILabel labelWithText:@"2" font:30*FITWIDTH textColor:RGBA(95, 232, 154, 1) frame:Rect(0, MaxY(self.kgTitleLab)+16*FITWIDTH, labW, 30*FITWIDTH)];
    self.kgCorrectLab.font = kBoldFont(30*FITWIDTH);
    self.kgCorrectLab.textAlignment = NSTextAlignmentCenter;
    [kgBackView addSubview:self.kgCorrectLab];
    
    UILabel *correctLab = [UILabel labelWithText:@"正确" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(0, MaxY(self.kgCorrectLab)+16*FITWIDTH, self.kgCorrectLab.width, 14*FITWIDTH)];
    correctLab.textAlignment = NSTextAlignmentCenter;
    [kgBackView addSubview:correctLab];
    
    UIView *linView1 = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(MaxX(self.kgCorrectLab), MaxY(self.kgTitleLab)+34*FITWIDTH, 1*FITWIDTH, 24*FITWIDTH)];
    [kgBackView addSubview:linView1];
    
    self.kgErrorLab = [UILabel labelWithText:@"3" font:30*FITWIDTH textColor:RGBA(255, 141, 148, 1) frame:Rect(MaxX(linView1), self.kgCorrectLab.y, labW, 30*FITWIDTH)];
    self.kgErrorLab.font = kBoldFont(30*FITWIDTH);
    self.kgErrorLab.textAlignment = NSTextAlignmentCenter;
    [kgBackView addSubview:self.kgErrorLab];
    
    UILabel *errorLab = [UILabel labelWithText:@"错误" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.kgErrorLab.x, correctLab.y, self.kgErrorLab.width, 14*FITWIDTH)];
    errorLab.textAlignment = NSTextAlignmentCenter;
    [kgBackView addSubview:errorLab];
    
    UIView *linView2 = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(MaxX(self.kgErrorLab), linView1.y, 1*FITWIDTH, 24*FITWIDTH)];
    [kgBackView addSubview:linView2];
    
    self.kgNoAnswerLab = [UILabel labelWithText:@"0" font:30*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(MaxX(linView2), self.kgCorrectLab.y, labW, 30*FITWIDTH)];
    self.kgNoAnswerLab.font = kBoldFont(30*FITWIDTH);
    self.kgNoAnswerLab.textAlignment = NSTextAlignmentCenter;
    [kgBackView addSubview:self.kgNoAnswerLab];
    
    UILabel *noAnswerLab = [UILabel labelWithText:@"未答" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.kgNoAnswerLab.x, correctLab.y, self.kgNoAnswerLab.width, 14*FITWIDTH)];
    noAnswerLab.textAlignment = NSTextAlignmentCenter;
    [kgBackView addSubview:noAnswerLab];
    
    
    
    UIView *zgBackView = [UIView viewWithBgColor:WHITE frame:Rect(MaxX(kgBackView)+12*FITWIDTH, kgBackView.y, 127*FITWIDTH, 136*FITWIDTH)];
    zgBackView.layer.cornerRadius = 4;
    [self addSubview:zgBackView];
    
    self.zgTitleLab = [UILabel labelWithText:@"主观题 5道" font:12*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(16*FITWIDTH, 24*FITWIDTH, zgBackView.width - 16*FITWIDTH, 12*FITWIDTH)];
    [zgBackView addSubview:self.zgTitleLab];
    
    CGFloat zglabW = (zgBackView.width-1*FITWIDTH)/2;
    self.zgAnsweredLab = [UILabel labelWithText:@"2" font:30*FITWIDTH textColor:RGBA(27, 122, 255, 1) frame:Rect(0, MaxY(self.zgTitleLab)+16*FITWIDTH, zglabW, 30*FITWIDTH)];
    self.zgAnsweredLab.font = kBoldFont(30*FITWIDTH);
    self.zgAnsweredLab.textAlignment = NSTextAlignmentCenter;
    [zgBackView addSubview:self.zgAnsweredLab];
    
    UILabel *zgAnswerLab = [UILabel labelWithText:@"已答" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(0, MaxY(self.zgAnsweredLab)+16*FITWIDTH, self.zgAnsweredLab.width, 14*FITWIDTH)];
    zgAnswerLab.textAlignment = NSTextAlignmentCenter;
    [zgBackView addSubview:zgAnswerLab];
    
    UIView *linView3 = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(MaxX(self.zgAnsweredLab), linView1.y, 1*FITWIDTH, 24*FITWIDTH)];
    [zgBackView addSubview:linView3];
    
    self.zgNoAnswerLab = [UILabel labelWithText:@"0" font:30*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(MaxX(linView3), self.zgAnsweredLab.y, zglabW, 30*FITWIDTH)];
    self.zgNoAnswerLab.font = kBoldFont(30*FITWIDTH);
    self.zgNoAnswerLab.textAlignment = NSTextAlignmentCenter;
    [zgBackView addSubview:self.zgNoAnswerLab];
    
    UILabel *zgNoAnswerLab = [UILabel labelWithText:@"未答" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.zgNoAnswerLab.x, zgAnswerLab.y, self.zgNoAnswerLab.width, 14*FITWIDTH)];
    zgNoAnswerLab.textAlignment = NSTextAlignmentCenter;
    [zgBackView addSubview:zgNoAnswerLab];
    
}

-(void)setDataModel:(OCLessonQuestionAllModel *)dataModel{
    _dataModel = dataModel;
    self.titleLab.text = [NSString stringWithFormat:@"本讲得分：%ld分",dataModel.score];
    
    self.kgTitleLab.text = [NSString stringWithFormat:@"客观题 %ld道",dataModel.objCount];
    self.kgCorrectLab.text = NSStringFormat(@"%ld",dataModel.objCorrectCount);
    self.kgErrorLab.text = NSStringFormat(@"%ld",dataModel.objErrorCount);
    self.kgNoAnswerLab.text = NSStringFormat(@"%ld", dataModel.objNoAnswerCount);
    
    self.zgTitleLab.text = [NSString stringWithFormat:@"主观题 %ld道",dataModel.subjCount];
    self.zgAnsweredLab.text = NSStringFormat(@"%ld",dataModel.subjAnswerCount);
    self.zgNoAnswerLab.text = NSStringFormat(@"%ld",dataModel.subjNoAnswerCount);
}
@end
