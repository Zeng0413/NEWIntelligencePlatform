//
//  OCClassroomListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomListCell.h"

@interface OCClassroomListCell ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *storeyLab;
@property (strong, nonatomic) UILabel *usingLab;
@property (strong, nonatomic) UILabel *freeLab;
@property (strong, nonatomic) UILabel *closeLab;

@end

@implementation OCClassroomListCell

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
    
    self.img = [UIImageView imageViewWithUrl:nil frame:Rect(0, 0, backView.width, 92*FITWIDTH)];
    self.img.backgroundColor = TEXT_COLOR_LIGHT_GRAY;
    [backView addSubview:self.img];
    
    self.titleLab = [UILabel labelWithText:@"三号教学楼" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(12*FITWIDTH, MaxY(self.img)+12*FITWIDTH, backView.width-80*FITWIDTH, 15*FITWIDTH)];
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    [backView addSubview:self.titleLab];
    
    self.storeyLab = [UILabel labelWithText:@"共5层" font:11*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(backView.width - 12*FITWIDTH - 68*FITWIDTH, 0, 68*FITWIDTH, 11*FITWIDTH)];
    self.storeyLab.textAlignment = NSTextAlignmentRight;
    self.storeyLab.centerY = self.titleLab.centerY;
    self.storeyLab.font = kFont(11*FITWIDTH);
    [backView addSubview:self.storeyLab];
    
    self.usingLab = [UILabel labelWithText:@"使用中：20个" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(12*FITWIDTH, MaxY(self.titleLab)+15*FITWIDTH, backView.width-12*FITWIDTH, 12*FITWIDTH)];
    self.usingLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.usingLab];
    
    self.freeLab = [UILabel labelWithText:@"空闲中：15个" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.usingLab.x, MaxY(self.usingLab)+10*FITWIDTH, self.usingLab.width, 12*FITWIDTH)];
    self.freeLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.freeLab];
    
//    self.closeLab = [UILabel labelWithText:@"已关闭：8个" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.usingLab.x, MaxY(self.freeLab)+10*FITWIDTH, self.usingLab.width, 12*FITWIDTH)];
//    self.closeLab.font = kBoldFont(12*FITWIDTH);
//    [backView addSubview:self.closeLab];
    
    backView.height = MaxY(self.freeLab)+19*FITWIDTH;
    
    CALayer *shadowLayer = [UIView creatShadowLayer:backView.frame cornerRadius:6 backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:5];
    [self.contentView.layer insertSublayer:shadowLayer below:backView.layer];
}

-(void)setDataModel:(OCCampusClassroomModel *)dataModel{
    _dataModel = dataModel;
    self.titleLab.text = dataModel.buildName;
    
//    [self.img sd_setImageWithURL:[NSURL URLWithString:dataModel.img]];
    self.storeyLab.text = [NSString stringWithFormat:@"共%ld层",dataModel.floor];
    self.usingLab.text = NSStringFormat(@"使用中：%ld个",dataModel.useCount);
    self.freeLab.text = NSStringFormat(@"空闲中：%ld个",dataModel.freeCount);
    
}
@end
