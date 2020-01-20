//
//  OCClassroomBuildCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/10.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCClassroomBuildCell.h"

@interface OCClassroomBuildCell ()
{
    UIView *contentBackView;
}
@property (strong, nonatomic) UILabel *classroomName;
@property (strong, nonatomic) UILabel *seatCount;
@property (strong, nonatomic) UIView *rateLineView;
@end

@implementation OCClassroomBuildCell

+(instancetype)initWithClassroomBulidTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCClassroomBuildCellID";
    OCClassroomBuildCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCClassroomBuildCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kBACKCOLOR;
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    contentBackView = [UIView viewWithBgColor:RGBA(237, 237, 237, 1) frame:Rect(20*FITWIDTH, 15*FITWIDTH, kViewW-40*FITWIDTH, 74*FITWIDTH)];
    [contentBackView setCornerRadius:7*FITWIDTH];
    [self.contentView addSubview:contentBackView];
    
    UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, contentBackView.width, 70*FITWIDTH)];
    [contentBackView addSubview:backView];
    
    self.classroomName = [UILabel labelWithText:@"逸夫楼202" font:18*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(15*FITWIDTH, 28*FITWIDTH, 150*FITWIDTH, 18*FITWIDTH)];
    self.classroomName.font = kBoldFont(18*FITWIDTH);
    [backView addSubview:self.classroomName];
    
    self.seatCount = [UILabel labelWithText:@"剩余座位：43" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(contentBackView.width - 10*FITWIDTH - 150*FITWIDTH, 0, 150*FITWIDTH, 14*FITWIDTH)];
    self.seatCount.centerY = self.classroomName.centerY;
    self.seatCount.textAlignment = NSTextAlignmentRight;
    [backView addSubview:self.seatCount];
    
    self.rateLineView = [UIView viewWithBgColor:RGBA(39, 185, 140, 1) frame:Rect(0, 70*FITWIDTH, 61*FITWIDTH, 4*FITWIDTH)];
    [contentBackView addSubview:self.rateLineView];
}

-(void)setBuildModel:(OCClassroomBuildModel *)buildModel{
    self.classroomName.text = NSStringFormat(@"%@%@",buildModel.buildingName,buildModel.roomName);
    self.classroomName.size = [self.classroomName.text sizeWithFont:kBoldFont(18*FITWIDTH)];
    self.seatCount.text = NSStringFormat(@"剩余座位：%ld",buildModel.seatCount - buildModel.unavailableCount);
    
    CGFloat seatAve = ((CGFloat)buildModel.unavailableCount/(CGFloat)buildModel.seatCount);
    self.rateLineView.width = contentBackView.width*seatAve;
    
    seatAve = seatAve * 100;
    UIColor *lineColor = WHITE;
    if (seatAve == 0) {
        self.rateLineView.width = contentBackView.width;
    }
    else if (seatAve>0 && seatAve<=33) {
        lineColor = RGBA(39, 185, 140, 1);
    }else if (seatAve>33 && seatAve<=66){
        lineColor = RGBA(255, 213, 62, 1);
    }else if (seatAve>66 && seatAve<=100){
        lineColor = RGBA(254, 106, 107, 1);
    }
    self.rateLineView.backgroundColor = lineColor;
    
}

@end
