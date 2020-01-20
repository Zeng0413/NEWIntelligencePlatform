//
//  OCMyListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCMyListCell.h"

@interface OCMyListCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;

@end


@implementation OCMyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconH.constant = 26*FITWIDTH;
    self.iconW.constant = 26*FITWIDTH;
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    self.titleLab.textColor = TEXT_COLOR_GRAY;
    self.descLab.font = kFont(12*FITWIDTH);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
