//
//  OCTomorrowLiveListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTomorrowLiveListCell.h"

@interface OCTomorrowLiveListCell ()

@property (weak, nonatomic) UILabel *titleLab;
@property (weak, nonatomic) UILabel *nameLab;
@property (weak, nonatomic) UILabel *timeLab;

@property (weak, nonatomic) UIButton *lookBtn;
@property (weak, nonatomic) UIButton *downloadBtn;
@end

@implementation OCTomorrowLiveListCell

+(instancetype)initWithTomorrowLiveListTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentitider = @"OCTomorrowLiveListCellID";
    OCTomorrowLiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentitider];
    if (!cell) {
        cell = [[OCTomorrowLiveListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentitider];
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
    UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(20*FITWIDTH, 15*FITWIDTH, kViewW-40*FITWIDTH, 0)];
    backView.layer.cornerRadius = 4*FITWIDTH;
    [self.contentView addSubview:backView];
    
    UILabel *titleLab = [UILabel labelWithText:@"" font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(12*FITWIDTH, 15*FITWIDTH, kViewW-20*FITWIDTH, 15*FITWIDTH)];
    titleLab.font = kBoldFont(15*FITWIDTH);
    [backView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *nameLab = [UILabel labelWithText:@"" font:13*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(titleLab.x, MaxY(self.titleLab)+10*FITWIDTH, kViewW-20*FITWIDTH, 13*FITWIDTH)];
    nameLab.font = kBoldFont(13*FITWIDTH);
    [backView addSubview:nameLab];
    self.nameLab = nameLab;
    
    UILabel *timeLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(titleLab.x, MaxY(self.nameLab)+10*FITWIDTH, kViewW-20*FITWIDTH, 12*FITWIDTH)];
    [backView addSubview:timeLab];
    self.timeLab = timeLab;
    
//    UIButton *downloadBtn = [UIButton buttonWithTitle:@"下载课件" titleColor:kAPPCOLOR backgroundColor:WHITE font:12*FITWIDTH image:nil target:self action:@selector(downloadClick) frame:Rect(kViewW-88*FITWIDTH-20*FITWIDTH, MaxY(self.timeLab)+15*FITWIDTH, 88*FITWIDTH, 28*FITWIDTH)];
//    downloadBtn.x = backView.width/2+5*FITWIDTH;
//    downloadBtn.layer.masksToBounds = YES;
//    downloadBtn.layer.cornerRadius = 14*FITWIDTH;
//    downloadBtn.layer.borderColor = kAPPCOLOR.CGColor;
//    downloadBtn.layer.borderWidth = 1*FITWIDTH;
//    [backView addSubview:downloadBtn];
//    self.downloadBtn = downloadBtn;
    
    UIButton *lookBtn = [UIButton buttonWithTitle:@"想看" titleColor:WHITE backgroundColor:kAPPCOLOR font:12*FITWIDTH image:nil target:self action:@selector(lookClick) frame:CGRectZero];
    lookBtn.size = CGSizeMake(148*FITWIDTH, 28*FITWIDTH);
    lookBtn.y = MaxY(self.timeLab)+20*FITWIDTH;
    lookBtn.centerX = backView.width/2;
    lookBtn.layer.masksToBounds = YES;
    lookBtn.layer.cornerRadius = 14*FITWIDTH;
    [backView addSubview:lookBtn];
    self.lookBtn = lookBtn;
    
    backView.height = MaxY(lookBtn)+24*FITWIDTH;
    
    CALayer *shadowLayer = [UIView creatShadowLayer:backView.frame cornerRadius:4*FITWIDTH backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:4*FITWIDTH];
    [self.contentView.layer insertSublayer:shadowLayer below:backView.layer];
    
    self.cellH = MaxY(backView);
}

-(void)setDataModel:(OCLiveVideoModel *)dataModel{
    _dataModel = dataModel;
    self.titleLab.text = dataModel.title;
    self.nameLab.text = NSStringFormat(@"主讲：%@",dataModel.speaker);
    self.timeLab.text = NSStringFormat(@"直播时间：%@",dataModel.startTimeTip);
    
    if (dataModel.wannaSee == 0) {
        [self.lookBtn setTitle:@"想看" forState:UIControlStateNormal];
    }else{
        [self.lookBtn setTitle:@"取消想看" forState:UIControlStateNormal];
    }
}

-(void)downloadClick{
    
}

-(void)lookClick{
    if ([self.delegate respondsToSelector:@selector(likeLookWithModel:)]) {
        [self.delegate likeLookWithModel:self.dataModel];
    }
}
@end
