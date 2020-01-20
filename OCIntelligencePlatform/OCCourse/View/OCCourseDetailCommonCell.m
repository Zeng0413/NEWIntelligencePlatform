//
//  OCCourseDetailCommonCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseDetailCommonCell.h"
@interface OCCourseDetailCommonCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation OCCourseDetailCommonCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backView.layer.cornerRadius = 7;
    self.contentView.backgroundColor = kBACKCOLOR;
}

@end
