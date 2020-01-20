//
//  OCOamGroupLeaderListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOamGroupLeaderListCell.h"

@interface OCOamGroupLeaderListCell ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *scoreLab;
@property (strong, nonatomic) UILabel *orderStatusLab;
@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) CALayer *shadowLayer;
@end

@implementation OCOamGroupLeaderListCell

+(instancetype)initWithOCOamGroupLeaderListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCOamGroupLeaderListCellID";
    OCOamGroupLeaderListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCOamGroupLeaderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    self.backView = [UIView viewWithBgColor:CLEAR frame:Rect(20*FITWIDTH, 0, kViewW - 40*FITWIDTH, 113*FITWIDTH)];
    [self.backView setCornerRadius:4*FITWIDTH];
    [self.contentView addSubview:self.backView];
    
    self.scoreLab = [UILabel labelWithText:@"" font:48*FITWIDTH textColor:WHITE frame:Rect(20*FITWIDTH, 20*FITWIDTH, 150*FITWIDTH, 48*FITWIDTH)];
    self.scoreLab.font = kBoldFont(48*FITWIDTH);
    [self.backView addSubview:self.scoreLab];
    
    self.orderStatusLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(20*FITWIDTH, MaxY(self.scoreLab)+10*FITWIDTH, 66*FITWIDTH, 23*FITWIDTH)];
    self.orderStatusLab.textAlignment = NSTextAlignmentCenter;
    self.orderStatusLab.backgroundColor = WHITE;
    [self.orderStatusLab setCornerRadius:11.5*FITWIDTH];
    [self.backView addSubview:self.orderStatusLab];
    
    self.img = [UIImageView imageViewWithImage:nil frame:Rect(self.backView.width - 10*FITWIDTH - 101*FITWIDTH, self.backView.height-83*FITWIDTH, 101*FITWIDTH, 83*FITWIDTH)];
    [self.backView addSubview:self.img];
    
    self.shadowLayer = [UIView creatShadowLayer:self.backView.frame cornerRadius:4*FITWIDTH backgroundColor:WHITE shadowColor:TEXT_COLOR_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:4*FITWIDTH];
    [self.contentView.layer insertSublayer:self.shadowLayer below:self.backView.layer];
}

-(void)setOamModel:(OCOamManageModel *)oamModel{
    _oamModel = oamModel;
    self.scoreLab.text = oamModel.score;
    if (oamModel.type == 0) {
        self.orderStatusLab.text = @"未处理";
        self.backView.backgroundColor = RGBA(255, 173, 99, 1);
        self.img.image = GetImage(@"yw_icon_wcl");
    }else if (oamModel.type == 1){
        self.orderStatusLab.text = @"处理中";
        self.backView.backgroundColor = kAPPCOLOR;
        self.img.image = GetImage(@"yw_icon_clz");

    }else if (oamModel.type == 2){
        self.orderStatusLab.text = @"已完成";
        self.backView.backgroundColor = RGBA(216, 217, 218, 1);
        self.img.image = GetImage(@"yw_icon_ywc");

    }
    self.shadowLayer.shadowColor = self.backView.backgroundColor.CGColor;

}

@end
