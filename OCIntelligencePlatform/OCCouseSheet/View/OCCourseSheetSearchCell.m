//
//  OCCourseSheetSearchCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSheetSearchCell.h"

@interface OCCourseSheetSearchCell ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *collectBtn;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *academyLab;
@property (strong, nonatomic) UILabel *weekLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *addressLab;
@property (weak, nonatomic) UIView *backView;

@end

@implementation OCCourseSheetSearchCell

+(instancetype)initOCCourseSheetSearchCellWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCCourseSheetSearchCellID";
    OCCourseSheetSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCCourseSheetSearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(20*FITWIDTH, 15*FITWIDTH, kViewW - 40*FITWIDTH, 185*FITWIDTH)];
    [backView setCornerRadius:4*FITWIDTH];
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    self.titleLab = [UILabel labelWithText:@"微观经济学" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(12*FITWIDTH, 15*FITWIDTH, backView.width - 80*FITWIDTH, 15*FITWIDTH)];
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    [backView addSubview:self.titleLab];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setTitle:@"收藏"];
    [self.collectBtn setTitleColor:WHITE];
    self.collectBtn.backgroundColor = kAPPCOLOR;
    self.collectBtn.titleLabel.font = kFont(10*FITWIDTH);
    self.collectBtn.frame = Rect(backView.width - 12*FITWIDTH - 44*FITWIDTH, 12*FITWIDTH, 44*FITWIDTH, 22*FITWIDTH);
    self.collectBtn.layer.cornerRadius = 11*FITWIDTH;
    [self.collectBtn addTarget:self action:@selector(collectClick)];
    [backView addSubview:self.collectBtn];
    
    self.nameLab = [UILabel labelWithText:@"教师：王名声" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.titleLab)+24*FITWIDTH, backView.width - 20*FITWIDTH, 12*FITWIDTH)];
    self.nameLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.nameLab];
    
    self.academyLab = [UILabel labelWithText:@"开课院系：经管学院" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, self.nameLab.oc_bottom+10*FITWIDTH, self.nameLab.width, 12*FITWIDTH)];
    self.academyLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.academyLab];
    
    self.weekLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, self.academyLab.oc_bottom+10*FITWIDTH, (backView.width-24*FITWIDTH)/3, 12*FITWIDTH)];
    self.weekLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.weekLab];

    self.timeLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(MaxX(self.weekLab), self.weekLab.y, self.weekLab.width, 12*FITWIDTH)];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.timeLab];
    
    self.addressLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(MaxX(self.timeLab), self.weekLab.y, self.weekLab.width, 12*FITWIDTH)];
    self.addressLab.textAlignment = NSTextAlignmentRight;
    self.addressLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.addressLab];
    
    UIButton *lookCourseSheetBtn = [UIButton buttonWithTitle:@"查看课表" titleColor:WHITE backgroundColor:kAPPCOLOR font:12*FITWIDTH image:nil target:self action:@selector(lookClick) frame:CGRectZero];
    lookCourseSheetBtn.size = CGSizeMake(88*FITWIDTH, 28*FITWIDTH);
    lookCourseSheetBtn.y = self.weekLab.oc_bottom+20*FITWIDTH;
    lookCourseSheetBtn.centerX = backView.width/2;
    lookCourseSheetBtn.layer.cornerRadius = lookCourseSheetBtn.height/2;
    [backView addSubview:lookCourseSheetBtn];

    CALayer *shadowLayer = [UIView creatShadowLayer:backView.frame cornerRadius:4*FITWIDTH backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:5];
    [self.contentView.layer insertSublayer:shadowLayer below:backView.layer];
//    [backView LX_SetShadowPathWith:[UIColor redColor] shadowOpacity:0.1 shadowRadius:4*FITWIDTH shadowSide:LXShadowPathAllSide shadowPathWidth:20];
}


-(void)setSheetModel:(OCSearchCourseSheetModel *)sheetModel{
    _sheetModel = sheetModel;
    self.titleLab.text = sheetModel.name;
    self.nameLab.text = NSStringFormat(@"教师：%@",sheetModel.teacher);
    self.academyLab.text = NSStringFormat(@"开课院系：%@",sheetModel.college);
    self.weekLab.text = NSStringFormat(@"周次：%@周",sheetModel.week);
    self.timeLab.text = NSStringFormat(@"时间：%@",sheetModel.time);
    self.addressLab.text = NSStringFormat(@"地点：%@",sheetModel.classroom);
    
    
    if (sheetModel.compulsory == 0) {
        self.collectBtn.hidden = NO;
        if (sheetModel.isCollect == 1) {
            self.collectBtn.frame = Rect(self.backView.width - 12*FITWIDTH - 64*FITWIDTH, 12*FITWIDTH, 64*FITWIDTH, 22*FITWIDTH);
            self.collectBtn.layer.cornerRadius = 11*FITWIDTH;
            self.collectBtn.layer.borderColor = kAPPCOLOR.CGColor;
            self.collectBtn.layer.borderWidth = 1.0f;
            self.collectBtn.backgroundColor = WHITE;
            self.collectBtn.title = @"取消收藏";
            self.collectBtn.titleColor = kAPPCOLOR;
        }else{
            self.collectBtn.frame = Rect(self.backView.width - 12*FITWIDTH - 44*FITWIDTH, 12*FITWIDTH, 44*FITWIDTH, 22*FITWIDTH);
            self.collectBtn.layer.cornerRadius = 11*FITWIDTH;
            self.collectBtn.layer.borderColor = CLEAR.CGColor;
            self.collectBtn.layer.borderWidth = 1.0f;
            self.collectBtn.backgroundColor = kAPPCOLOR;
            self.collectBtn.title = @"收藏";
            self.collectBtn.titleColor = WHITE;
        }
    }else{ // 是自己的课
        self.collectBtn.hidden = YES;
    }
}

-(void)lookClick{
    if ([self.delegate respondsToSelector:@selector(courseSheetLookWithModel:)]) {
        [self.delegate courseSheetLookWithModel:self.sheetModel];
    }
}

-(void)collectClick{
    if ([self.delegate respondsToSelector:@selector(courseSheetCollectWithModel:withForCell:)]) {
        [self.delegate courseSheetCollectWithModel:self.sheetModel withForCell:self];
    }
}

@end
