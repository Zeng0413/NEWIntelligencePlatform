//
//  OCOamNorListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCOamNorListCell.h"
@interface OCOamNorListCell ()

@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *addressLab;
@property (strong, nonatomic) UILabel *assetsLab;
@property (strong, nonatomic) UIView *lineView;


@end

@implementation OCOamNorListCell

+(instancetype)initWithOCOamNorListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCOamNorListCellID";
    OCOamNorListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCOamNorListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    self.timeLab = [UILabel labelWithText:@"" font:10*FITWIDTH textColor:WHITE frame:Rect(20*FITWIDTH, 15*FITWIDTH, 124*FITWIDTH, 16*FITWIDTH)];
    self.timeLab.backgroundColor = kAPPCOLOR;
    [self.timeLab setCornerRadius:2*FITWIDTH];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLab];
    
    self.titleLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, MaxY(self.timeLab)+10*FITWIDTH, kViewW - 40*FITWIDTH, 14*FITWIDTH)];
    self.titleLab.font = kBoldFont(14*FITWIDTH);
    [self.contentView addSubview:self.titleLab];
    
    self.addressLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(20*FITWIDTH, MaxY(self.titleLab)+10*FITWIDTH, self.titleLab.width, 12*FITWIDTH)];
    [self.contentView addSubview:self.addressLab];
    
    self.assetsLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(20*FITWIDTH, MaxY(self.addressLab)+10*FITWIDTH, self.titleLab.width, 12*FITWIDTH)];
    [self.contentView addSubview:self.assetsLab];
    
    self.lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, MaxY(self.assetsLab)+15*FITWIDTH, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self.contentView addSubview:self.lineView];
    self.cellH = MaxY(self.lineView);
}


-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    NSString *timeStr = dataDict[@"time"];
//    CGFloat timeW = [timeStr sizeWithFont:self.timeLab.font].width+16*FITWIDTH;
//    self.timeLab.width = timeW;
    self.timeLab.text = timeStr;
    self.titleLab.text = dataDict[@"titleName"];
    self.addressLab.text = dataDict[@"address"];
    self.assetsLab.text = dataDict[@"assets"];
    
}
@end
