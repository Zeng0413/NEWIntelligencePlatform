//
//  OCDefaultClassroomApplyView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCDefaultClassroomApplyView.h"

@interface OCDefaultClassroomApplyView ()
@property (weak, nonatomic) IBOutlet UIView *timeBackVIew;

@end

@implementation OCDefaultClassroomApplyView
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.reasonTextView.zw_placeHolder = @"多行输入";
    self.reasonTextView.zw_placeHolderColor = RGBA(190, 190, 190, 1);
    self.reasonTextView.layer.masksToBounds = YES;
    self.reasonTextView.layer.cornerRadius = 3;
    self.reasonTextView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.reasonTextView.layer.borderWidth = 1.0f;
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
        [self.timeBackVIew addSubview:btn];
        
        [self.buttons addObject:btn];
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

-(void)timeBtnClick:(UIButton *)button{
    
    if (self.isCanBtnClick) {
        if (!button.selected) {
            button.backgroundColor = kAPPCOLOR;
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

+(OCDefaultClassroomApplyView *)defaultClassroomApplyView{
    OCDefaultClassroomApplyView *view = [OCDefaultClassroomApplyView creatViewFromNib];
    return view;
}

- (IBAction)applyClassroomClick:(id)sender {
    if (self.block) {
        self.block(0);
    }
}
- (IBAction)borrowDateClick:(id)sender {
    if (self.block) {
        self.block(1);
    }
}
- (IBAction)submitClick:(id)sender {
    
    if ([self.applyClassroomLab.text isEqualToString:@"点击选择教室"]) {
        [MBProgressHUD showText:@"请选择教室"];
        return;
    }
    if ([self.timeLab.text isEqualToString:@"点击选择时间"]) {
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
    
    if (self.reasonTextView.text.length == 0) {
        [MBProgressHUD showText:@"请填写借用事由"];
        return;
    }
    
    NSString *dateInterval = NSStringFormat(@"%ld",[NSString gettimeStamp:self.timeLab.text]);
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
    if ([self.delegate respondsToSelector:@selector(defaultClassroomSubmitApplyWithApplyClassroomName:withDateInterval:withBorrowTimes:withReason:)]) {
        [self.delegate defaultClassroomSubmitApplyWithApplyClassroomName:self.applyClassroomLab.text withDateInterval:dateInterval withBorrowTimes:timesStr withReason:self.reasonTextView.text];
    }
}
@end
