//
//  LXCalendarWeekView.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarWeekView.h"

@implementation LXCalendarWeekView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
-(void)setWeekTitles:(NSArray *)weekTitles{
    _weekTitles = weekTitles;
    
    CGFloat width = self.width /weekTitles.count;
    for (int i = 0; i< weekTitles.count; i++) {
        UILabel *weekLabel = [UILabel labelWithText:weekTitles[i] font:14 textColor:TEXT_COLOR_GRAY frame:Rect(i * width, 0, width, self.height-1*FITWIDTH)];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.backgroundColor =[UIColor whiteColor];
        [self addSubview:weekLabel];
    }
    
    UIView *lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, self.height-1*FITWIDTH, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self addSubview:lineView];
}
@end
