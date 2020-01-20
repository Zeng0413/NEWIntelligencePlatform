//
//  OCCourseReportNoDataCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseReportNoDataCell.h"

@interface OCCourseReportNoDataCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation OCCourseReportNoDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backView.layer.cornerRadius = 7;
    self.contentView.backgroundColor = kBACKCOLOR;
    // Initialization code
}


@end
