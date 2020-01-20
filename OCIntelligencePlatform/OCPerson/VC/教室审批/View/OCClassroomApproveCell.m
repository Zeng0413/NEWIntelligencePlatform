//
//  OCClassroomApproveCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/9.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomApproveCell.h"

@interface OCClassroomApproveCell ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *applyTimeLab;
@property (strong, nonatomic) UILabel *applyNameLab;
@property (strong, nonatomic) UILabel *roleLab;
@property (strong, nonatomic) UILabel *academyLab;
@property (strong, nonatomic) UILabel *applyTypeLab;
@property (strong, nonatomic) UILabel *applyReasonLab;

@property (strong, nonatomic) UIImageView *statusImg;
@property (strong, nonatomic) UIButton *agreementBtn;
@property (strong, nonatomic) UIButton *refuseBtn;
@property (strong, nonatomic) UIView *liveView;
@end

@implementation OCClassroomApproveCell

+(instancetype)initWithClassroomApproveWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCClassroomApproveCellID";
    OCClassroomApproveCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCClassroomApproveCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.titleLab = [UILabel labelWithText:@"南山校区-明德楼-1023" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, 15*FITWIDTH, kViewW - 20*FITWIDTH, 14*FITWIDTH)];
    self.titleLab.font = kBoldFont(14*FITWIDTH);
    [self.contentView addSubview:self.titleLab];
    
    self.applyTimeLab = [UILabel labelWithText:@"申请时间：2019年02月15日" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.titleLab)+13*FITWIDTH, self.titleLab.width, 12*FITWIDTH)];
    [self.contentView addSubview:self.applyTimeLab];
    
    CGFloat labW = (kViewW - 40*FITWIDTH)/3;
    self.applyNameLab = [UILabel labelWithText:@"申请人：王明明" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.applyTimeLab)+3*FITWIDTH, labW, 12*FITWIDTH)];
    [self.contentView addSubview:self.applyNameLab];
    
    self.roleLab = [UILabel labelWithText:@"角色：教师" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(MaxX(self.applyNameLab), self.applyNameLab.y, labW, 12*FITWIDTH)];
    self.roleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.roleLab];
    
    self.academyLab = [UILabel labelWithText:@"院系：中文系" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(MaxX(self.roleLab), self.applyNameLab.y, labW, 12*FITWIDTH)];
    [self.contentView addSubview:self.academyLab];
    
    self.applyTypeLab = [UILabel labelWithText:@"类型：普通申请" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.titleLab.x, MaxY(self.applyNameLab)+3*FITWIDTH, self.titleLab.width, 12*FITWIDTH)];
    [self.contentView addSubview:self.applyTypeLab];
    
    self.applyReasonLab = [UILabel labelWithText:@"申请事由：\n大家爱护的刷卡机会的确哦好哒时刻将罚款等后期哦我我殿后确定后大手大脚卡号的空间哈可好看" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    self.applyReasonLab.x = self.titleLab.x;
    self.applyReasonLab.y = MaxY(self.applyTypeLab)+3*FITWIDTH;
    self.applyReasonLab.size = [self.applyReasonLab.text sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW - 40*FITWIDTH];
    self.applyReasonLab.numberOfLines = 0;
    [self.contentView addSubview:self.applyReasonLab];
    
    self.refuseBtn = [UIButton buttonWithTitle:@"拒绝" titleColor:kAPPCOLOR backgroundColor:WHITE font:12*FITWIDTH image:nil target:self action:@selector(refuseClick) frame:Rect(kViewW/2+8*FITWIDTH, MaxY(self.applyReasonLab)+15*FITWIDTH, 64*FITWIDTH, 28*FITWIDTH)];
    self.refuseBtn.layer.borderColor = kAPPCOLOR.CGColor;
    self.refuseBtn.layer.borderWidth = 1.0f;
    self.refuseBtn.layer.cornerRadius = 14*FITWIDTH;
    [self.contentView addSubview:self.refuseBtn];
    
    self.agreementBtn = [UIButton buttonWithTitle:@"同意" titleColor:WHITE backgroundColor:kAPPCOLOR font:12*FITWIDTH image:nil target:self action:@selector(agreenClick) frame:Rect(kViewW/2-self.refuseBtn.width-8*FITWIDTH, self.refuseBtn.y, 64*FITWIDTH, 28*FITWIDTH)];
    self.agreementBtn.layer.cornerRadius = 14*FITWIDTH;
    [self.contentView addSubview:self.agreementBtn];
    
    self.liveView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, MaxY(self.agreementBtn)+30*FITWIDTH, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self.contentView addSubview:self.liveView];
    
    self.statusImg = [UIImageView imageViewWithImage:GetImage(@"mine_icon_pass") frame:Rect(kViewW - 29*FITWIDTH - 66*FITWIDTH, 42*FITWIDTH, 66*FITWIDTH, 66*FITWIDTH)];
    self.statusImg.hidden = YES;
    [self.contentView addSubview:self.statusImg];
    
    self.cellH = MaxY(self.liveView);
}

-(void)setDataModel:(OCClassroomBorrowModel *)dataModel{
    _dataModel = dataModel;
    self.titleLab.text = NSStringFormat(@"%@区-%@-%@",dataModel.campus,dataModel.buildName,dataModel.roomCode);
    NSString *borrowDateStr = [NSString formateDateToDay:NSStringFormat(@"%ld",dataModel.borrowTime)];
    self.applyTimeLab.text = NSStringFormat(@"申请时间：%@ 第%@节课",borrowDateStr,dataModel.borrowSection);
    self.applyNameLab.text = NSStringFormat(@"申请人：%@",dataModel.userName);
    self.roleLab.text = NSStringFormat(@"角色：%@",dataModel.userType==1?@"学生":@"老师");
    self.academyLab.text = NSStringFormat(@"院系：%@",dataModel.department);
    self.applyTypeLab.text = NSStringFormat(@"类型：%@",dataModel.type==1?@"普通申请":@"讲座申请");
    if (dataModel.type == 1) {
        self.applyReasonLab.text = NSStringFormat(@"申请事由：\n%@",dataModel.borrowReason);
    }else{
        self.applyReasonLab.text = NSStringFormat(@"讲座名称：%@",dataModel.name);

    }
    
    self.applyReasonLab.size = [self.applyReasonLab.text sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW - 40*FITWIDTH];
    if (dataModel.state == 1) {
        self.agreementBtn.hidden = NO;
        self.refuseBtn.hidden = NO;
        self.statusImg.hidden = YES;
        self.agreementBtn.y = MaxY(self.applyReasonLab)+15*FITWIDTH;
        self.refuseBtn.centerY = self.agreementBtn.centerY;
        self.liveView.y = MaxY(self.agreementBtn)+15*FITWIDTH;

    }else{
        if (dataModel.state == 2) {
            self.statusImg.image = GetImage(@"mine_icon_pass");
        }else if (dataModel.state == 3){
            self.statusImg.image = GetImage(@"mine_icon_refuse");
        }
        self.agreementBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
        self.statusImg.hidden = NO;
        self.liveView.y = MaxY(self.applyReasonLab)+15*FITWIDTH;
    }
    self.cellH = MaxY(self.liveView);

}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 0) {
        self.agreementBtn.hidden = NO;
        self.refuseBtn.hidden = NO;
        self.statusImg.hidden = YES;
        self.liveView.y = MaxY(self.agreementBtn)+30*FITWIDTH;
        self.cellH = MaxY(self.liveView);
    }else if (type == 1){
        self.agreementBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
        self.statusImg.hidden = NO;
        self.statusImg.image = GetImage(@"mine_icon_pass");
        self.liveView.y = MaxY(self.applyReasonLab)+15*FITWIDTH;
        self.cellH = MaxY(self.liveView);
    }else{
        self.agreementBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
        self.statusImg.hidden = NO;
        self.statusImg.image = GetImage(@"mine_icon_refuse");
        self.liveView.y = MaxY(self.applyReasonLab)+15*FITWIDTH;
        self.cellH = MaxY(self.liveView);
    }
}

-(void)refuseClick{
    if ([self.delegate respondsToSelector:@selector(cellOperateClickWithModel:withType:)]) {
        [self.delegate cellOperateClickWithModel:self.dataModel withType:3];
    }
}

-(void)agreenClick{
    if ([self.delegate respondsToSelector:@selector(cellOperateClickWithModel:withType:)]) {
        [self.delegate cellOperateClickWithModel:self.dataModel withType:2];
    }
}
@end
