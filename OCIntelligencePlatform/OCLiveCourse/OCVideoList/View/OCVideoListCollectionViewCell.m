//
//  OCVideoListCollectionViewCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCVideoListCollectionViewCell.h"

@interface OCVideoListCollectionViewCell ()

@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *countLab;

@end
@implementation OCVideoListCollectionViewCell

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
    
    self.selectedBtn = [[UIButton alloc] init];
    self.selectedBtn.size = CGSizeMake(13*FITWIDTH, 13*FITWIDTH);
    self.selectedBtn.x = self.selectedBtn.y = -(self.selectedBtn.width/2 - 2*FITWIDTH);
    [self.selectedBtn setBackgroundImage:GetImage(@"course_btn_circle_nor") forState:UIControlStateNormal];
    [self.selectedBtn setBackgroundImage:GetImage(@"course_btn_circle_sel") forState:UIControlStateSelected];
    [self.selectedBtn addTarget:self action:@selector(selectedClick)];
    self.selectedBtn.hidden = YES;
    [self.contentView addSubview:self.selectedBtn];
    
    self.titleLab = [UILabel labelWithText:@"近代中国历史学" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(12*FITWIDTH, MaxY(self.img)+12*FITWIDTH, backView.width-20*FITWIDTH, 15*FITWIDTH)];
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    [backView addSubview:self.titleLab];
    
    self.nameLab = [UILabel labelWithText:@"主讲：张老师" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(12*FITWIDTH, MaxY(self.titleLab)+10*FITWIDTH, backView.width-60*FITWIDTH, 12*FITWIDTH)];
    self.nameLab.font = kBoldFont(12*FITWIDTH);
    [backView addSubview:self.nameLab];
    
    
    self.countLab = [UILabel labelWithText:@"共10讲" font:11*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(backView.width-12*FITWIDTH-60*FITWIDTH, 0, 60*FITWIDTH, 11*FITWIDTH)];
    self.countLab.centerY = self.nameLab.centerY;
    self.countLab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:self.countLab];
    
    backView.height = MaxY(self.nameLab)+24*FITWIDTH;
    
    CALayer *shadowLayer = [UIView creatShadowLayer:backView.frame cornerRadius:6 backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:4];
    [self.contentView.layer insertSublayer:shadowLayer below:backView.layer];
}

-(void)setVideoModel:(OCCourseVideoListModel *)videoModel{
    _videoModel = videoModel;
    if ([videoModel.name isEqualToString:@"口译"]) {
        NSLog(@"%@",videoModel.name);
    }
    
    self.selectedBtn.selected = videoModel.isSelected;
    self.titleLab.text = videoModel.name;
    self.nameLab.text = NSStringFormat(@"主讲：%@",videoModel.speaker.length==0?@"无":videoModel.speaker);
    self.countLab.text = NSStringFormat(@"共%ld讲",videoModel.videoCount);
    [self.img sd_setImageWithURL:[NSURL URLWithString:NSStringFormat(@"%@",videoModel.coverUri)] placeholderImage:GetImage(@"common_img_loading")];
}

-(void)selectedClick{
    if ([self.delegate respondsToSelector:@selector(selectedCell:)]) {
        [self.delegate selectedCell:self];
    }
}
@end
