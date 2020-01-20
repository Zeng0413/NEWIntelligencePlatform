//
//  OCClassroomBorrowCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomBorrowCell.h"
@interface OCClassroomBorrowCell()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *dateLab;
@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIButton *statusBtn;

@property (strong, nonatomic) UIView *contentBackView;
@property (strong, nonatomic) UIImageView *addImgView;

@end

@implementation OCClassroomBorrowCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, (kViewW - 40*FITWIDTH - 11*FITWIDTH)/2, 0)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    [self.contentView addSubview:backView];
    
    self.contentBackView = [UIView viewWithBgColor:WHITE frame:backView.bounds];
    [backView addSubview:self.contentBackView];
    
    self.selectedBtn = [[UIButton alloc] init];
    self.selectedBtn.size = CGSizeMake(13*FITWIDTH, 13*FITWIDTH);
    self.selectedBtn.x = self.selectedBtn.y = -(self.selectedBtn.width/2 - 2*FITWIDTH);
    [self.selectedBtn setBackgroundImage:GetImage(@"course_btn_circle_nor") forState:UIControlStateNormal];
    [self.selectedBtn setBackgroundImage:GetImage(@"course_btn_circle_sel") forState:UIControlStateSelected];
    [self.selectedBtn addTarget:self action:@selector(selectedClick)];
    self.selectedBtn.hidden = YES;
    [self.contentView addSubview:self.selectedBtn];
    
    self.titleLab = [UILabel labelWithText:@"江北校区-一教1023" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(12*FITWIDTH, 15*FITWIDTH, backView.width-12*FITWIDTH, 15*FITWIDTH)];
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    [self.contentBackView addSubview:self.titleLab];
    
    self.dateLab = [UILabel labelWithText:@"2019/05/28" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.titleLab)+15*FITWIDTH, self.titleLab.width, 14*FITWIDTH)];
    self.dateLab.font = kBoldFont(14*FITWIDTH);
    [self.contentBackView addSubview:self.dateLab];
    
    self.timeLab = [UILabel labelWithText:@"10:30-12:00" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.dateLab)+10*FITWIDTH, self.titleLab.width, 14*FITWIDTH)];
    self.timeLab.font = kBoldFont(14*FITWIDTH);
    [self.contentBackView addSubview:self.timeLab];
    
    self.statusBtn = [UIButton buttonWithTitle:@"已通过" titleColor:WHITE backgroundColor:kAPPCOLOR font:14*FITWIDTH image:nil target:self action:nil frame:Rect(30*FITWIDTH, MaxY(self.timeLab)+15*FITWIDTH, self.contentBackView.width-60*FITWIDTH, 26*FITWIDTH)];
    self.statusBtn.layer.cornerRadius = 3*FITWIDTH;
    [self.contentBackView addSubview:self.statusBtn];
    
    backView.height = MaxY(self.statusBtn)+15*FITWIDTH;
    self.contentBackView.height = backView.height;
    
    self.addImgView = [UIImageView imageViewWithImage:GetImage(@"course_btn_add") frame:CGRectZero];
    self.addImgView.size = CGSizeMake(52*FITWIDTH, 52*FITWIDTH);
    self.addImgView.centerX = backView.centerX;
    self.addImgView.centerY = backView.centerY;
    [backView addSubview:self.addImgView];
}

-(void)setBorrowModel:(OCClassroomBorrowModel *)borrowModel{
    _borrowModel = borrowModel;
    self.selectedBtn.selected = borrowModel.isSelected;
    self.titleLab.text = borrowModel.roomCode;
    self.dateLab.text = [NSString formateDateToDay:NSStringFormat(@"%ld",borrowModel.borrowTime)];
    self.timeLab.text = borrowModel.time;
    
    if (borrowModel.state == 3) { // 已拒绝
        self.titleLab.textColor = WHITE;
        self.dateLab.textColor = WHITE;
        self.timeLab.textColor = WHITE;
        self.contentBackView.backgroundColor = RGBA(254, 106, 107, 1);
        [self.statusBtn setBackgroundColor:WHITE];
        [self.statusBtn setTitleColor:RGBA(254, 106, 107, 1)];
        [self.statusBtn setTitle:@"已拒绝"];
    }else if (borrowModel.state == 2){ //已通过
        self.titleLab.textColor = RGBA(153, 153, 153, 1);
        self.dateLab.textColor = RGBA(153, 153, 153, 1);
        self.timeLab.textColor = RGBA(153, 153, 153, 1);
        self.contentBackView.backgroundColor = WHITE;
        [self.statusBtn setBackgroundColor:RGBA(39, 185, 140, 1)];
        [self.statusBtn setTitleColor:WHITE];
        [self.statusBtn setTitle:@"已通过"];

    }else if (borrowModel.state == 1){ // 等待审批
        self.titleLab.textColor = [UIColor blackColor];
        self.dateLab.textColor = TEXT_COLOR_GRAY;
        self.timeLab.textColor = TEXT_COLOR_GRAY;
        self.contentBackView.backgroundColor = WHITE;
        [self.statusBtn setBackgroundColor:kAPPCOLOR];
        [self.statusBtn setTitleColor:WHITE];
        [self.statusBtn setTitle:@"等待审批"];

    }
    
    if (borrowModel.expires == 1) { // 已过期
        self.titleLab.textColor = RGBA(153, 153, 153, 1);
        self.dateLab.textColor = RGBA(153, 153, 153, 1);
        self.timeLab.textColor = RGBA(153, 153, 153, 1);
        self.contentBackView.backgroundColor = WHITE;
        [self.statusBtn setBackgroundColor:RGBA(234, 234, 234, 1)];
        [self.statusBtn setTitleColor:WHITE];
    }
    
}

-(void)setIsNoData:(BOOL)isNoData{
    _isNoData = isNoData;
    if (isNoData) {
        self.addImgView.hidden = NO;
        self.contentBackView.hidden = YES;
    }else{
        self.addImgView.hidden = YES;
        self.contentBackView.hidden = NO;
    }
}

-(void)selectedClick{
    if ([self.delegate respondsToSelector:@selector(selectedCell:)]) {
        [self.delegate selectedCell:self];
    }
}
@end
