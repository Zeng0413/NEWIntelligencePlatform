//
//  OCPersonDiskCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPersonDiskCell.h"

@interface OCPersonDiskCell ()

@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UIImageView *selectImg;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation OCPersonDiskCell

+(instancetype)initWithOCPersonDiskCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCPersonDiskCellID";
    OCPersonDiskCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCPersonDiskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    self.img = [UIImageView imageViewWithImage:GetImage(@"") frame:Rect(21*FITWIDTH, 12*FITWIDTH, 22*FITWIDTH, 24*FITWIDTH)];
    [self.contentView addSubview:self.img];
    
    self.nameLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.nameLab.x = MaxX(self.img) + 15*FITWIDTH;
    self.nameLab.size = CGSizeMake(kViewW-self.nameLab.x-40*FITWIDTH-13*FITWIDTH-10*FITWIDTH, 16*FITWIDTH);
    self.nameLab.centerY = self.img.centerY;
    [self.contentView addSubview:self.nameLab];
    
    self.selectImg = [UIImageView imageViewWithImage:GetImage(@"course_btn_circle_nor") frame:CGRectZero];
    self.selectImg.size = CGSizeMake(13*FITWIDTH, 13*FITWIDTH);
    self.selectImg.x = kViewW - 20*FITWIDTH - self.selectImg.width;
    self.selectImg.centerY = self.nameLab.centerY;
    [self.contentView addSubview:self.selectImg];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.size = CGSizeMake(40*FITWIDTH+13*FITWIDTH, 49*FITWIDTH);
    selectedBtn.x = kViewW - selectedBtn.width;
    selectedBtn.centerY = self.nameLab.centerY;
    [selectedBtn addTarget:self action:@selector(opreateClick)];
    selectedBtn.backgroundColor = CLEAR;
    [self.contentView addSubview:selectedBtn];
    
    self.lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, MaxY(self.img)+13*FITWIDTH, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self.contentView addSubview:self.lineView];
    
    self.cellH = MaxY(self.lineView);
}

-(void)setDiskModel:(OCDPersonDiskModel *)diskModel{
    _diskModel = diskModel;
    [self.img sd_setImageWithURL:[NSURL URLWithString:diskModel.coverImg]];
    self.nameLab.text = diskModel.name;
    if (diskModel.isSelected) {
        self.selectImg.image = GetImage(@"course_btn_circle_sel");
    }else{
        self.selectImg.image = GetImage(@"course_btn_circle_nor");
    }
}

-(void)opreateClick{
    if ([self.delegate respondsToSelector:@selector(selectedWithCell:)]) {
        [self.delegate selectedWithCell:self];
    }
}

@end
