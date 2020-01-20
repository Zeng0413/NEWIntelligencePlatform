//
//  OCClassroomHeadView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassroomHeadView.h"

@implementation OCClassroomHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kBACKCOLOR;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    
    self.headeLab = [UILabel labelWithText:nil font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, 12*FITWIDTH, kViewW-20*FITWIDTH, 15*FITWIDTH)];
    self.headeLab.font = kBoldFont(15*FITWIDTH);
    [self addSubview:self.headeLab];
}
@end
