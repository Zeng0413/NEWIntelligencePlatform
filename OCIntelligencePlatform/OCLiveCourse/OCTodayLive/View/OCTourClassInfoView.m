//
//  OCTourClassInfoView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTourClassInfoView.h"

#define defaultX 20*FITWIDTH

@interface OCTourClassInfoView ()<UITextFieldDelegate>
{
    UITextField *currentTextField;
}

@end

@implementation OCTourClassInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.attitudeScore = 0;
        self.eduScore = 0;
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

-(void)setupUI{
    [kNotificationCenter addObserver:self
                               selector:@selector(bme_textFieldDidChanged:)
                                   name:UITextFieldTextDidChangeNotification
                                 object:nil];
    
    self.courseTitleLab = [UILabel labelWithText:@"授课内容提要" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(defaultX, 24*FITWIDTH, kViewW - 20*FITWIDTH, 15*FITWIDTH)];
    self.courseTitleLab.font = kBoldFont(15*FITWIDTH);
    [self addSubview:self.courseTitleLab];
    
    self.courseContentLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(defaultX, MaxY(self.courseTitleLab)+12*FITWIDTH, 0, 0)];
    self.courseContentLab.numberOfLines = 0;
    [self addSubview:self.courseContentLab];
    
    self.courseContentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.courseContentTextView.layer.masksToBounds = YES;
    self.courseContentTextView.layer.cornerRadius = 3;
    self.courseContentTextView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.courseContentTextView.layer.borderWidth = 1.0;
    self.courseContentTextView.font = kFont(15*FITWIDTH);
    self.courseContentTextView.zw_placeHolder = @"请输入摘要";
    self.courseContentTextView.zw_placeHolderColor = RGBA(190, 190, 190, 1);
    [self addSubview:self.courseContentTextView];
    
    self.lineView1 = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:CGRectZero];
    [self addSubview:self.lineView1];
    
    
    self.adviseTitleLab = [UILabel labelWithText:@"评价与建议" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.adviseTitleLab.font = kBoldFont(15*FITWIDTH);
    [self addSubview:self.adviseTitleLab];
    
    self.adviseContentLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    self.adviseContentLab.numberOfLines = 0;
    [self addSubview:self.adviseContentLab];
    
    self.adviseContentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.adviseContentTextView.layer.masksToBounds = YES;
    self.adviseContentTextView.layer.cornerRadius = 3;
    self.adviseContentTextView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.adviseContentTextView.layer.borderWidth = 1.0;
    self.adviseContentTextView.font = kFont(15*FITWIDTH);
    self.adviseContentTextView.zw_placeHolder = @"请输入评语与建议";
    self.adviseContentTextView.zw_placeHolderColor = RGBA(190, 190, 190, 1);
    
    [self addSubview:self.adviseContentTextView];
    
    self.lineView2 = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:CGRectZero];
    [self addSubview:self.lineView2];
    
    
    
    self.attitudeScroeTitleLab = [UILabel labelWithText:@"教学态度评分（满分50分）" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.attitudeScroeTitleLab.font = kBoldFont(15*FITWIDTH);
    [self addSubview:self.attitudeScroeTitleLab];
    
    self.attitudeScroeLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:[UIColor blackColor] frame:CGRectZero];
    self.attitudeScroeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.attitudeScroeLab];
    
    self.attitudeRemarkContentLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    self.attitudeRemarkContentLab.numberOfLines = 0;
    [self addSubview:self.attitudeRemarkContentLab];
    
    self.attitudeRemarkTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.attitudeRemarkTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10*FITWIDTH, 31*FITWIDTH)];
    self.attitudeRemarkTextField.leftViewMode = UITextFieldViewModeAlways;
    self.attitudeRemarkTextField.placeholder = @"备注";
    self.attitudeRemarkTextField.layer.masksToBounds = YES;
    self.attitudeRemarkTextField.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.attitudeRemarkTextField.layer.borderWidth = 1.0f;
    self.attitudeRemarkTextField.layer.cornerRadius = 3;
    self.attitudeRemarkTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.attitudeRemarkTextField.font = kFont(15*FITWIDTH);
    [self addSubview:self.attitudeRemarkTextField];
    
    self.attitudeScroeOperationView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
    self.attitudeScroeOperationView.layer.masksToBounds = YES;
    self.attitudeScroeOperationView.layer.borderWidth = 1.0;
    self.attitudeScroeOperationView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    [self addSubview:self.attitudeScroeOperationView];
    UIButton *attitudeScroeReduceBtn = [UIButton buttonWithTitle:@"-" titleColor:[UIColor blackColor] backgroundColor:WHITE font:12*FITWIDTH image:nil target:self action:@selector(attitudeReduceClick) frame:Rect(0, 0, 26*FITWIDTH, 20*FITWIDTH)];
    [self.attitudeScroeOperationView addSubview:attitudeScroeReduceBtn];
    self.attitudeScroeTextField = [[UITextField alloc] initWithFrame:Rect(MaxX(attitudeScroeReduceBtn), 0, 44*FITWIDTH, 20*FITWIDTH)];
    self.attitudeScroeTextField.font = kFont(12*FITWIDTH);
    self.attitudeScroeTextField.text = NSStringFormat(@"%ld",self.attitudeScore);
    self.attitudeScroeTextField.borderStyle = UITextBorderStyleLine;
    self.attitudeScroeTextField.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.attitudeScroeTextField.layer.borderWidth = 1.0f;
    self.attitudeScroeTextField.textAlignment = NSTextAlignmentCenter;
    self.attitudeScroeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.attitudeScroeTextField.tag = 100;
    self.attitudeScroeTextField.delegate = self;
    [self.attitudeScroeOperationView addSubview:self.attitudeScroeTextField];
    UIButton *attitudeScroeAddBtn = [UIButton buttonWithTitle:@"+" titleColor:[UIColor blackColor] backgroundColor:WHITE font:12*FITWIDTH image:nil target:self action:@selector(attitudeAddClick) frame:Rect(MaxX(self.attitudeScroeTextField), 0, 26*FITWIDTH, 20*FITWIDTH)];
    [self.attitudeScroeOperationView addSubview:attitudeScroeAddBtn];
    self.lineView3 = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:CGRectZero];
    [self addSubview:self.lineView3];
    
    
    self.eduContentScroeTitleLab = [UILabel labelWithText:@"教学内容评分（满分50分）" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.eduContentScroeTitleLab.font = kBoldFont(15*FITWIDTH);
    [self addSubview:self.eduContentScroeTitleLab];
    
    
    self.eduContentScroeLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:[UIColor blackColor] frame:CGRectZero];
    self.eduContentScroeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.eduContentScroeLab];
    
    self.eduContentRemarkContentLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    self.eduContentRemarkContentLab.numberOfLines = 0;
    [self addSubview:self.eduContentRemarkContentLab];
    
    self.eduContentRemarkTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.eduContentRemarkTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10*FITWIDTH, 31*FITWIDTH)];
    self.eduContentRemarkTextField.leftViewMode = UITextFieldViewModeAlways;
    self.eduContentRemarkTextField.placeholder = @"备注";
    self.eduContentRemarkTextField.layer.masksToBounds = YES;
    self.eduContentRemarkTextField.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.eduContentRemarkTextField.layer.borderWidth = 1.0f;
    self.eduContentRemarkTextField.layer.cornerRadius = 3;
    self.eduContentRemarkTextField.font = kFont(15*FITWIDTH);
    [self addSubview:self.eduContentRemarkTextField];
    
    self.eduContentScroeOperationView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
    self.eduContentScroeOperationView.layer.masksToBounds = YES;
    self.eduContentScroeOperationView.layer.borderWidth = 1.0;
    self.eduContentScroeOperationView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    [self addSubview:self.eduContentScroeOperationView];
    UIButton *eduScroeReduceBtn = [UIButton buttonWithTitle:@"-" titleColor:[UIColor blackColor] backgroundColor:WHITE font:12*FITWIDTH image:nil target:self action:@selector(eduReduceClick) frame:Rect(0, 0, 26*FITWIDTH, 20*FITWIDTH)];
    [self.eduContentScroeOperationView addSubview:eduScroeReduceBtn];
    self.eduScroeTextField = [[UITextField alloc] initWithFrame:Rect(MaxX(eduScroeReduceBtn), 0, 44*FITWIDTH, 20*FITWIDTH)];
    self.eduScroeTextField.font = kFont(12*FITWIDTH);
    self.eduScroeTextField.text = NSStringFormat(@"%ld",self.eduScore);
    self.eduScroeTextField.borderStyle = UITextBorderStyleLine;
    self.eduScroeTextField.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
    self.eduScroeTextField.layer.borderWidth = 1.0f;
    self.eduScroeTextField.textAlignment = NSTextAlignmentCenter;
    self.eduScroeTextField.tag = 101;
    self.eduScroeTextField.delegate = self;
    self.eduScroeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.eduContentScroeOperationView addSubview:self.eduScroeTextField];
    UIButton *eduScroeAddBtn = [UIButton buttonWithTitle:@"+" titleColor:[UIColor blackColor] backgroundColor:WHITE font:12*FITWIDTH image:nil target:self action:@selector(eduAddClick) frame:Rect(MaxX(self.eduScroeTextField), 0, 26*FITWIDTH, 20*FITWIDTH)];
    [self.eduContentScroeOperationView addSubview:eduScroeAddBtn];
    
}

- (void)bme_textFieldDidChanged:(NSNotification *)notic {
    CGFloat fraction = [currentTextField.text floatValue];

    if (fraction>50) {
        currentTextField.text = @"50";
    }
    if (currentTextField.tag == 100) {
        self.attitudeScore = [currentTextField.text integerValue];
    }else{
        self.eduScore = [currentTextField.text integerValue];
    }
    NSLog(@"textField = %@",currentTextField.text);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        currentTextField = self.attitudeScroeTextField;
    }else{
        currentTextField = self.eduScroeTextField;
    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSInteger scroeNum = [NSStringFormat(@"%@%@",textField.text,string) integerValue];
//    if (scroeNum>50) {
//        scroeNum = 50;
//    }
//    if (textField.tag == 100) {
//        self.attitudeScroeTextField.text = NSStringFormat(@"%ld",scroeNum);
//    }else{
//        self.eduScroeTextField.text = NSStringFormat(@"%ld",scroeNum);
//    }
//    return YES;
//}
-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    
    if (self.model==nil) {
        self.attitudeScore = 50;
        self.eduScore = 50;
    }else{
        self.attitudeScore = [self.model.attitudeScore integerValue];
        self.eduScore = self.model.contentsScore;
    }
    
    
    if (isEdit) {
        self.courseContentLab.hidden = YES;
        self.lineView1.hidden = YES;
        self.adviseContentLab.hidden = YES;
        self.lineView2.hidden = YES;
        self.attitudeScroeLab.hidden = YES;
        self.attitudeRemarkContentLab.hidden = YES;
        self.lineView3.hidden = YES;
        self.eduContentScroeLab.hidden = YES;
        self.eduContentRemarkContentLab.hidden = YES;
        self.courseContentTextView.hidden = NO;
        self.adviseContentTextView.hidden = NO;
        self.attitudeScroeOperationView.hidden = NO;
        self.attitudeRemarkTextField.hidden = NO;
        self.eduContentScroeOperationView.hidden = NO;
        self.eduContentRemarkTextField.hidden = NO;
        
        self.courseContentTextView.frame = Rect(defaultX, MaxY(self.courseTitleLab)+15*FITWIDTH, kViewW-defaultX*2, 111*FITWIDTH);
        self.courseContentTextView.text = self.model.summary;
        
        self.adviseTitleLab.frame = Rect(defaultX, MaxY(self.courseContentTextView)+30*FITWIDTH, kViewW - defaultX, 15*FITWIDTH);
        self.adviseContentTextView.frame = Rect(defaultX, MaxY(self.adviseTitleLab)+15*FITWIDTH, kViewW-defaultX*2, 111*FITWIDTH);
        self.adviseContentTextView.text = self.model.evaluate;
        
        self.attitudeScroeTitleLab.frame = Rect(defaultX, MaxY(self.adviseContentTextView)+30*FITWIDTH, 0, 0);
        self.attitudeScroeTitleLab.size = [self.attitudeScroeTitleLab.text sizeWithFont:kBoldFont(15*FITWIDTH)];
        self.attitudeScroeOperationView.frame = Rect(kViewW - 20*FITWIDTH - 96*FITWIDTH, 0, 96*FITWIDTH, 20*FITWIDTH);
        self.attitudeScroeOperationView.centerY = self.attitudeScroeTitleLab.centerY;
        self.attitudeScroeTextField.text = self.model.attitudeScore.length == 0?@"50":self.model.attitudeScore;
        self.attitudeRemarkTextField.frame = Rect(defaultX, MaxY(self.attitudeScroeTitleLab)+15*FITWIDTH, kViewW - defaultX*2, 31*FITWIDTH);
        self.attitudeRemarkTextField.text = self.model.attitudeRemarks;
        
        self.eduContentScroeTitleLab.frame = Rect(defaultX, MaxY(self.attitudeRemarkTextField)+30*FITWIDTH, 0, 0);
        self.eduContentScroeTitleLab.size = [self.eduContentScroeTitleLab.text sizeWithFont:kBoldFont(15*FITWIDTH)];
        self.eduContentScroeOperationView.frame = Rect(kViewW - 20*FITWIDTH - 96*FITWIDTH, 0, 96*FITWIDTH, 20*FITWIDTH);
        self.eduContentScroeOperationView.centerY = self.eduContentScroeTitleLab.centerY;
        self.eduScroeTextField.text = NSStringFormat(@"%ld",self.model.contentsScore==nil?50:self.model.contentsScore);
        self.eduContentRemarkTextField.frame = Rect(defaultX, MaxY(self.eduContentScroeTitleLab)+15*FITWIDTH, kViewW - defaultX*2, 31*FITWIDTH);
        self.eduContentRemarkTextField.text =self.model.contentsRemarks;
        
        self.viewH = MaxY(self.eduContentRemarkTextField);
    }else{
        self.courseContentLab.hidden = NO;
        self.lineView1.hidden = NO;
        self.adviseContentLab.hidden = NO;
        self.lineView2.hidden = NO;
        self.attitudeScroeLab.hidden = NO;
        self.attitudeRemarkContentLab.hidden = NO;
        self.lineView3.hidden = NO;
        self.eduContentScroeLab.hidden = NO;
        self.eduContentRemarkContentLab.hidden = NO;
        
        self.courseContentTextView.hidden = YES;
        self.adviseContentTextView.hidden = YES;
        self.attitudeScroeOperationView.hidden = YES;
        self.attitudeRemarkTextField.hidden = YES;
        self.eduContentScroeOperationView.hidden = YES;
        self.eduContentRemarkTextField.hidden = YES;
        
        self.courseContentLab.frame = Rect(defaultX, MaxY(self.courseTitleLab)+12*FITWIDTH, 0, 0);
        self.courseContentLab.text = self.model.summary;
        self.courseContentLab.size = [self.courseContentLab.text sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW-defaultX*2];
        self.lineView1.frame = Rect(defaultX, MaxY(self.courseContentLab)+15*FITWIDTH, kViewW-defaultX*2, 1*FITWIDTH);
        
        self.adviseTitleLab.frame = Rect(defaultX, MaxY(self.lineView1)+15*FITWIDTH, kViewW-defaultX, 15*FITWIDTH);
        self.adviseContentLab.frame = Rect(defaultX, MaxY(self.adviseTitleLab)+12*FITWIDTH, 0, 0);
        self.adviseContentLab.text = self.model.evaluate;
        self.adviseContentLab.size = [self.adviseContentLab.text sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW-defaultX*2];
        self.lineView2.frame = Rect(defaultX, MaxY(self.adviseContentLab)+15*FITWIDTH, kViewW-defaultX*2, 1*FITWIDTH);
        
        self.attitudeScroeTitleLab.frame = Rect(defaultX, MaxY(self.lineView2)+18*FITWIDTH, 0, 0);
        self.attitudeScroeTitleLab.size = [self.attitudeScroeTitleLab.text sizeWithFont:kBoldFont(15*FITWIDTH)];
        self.attitudeScroeLab.frame = Rect(kViewW - 20*FITWIDTH - 80*FITWIDTH, 0, 80*FITWIDTH, 12*FITWIDTH);
        self.attitudeScroeLab.text = NSStringFormat(@"%@分",self.model.attitudeScore);
        self.attitudeScroeLab.centerY = self.attitudeScroeTitleLab.centerY;
        if (self.model.attitudeRemarks.length==0) {
            self.attitudeRemarkContentLab.hidden = YES;
            self.lineView3.frame = Rect(defaultX, MaxY(self.attitudeScroeTitleLab)+18*FITWIDTH, kViewW-defaultX*2, 1*FITWIDTH);
        }else{
            self.attitudeRemarkContentLab.hidden = NO;
            CGSize attRemarkSize = [self.model.attitudeRemarks sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW - defaultX*2];
            self.attitudeRemarkContentLab.frame = (CGRect){{defaultX, MaxY(self.attitudeScroeTitleLab)+12*FITWIDTH}, attRemarkSize};
            self.attitudeRemarkContentLab.text = self.model.attitudeRemarks;
            self.lineView3.frame = Rect(defaultX, MaxY(self.attitudeRemarkContentLab)+15*FITWIDTH, kViewW-defaultX*2, 1*FITWIDTH);
        }
        
        self.eduContentScroeTitleLab.frame = Rect(defaultX, MaxY(self.lineView3)+18*FITWIDTH, 0, 0);
        self.eduContentScroeTitleLab.size = [self.eduContentScroeTitleLab.text sizeWithFont:kBoldFont(15*FITWIDTH)];
        self.eduContentScroeLab.frame = Rect(kViewW - 20*FITWIDTH - 80*FITWIDTH, 0, 80*FITWIDTH, 12*FITWIDTH);
        self.eduContentScroeLab.text = NSStringFormat(@"%ld分",self.model.contentsScore);
        self.eduContentScroeLab.centerY = self.eduContentScroeTitleLab.centerY;
        NSString *eduStr = self.model.contentsRemarks;
        if (eduStr.length==0) {
            self.eduContentRemarkContentLab.hidden = YES;
            self.viewH = MaxY(self.eduContentScroeTitleLab);
        }else{
            self.eduContentRemarkContentLab.hidden = NO;
            CGSize eduRemarkSize = [eduStr sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW - defaultX*2];
            self.eduContentRemarkContentLab.frame = (CGRect){{defaultX, MaxY(self.eduContentScroeTitleLab)+12*FITWIDTH}, eduRemarkSize};
            self.eduContentRemarkContentLab.text = eduStr;
            self.viewH = MaxY(self.eduContentRemarkContentLab);
        }
        
        
    }
}

-(void)setDataSource:(id)dataSource{
    _dataSource = dataSource;
}


-(void)attitudeReduceClick{
    self.attitudeScore--;
    self.attitudeScore = self.attitudeScore <= 0?0 : self.attitudeScore;
    self.attitudeScroeTextField.text = NSStringFormat(@"%ld",self.attitudeScore);
}

-(void)attitudeAddClick{
    self.attitudeScore++;
    self.attitudeScore = self.attitudeScore>=50?50:self.attitudeScore;
    self.attitudeScroeTextField.text = NSStringFormat(@"%ld",self.attitudeScore);
}

-(void)eduReduceClick{
    self.eduScore--;
    self.eduScore = self.eduScore <= 0?0 : self.eduScore;
    self.eduScroeTextField.text = NSStringFormat(@"%ld",self.eduScore);
}

-(void)eduAddClick{
    self.eduScore++;
    self.eduScore = self.eduScore>=50?50:self.eduScore;
    self.eduScroeTextField.text = NSStringFormat(@"%ld",self.eduScore);
}

@end
