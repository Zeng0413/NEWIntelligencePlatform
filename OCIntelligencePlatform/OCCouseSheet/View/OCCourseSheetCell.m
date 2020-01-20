//
//  OCCourseSheetCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/29.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSheetCell.h"
#import "OCCourseWareModel.h"

@interface OCCourseSheetCell ()
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *addressLab;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *academyLab;
@property (strong, nonatomic) UILabel *attendanceStatus;
@property (strong, nonatomic) UILabel *courseDataLab;
@property (strong, nonatomic) UIButton *openBtn;
@property (strong, nonatomic) UIButton *collectBtn;

@property (strong, nonatomic) CALayer *shadowLayer;

@property (strong, nonatomic) UIButton *selectedBtn;
@property (weak, nonatomic) UIButton *lookVideoBtn;
@property (weak, nonatomic) UIButton *cancelCollectBtn;
@property (assign, nonatomic) BOOL isSelected;
@end


@implementation OCCourseSheetCell

+(instancetype)initWithOCCourseSheetCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCCourseSheetCellID";
    OCCourseSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCCourseSheetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kBACKCOLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    self.backView = [UIView viewWithBgColor:WHITE frame:Rect(20*FITWIDTH, 15*FITWIDTH, kViewW-40*FITWIDTH, 0)];
    [self.contentView addSubview:self.backView];
    
    self.topView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, self.backView.width, 0)];
    [self.backView addSubview:self.topView];
    
    self.openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.openBtn setBackgroundImage:GetImage(@"common_btn_more_up") forState:UIControlStateSelected];
    [self.openBtn setBackgroundImage:GetImage(@"common_btn_downMore") forState:UIControlStateNormal];
    self.openBtn.frame = Rect(self.topView.width - 12*FITWIDTH - 40*FITWIDTH, 9*FITWIDTH, 40*FITWIDTH, 20*FITWIDTH);
    [self.openBtn addTarget:self action:@selector(openClick:)];
//    [self.topView addSubview:self.openBtn];
    
//    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.collectBtn setTitle:@"收藏"];
//    [self.collectBtn setTitleColor:WHITE];
//    self.collectBtn.backgroundColor = kAPPCOLOR;
//    self.collectBtn.titleLabel.font = kFont(10*FITWIDTH);
//    self.collectBtn.frame = Rect(self.topView.width - 12*FITWIDTH - 44*FITWIDTH, 12*FITWIDTH, 44*FITWIDTH, 22*FITWIDTH);
//    self.collectBtn.layer.cornerRadius = 11*FITWIDTH;
//    [self.collectBtn addTarget:self action:@selector(collectClick)];
//    [self.topView addSubview:self.collectBtn];
    
    self.titleLab = [UILabel labelWithText:@"微观经济学" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(12*FITWIDTH, 15*FITWIDTH, self.topView.width - 12*FITWIDTH, 15*FITWIDTH)];
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    [self.topView addSubview:self.titleLab];
    
    CGFloat timeOrAddW = (self.topView.width - 24*FITWIDTH)/2;
    self.timeLab = [UILabel labelWithText:@"时间：09：40" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.titleLab)+15*FITWIDTH, timeOrAddW, 12*FITWIDTH)];
    self.timeLab.font = kBoldFont(12*FITWIDTH);
    [self.topView addSubview:self.timeLab];
    
    self.addressLab = [UILabel labelWithText:@"地点：明德楼06-23" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.topView.width - 12*FITWIDTH - timeOrAddW, self.timeLab.y, self.timeLab.width, 12*FITWIDTH)];
    self.addressLab.font = kBoldFont(12*FITWIDTH);
    [self.topView addSubview:self.addressLab];
    
    self.nameLab = [UILabel labelWithText:@"教师：王名声" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(12*FITWIDTH, MaxY(self.timeLab)+10*FITWIDTH, timeOrAddW, 12*FITWIDTH)];
    self.nameLab.font = kBoldFont(12*FITWIDTH);
    [self.topView addSubview:self.nameLab];
    
    self.academyLab = [UILabel labelWithText:@"开课院系：经管学院" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.topView.width - 12*FITWIDTH - timeOrAddW, self.nameLab.y, timeOrAddW, 12*FITWIDTH)];
    self.academyLab.font = kBoldFont(12*FITWIDTH);
    [self.topView addSubview:self.academyLab];
    
    self.attendanceStatus = [UILabel labelWithText:@"考勤状态：未开始" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(12*FITWIDTH, MaxY(self.nameLab)+10*FITWIDTH, self.topView.width-24*FITWIDTH, 12*FITWIDTH)];
    self.attendanceStatus.font = kBoldFont(12*FITWIDTH);
    [self.topView addSubview:self.attendanceStatus];
    self.topView.height = MaxY(self.attendanceStatus)+24*FITWIDTH;
    
    
    self.bottomView = [UIView viewWithBgColor:WHITE frame:Rect(0, MaxY(self.topView), self.backView.width, 0)];
    [self.backView addSubview:self.bottomView];

    UILabel *courseDataLab = [UILabel labelWithText:@"课程资料：" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    courseDataLab.x = self.attendanceStatus.x;
    courseDataLab.y = 10*FITWIDTH;
    courseDataLab.size = [courseDataLab.text sizeWithFont:kBoldFont(12*FITWIDTH)];
    courseDataLab.font = kBoldFont(12*FITWIDTH);
    [self.bottomView addSubview:courseDataLab];
    self.courseDataLab = courseDataLab;
    
    UIButton *lookVideoBtn = [UIButton buttonWithTitle:@"查看录播" titleColor:WHITE backgroundColor:kAPPCOLOR font:12*FITWIDTH image:nil frame:Rect(self.bottomView.width/2-10*FITWIDTH-88*FITWIDTH, 0, 88*FITWIDTH, 28*FITWIDTH)];
    lookVideoBtn.layer.cornerRadius = 14*FITWIDTH;
    [self.bottomView addSubview:lookVideoBtn];
    self.lookVideoBtn = lookVideoBtn;
    
    UIButton *cancelCollectBtn = [UIButton buttonWithTitle:@"取消收藏" titleColor:kAPPCOLOR backgroundColor:WHITE font:12*FITWIDTH image:nil frame:Rect(self.bottomView.width/2+10*FITWIDTH, lookVideoBtn.y, 88*FITWIDTH, 28*FITWIDTH)];
    cancelCollectBtn.layer.cornerRadius = 14*FITWIDTH;
    cancelCollectBtn.layer.borderColor = kAPPCOLOR.CGColor;
    cancelCollectBtn.layer.borderWidth = 1.0f;
    [self.bottomView addSubview:cancelCollectBtn];
    self.cancelCollectBtn = cancelCollectBtn;
    self.bottomView.height = MaxY(lookVideoBtn)+24*FITWIDTH;
    
    self.shadowLayer = [UIView creatShadowLayer:CGRectZero cornerRadius:6 backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:5];
    [self.contentView.layer insertSublayer:self.shadowLayer below:self.backView.layer];
}

-(void)setSheetModel:(OCCourseSheetModel *)sheetModel{
    _sheetModel = sheetModel;
    
    if (sheetModel.courseware.count==0) {
        self.lookVideoBtn.y = 22*FITWIDTH;
        self.courseDataLab.hidden = YES;
    }else{
        self.courseDataLab.hidden = NO;

        UIButton *lastBtn = nil;
        NSInteger dataCount = sheetModel.courseware.count;
        for (int i = 0; i<dataCount; i++) {
            OCCourseWareModel *model = sheetModel.courseware[i];
            UIButton *btn = [UIButton buttonWithTitle:model.title titleColor:TEXT_COLOR_BLACK backgroundColor:CLEAR font:12*FITWIDTH image:@"common_btn_download" frame:CGRectZero];
            btn.titleLabel.font = kBoldFont(12*FITWIDTH);
            CGSize btnSize = [btn.titleLabel.text sizeWithFont:kBoldFont(12*FITWIDTH)];
            btn.width = btnSize.width + 30*FITWIDTH;
            btn.height = btnSize.height;
            btn.x = MaxX(self.courseDataLab);
            btn.y = self.courseDataLab.y + (btn.height+15*FITWIDTH)*i;
            
            [btn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageRight imageTitleSpacing:10*FITWIDTH];
            [self.bottomView addSubview:btn];
            if (i == dataCount - 1) {
                lastBtn = btn;
            }
        }
        self.lookVideoBtn.y = MaxY(lastBtn)+22*FITWIDTH;
    }
    self.cancelCollectBtn.y = self.lookVideoBtn.y;
    self.bottomView.height = MaxY(self.lookVideoBtn)+24*FITWIDTH;
    
    if (self.sheetModel.isOpen) {
        self.bottomView.hidden = NO;
        self.backView.height = MaxY(self.bottomView);
        self.openBtn.selected = YES;
    }else{
        self.bottomView.hidden = YES;
        self.backView.height = MaxY(self.topView);
        self.openBtn.selected = NO;
    }
    
    self.titleLab.text = sheetModel.courseName;
    self.timeLab.text = NSStringFormat(@"时间：%@",sheetModel.time);
    self.addressLab.text = NSStringFormat(@"地点：%@",sheetModel.classroom);
    self.nameLab.text = NSStringFormat(@"教师：%@",sheetModel.teacherName);
    self.academyLab.text = NSStringFormat(@"开课院系：%@",sheetModel.college);
    self.attendanceStatus.text = NSStringFormat(@"考勤状态：%@",sheetModel.attendanceStatus == 0?@"未开始":@"即将开始")                                                                                                                                     ;
    

    self.topView.layer.cornerRadius = 7*FITWIDTH;
    self.bottomView.layer.cornerRadius = 7*FITWIDTH;
    self.backView.layer.cornerRadius = 7*FITWIDTH;
    self.shadowLayer.frame = self.backView.frame;
    self.cellH = self.backView.height+15*FITWIDTH;
}

-(void)openClick:(UIButton *)sender{
    sender.selected = !sender.selected;

//        self.selectedBtn.selected = NO;
//    sender.selected = YES;
//        self.selectedBtn = sender;
    
    if ([self.delegate respondsToSelector:@selector(selectedCell:withIsOpen:)]) {
        [self.delegate selectedCell:self withIsOpen:self.sheetModel.isOpen];
    }
}

-(void)collectClick{
    
}
@end
