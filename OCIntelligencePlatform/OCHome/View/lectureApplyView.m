//
//  lectureApplyView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "lectureApplyView.h"

@implementation lectureApplyView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.notifWidthW.constant = 170*FITWIDTH;
    self.lectureDecTextView.zw_placeHolder = @"多行输入";
    self.lectureDecTextView.zw_placeHolderColor = RGBA(190, 190, 190, 1);
    self.lectureDecTextView.layer.masksToBounds = YES;
    self.lectureDecTextView.layer.cornerRadius = 3;
    self.lectureDecTextView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.lectureDecTextView.layer.borderWidth = 1.0f;
    
    [self.liveBtn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageLeft imageTitleSpacing:6];
    [self.liveBtn setTitleColor:TEXT_COLOR_BLACK];
    self.liveBtn.titleFont = 15;
    [self.liveBtn setImage:GetImage(@"course_btn_square_sel") forState:UIControlStateNormal];
    [self.liveBtn setImage:GetImage(@"course_btn_square_nor") forState:UIControlStateSelected];
    
    [self.saveVideoBtn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageLeft imageTitleSpacing:6];
    [self.saveVideoBtn setTitleColor:TEXT_COLOR_BLACK];
    self.saveVideoBtn.titleFont = 15;
    [self.saveVideoBtn setImage:GetImage(@"course_btn_square_sel") forState:UIControlStateNormal];
    [self.saveVideoBtn setImage:GetImage(@"course_btn_square_nor") forState:UIControlStateSelected];
    
    self.submitBtn.layer.cornerRadius = 24;
    
    [self setTimeBackViewBtns];

}


-(void)setTimeBackViewBtns{
    NSArray *timeArr = @[@"第一节",@"第二节",@"第三节",@"第四节",@"第五节",@"第六节",@"第七节",@"第八节",@"第九节",@"第十节",@"第十一节",@"第十二节"];
    NSInteger row = 4;
    NSInteger border = 7;
    CGFloat btnW = (kViewW - 95 - border*(row - 1))/row;
    CGFloat btnH = 28;
    
    for (int i = 0; i<12; i++) {
        UIButton *btn = [UIButton buttonWithTitle:timeArr[i] titleColor:RGBA(153, 153, 153, 1) backgroundColor:WHITE font:12 image:nil target:self action:@selector(timeBtnClick:) frame:CGRectZero];
        btn.x = (i%row)*(btnW+border);
        btn.y = (i/row)*(btnH+17);
        btn.size = CGSizeMake(btnW, btnH);
        btn.layer.cornerRadius = 3;
        btn.tag = i;
        btn.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
        btn.layer.borderWidth = 1.0f;
        [btn setBackgroundColor:CLEAR];
        [self.timeBackView addSubview:btn];
        
        [self.buttons addObject:btn];
    }
}
- (IBAction)messageRangeClick:(id)sender {
    if (self.notificationBlock) {
        self.notificationBlock(messageType);
    }
   
}
- (IBAction)joinRangeClick:(id)sender {
    if (self.notificationBlock) {
        self.notificationBlock(joinType);
    }
}

+(lectureApplyView *)creatLectureApplyView{
    lectureApplyView *view = [lectureApplyView creatViewFromNib];
    return view;
}
- (IBAction)applyClassroonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(classroomOrDateClickWithType:)]) {
        [self.delegate classroomOrDateClickWithType:1];
    }
}
- (IBAction)borrowDateClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(classroomOrDateClickWithType:)]) {
        [self.delegate classroomOrDateClickWithType:2];
    }
}

- (IBAction)submitApplyClick:(id)sender {
    if (self.lectureNameTextField.text.length == 0) {
        [MBProgressHUD showText:@"请填写讲座名称"];
        return;
    }
    if (self.speakerTextField.text.length == 0) {
        [MBProgressHUD showText:@"请填写主讲人"];
        return;
    }
    if (self.lectureDecTextView.text.length == 0) {
        [MBProgressHUD showText:@"请填写讲座简介"];
        return;
    }
    if (self.lectureDecTextView.text.length == 0) {
        [MBProgressHUD showText:@"请填写讲座简介"];
        return;
    }
    if ([self.notificationRangeLab.text isEqualToString:@"点击选择"]) {
        [MBProgressHUD showText:@"请选择消息通知范围"];
        return;
    }
    if ([self.joinRangeLab.text isEqualToString:@"点击选择"]) {
        [MBProgressHUD showText:@"请选择参加范围"];
        return;
    }
    if ([self.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
        [MBProgressHUD showText:@"请选择教室"];
        return;
    }
    if ([self.borrowDateLab.text isEqualToString:@"点击选择日期"]) {
        [MBProgressHUD showText:@"请选择日期"];
        return;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    BOOL hasSelected = NO;
    for (UIButton *btn in self.buttons) {
        if (btn.selected) {
            hasSelected = YES;
            [tempArr addObject:btn];
        }
    }
    if (!hasSelected) {
        [MBProgressHUD showText:@"请选择借用时长"];
        return;
    }
    
    NSString *dateInterval = NSStringFormat(@"%ld",[NSString gettimeStamp:self.borrowDateLab.text]);
    NSString *timesStr = @"";
    
    NSMutableArray *numArr = [NSMutableArray array];
    for (int i = 0; i<tempArr.count; i++) {
        UIButton *timesBtn = tempArr[i];
        [numArr addObject:NSStringFormat(@"%ld",timesBtn.tag+1)];
        if (i == 0) {
            timesStr = NSStringFormat(@"%ld",timesBtn.tag+1);
        }else{
            timesStr = [timesStr stringByAppendingString:NSStringFormat(@",%ld",timesBtn.tag+1)];
        }
    }
    
    BOOL flag = [OCPublicMethodManager suibian:[numArr copy]];
    if (!flag) {
        [MBProgressHUD showText:@"借用时长需要连续，请重新选择"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(lectureApplySubmitWithLectureName:withSpeaker:withDec:isLive:isSaveVideo:notificationRange:joinRange:withApplyClassroom:withDateInterval:withBorrowTimes:)]) {
        [self.delegate lectureApplySubmitWithLectureName:self.lectureNameTextField.text withSpeaker:self.speakerTextField.text withDec:self.lectureDecTextView.text isLive:self.liveBtn.selected isSaveVideo:self.saveVideoBtn.selected notificationRange:@"" joinRange:4 withApplyClassroom:self.applyClassroomLab.text withDateInterval:dateInterval withBorrowTimes:timesStr];
    }
}

- (IBAction)liveClick:(UIButton *)sender {
    self.liveBtn.selected = !self.liveBtn.selected;
}

- (IBAction)saveVideoClick:(UIButton *)sender {
    self.saveVideoBtn.selected = !self.saveVideoBtn.selected;
}


-(void)timeBtnClick:(UIButton *)button{
    
    if (self.isCanBtnClick) {
        if (!button.selected) {
            button.backgroundColor = RGBA(141, 188, 255, 1);
            [button setTitleColor:WHITE];
            button.layer.borderColor = CLEAR.CGColor;
        }else{
            button.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
            button.backgroundColor = CLEAR;
            [button setTitleColor:RGBA(153, 153, 153, 1)];
            
        }
        button.selected = !button.selected;
    }else{
        [MBProgressHUD showText:@"请先选择申请教室或借用日期"];
    }
}


-(void)refreshBtnsStatus:(NSArray *)timeStatusArr{
    for (int i = 0; i < timeStatusArr.count; i++) {
        UIButton *btn = self.buttons[i];
        btn.selected = NO;
        NSInteger status = [timeStatusArr[i] integerValue];
        if (status == 0) {
            btn.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
            [btn setTitleColor:RGBA(153, 153, 153, 1)];
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = CLEAR;
        }else{
            btn.layer.borderColor = CLEAR.CGColor;
            [btn setTitleColor:WHITE];
            btn.userInteractionEnabled = NO;
            btn.backgroundColor = RGBA(234, 234, 234, 1);
        }
    }
}
@end
