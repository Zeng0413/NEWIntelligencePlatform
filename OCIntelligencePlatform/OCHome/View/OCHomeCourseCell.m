//
//  OCHomeCourseCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCHomeCourseCell.h"

@interface OCHomeCourseCell ()
@property (strong, nonatomic) UIImageView *courseImg;
@property (strong, nonatomic) UILabel *courseTitleLab;
@property (strong, nonatomic) UILabel *courseCount;

@end

@implementation OCHomeCourseCell

+(instancetype)initWithHomeCourseTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"homeCourseCellID";
    OCHomeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCHomeCourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(20*FITWIDTH, 12*FITWIDTH, kViewW - 40*FITWIDTH, 174*FITWIDTH)];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 6;
        [self.contentView addSubview:backView];
        
        self.courseImg = [UIImageView imageViewWithUrl:nil placeHolder:nil frame:Rect(0, 0, backView.width, 126*FITWIDTH)];
        self.courseImg.contentMode = UIViewContentModeScaleAspectFill;
        self.courseImg.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:self.courseImg];
        
        self.courseTitleLab = [UILabel labelWithText:@"电磁场与电磁波" font:16*FITWIDTH textColor:RGBA(51, 51, 51, 1) frame:Rect(16*FITWIDTH,MaxY(self.courseImg) + 16*FITWIDTH, 140*FITWIDTH, 16*FITWIDTH)];
        self.courseTitleLab.font = [UIFont boldSystemFontOfSize:16*FITWIDTH];
        [backView addSubview:self.courseTitleLab];
        
        self.courseCount = [UILabel labelWithText:@"共10讲" font:12*FITWIDTH textColor:RGBA(153, 153, 153, 1) frame:Rect(backView.width - 16*FITWIDTH - 100*FITWIDTH, 0, 100*FITWIDTH, 12*FITWIDTH)];
        self.courseCount.centerY = self.courseTitleLab.centerY;
        self.courseCount.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.courseCount];
        
        CALayer *shadowLayer = [UIView creatShadowLayer:backView.frame cornerRadius:6 backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:5];
        [self.contentView.layer insertSublayer:shadowLayer below:backView.layer];
    }
    return self;
}

-(void)setDataModel:(OCCourseListModel *)dataModel{
    _dataModel = dataModel;
    [self.courseImg sd_setImageWithURL:[NSURL URLWithString:dataModel.courseImg] placeholderImage:GetImage(@"common_img_none")];
    self.courseTitleLab.text = dataModel.courseName;
    self.courseCount.text = [NSString stringWithFormat:@"共%ld讲",dataModel.lessonCount];
}

@end
