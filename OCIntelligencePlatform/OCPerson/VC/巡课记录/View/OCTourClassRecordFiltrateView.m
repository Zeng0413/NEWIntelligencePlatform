//
//  OCTourClassRecordFiltrateView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTourClassRecordFiltrateView.h"

@interface OCTourClassRecordFiltrateView ()
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *teachName;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;

@property (assign, nonatomic) NSInteger startTime;
@property (assign, nonatomic) NSInteger endTime;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end

@implementation OCTourClassRecordFiltrateView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.resetBtn.layer.borderColor = kAPPCOLOR.CGColor;
    self.resetBtn.layer.borderWidth = 1.0f;
    self.resetBtn.layer.cornerRadius = 14;
    
    [self LX_SetShadowPathWith:TEXT_COLOR_GRAY shadowOpacity:0.1 shadowRadius:2 shadowSide:LXShadowPathBottom shadowPathWidth:10];
}

+(OCTourClassRecordFiltrateView *)creatTourClassRecordFiltrateView{
    OCTourClassRecordFiltrateView *view = [OCTourClassRecordFiltrateView creatViewFromNib];
    return view;
}
- (IBAction)startTimeClick:(id)sender {
    [self endEditing:YES];
    Weak;
    [BRDatePickerView showDatePickerWithTitle:@"开始时间" dateType:BRDatePickerModeYMD defaultSelValue:nil minDate:nil maxDate:self.endDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        wself.startDate = [NSDate dateFromString:selectValue withFormat:@"yyyy-MM-dd"];
        wself.startTime = [NSString gettimeStamp:selectValue];
        wself.startTimeLab.text = selectValue;
        NSLog(@"%@",wself.startDate);
    }];
}
- (IBAction)endTimeClick:(id)sender {
    [self endEditing:YES];
    Weak;
    [BRDatePickerView showDatePickerWithTitle:@"结束时间" dateType:BRDatePickerModeYMD defaultSelValue:nil minDate:self.startDate maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        wself.endDate = [NSDate dateFromString:selectValue withFormat:@"yyyy-MM-dd"];
        wself.endTime = [NSString gettimeStamp:selectValue];
        wself.endTimeLab.text = selectValue;
    }];
}

- (IBAction)searchClick:(id)sender {
    [self endEditing:YES];

    if ([self.delegate respondsToSelector:@selector(tourClassSearchClickWithCourseName:withTeachName:withStarTime:withEndTime:)]) {
        [self.delegate tourClassSearchClickWithCourseName:self.courseName.text withTeachName:self.teachName.text withStarTime:self.startTime?self.startTime:0 withEndTime:self.endTime?self.endTime:0];
    }
}

- (IBAction)resetClick:(id)sender {
    [self endEditing:YES];

    self.courseName.text = @"";
    self.teachName.text = @"";
    self.startTime = 0;
    self.startTimeLab.text = @"开始时间";
    self.endTime = 0;
    self.endTimeLab.text = @"结束时间";
    
    if ([self.delegate respondsToSelector:@selector(tourClassSearchClickWithCourseName:withTeachName:withStarTime:withEndTime:)]) {
        [self.delegate tourClassSearchClickWithCourseName:self.courseName.text withTeachName:self.teachName.text withStarTime:self.startTime?self.startTime:0 withEndTime:self.endTime?self.endTime:0];
    }
}

@end
