//
//  OCCourseDetailCouserRourseCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseDetailCouserRourseCell.h"
@interface OCCourseDetailCouserRourseCell ()

@property (strong, nonatomic) UIView *backView;

@end

@implementation OCCourseDetailCouserRourseCell

+(instancetype)initWithCourseRourseTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"couserRourseCellID";
    OCCourseDetailCouserRourseCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCCourseDetailCouserRourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = kBACKCOLOR;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setCouseRourseDataArr:(NSArray *)couseRourseDataArr{
    _couseRourseDataArr = couseRourseDataArr;
    
    if (!self.backView) {
        self.backView = [UIView viewWithBgColor:WHITE frame:Rect(20*FITWIDTH, 12*FITWIDTH, kViewW - 40*FITWIDTH, 0)];
        self.backView.layer.cornerRadius = 7;
        [self.contentView addSubview:self.backView];
        for (int i = 0; i<couseRourseDataArr.count; i++) {
            OCCourseWareModel *model = couseRourseDataArr[i];
            NSString *imageStr = @"course_icon_pdf_mini";
            NSString *titleStr = model.name;
            
            UIImageView *image = [UIImageView imageViewWithImage:[UIImage imageNamed:imageStr] frame:Rect(17*FITWIDTH, 24*FITWIDTH + (12*FITWIDTH + 24*FITWIDTH)*i, 24*FITWIDTH, 24*FITWIDTH)];
            
            UILabel *contentLab = [UILabel labelWithText:titleStr font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
            contentLab.x = MaxX(image) + 14*FITWIDTH;
            contentLab.size = CGSizeMake(200*FITWIDTH, 14*FITWIDTH);
            contentLab.centerY = image.centerY;
            
            UIImageView *oparetionImg = [UIImageView imageViewWithImage:[UIImage imageNamed:@"common_btn_download"] frame:CGRectZero];
            oparetionImg.size = CGSizeMake(17*FITWIDTH, 17*FITWIDTH);
            oparetionImg.x = self.backView.width - oparetionImg.width - 16*FITWIDTH;
            oparetionImg.centerY = contentLab.centerY;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = Rect(0, image.y, self.backView.width, image.height);
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:)];
            
            [self.backView addSubview:image];
            [self.backView addSubview:contentLab];
            [self.backView addSubview:oparetionImg];
            [self.backView addSubview:btn];
            
            if (i == self.couseRourseDataArr.count-1) {
                self.backView.height = MaxY(image) + 24*FITWIDTH;
                self.cellH = self.backView.height + 24*FITWIDTH;
            }
            
        }
    } 
}

-(void)btnClick:(UIButton *)button{
    OCCourseWareModel *model = self.couseRourseDataArr[button.tag];
    if ([self.delegate respondsToSelector:@selector(courseWareClickWithWareDict:)]) {
        [self.delegate courseWareClickWithWareDict:model];
    }
}

@end
