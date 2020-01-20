//
//  DateView.m
//  Calendar
//
//  Created by macairwkcao on 15/12/18.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import "DateView.h"
#import "DateModel.h"
@interface DateView()
{
    UIView *_backgroundView;
}
@end
@implementation DateView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _solarCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _solarCalendarLabel.centerX = self.width/2;
        _solarCalendarLabel.centerY = self.height/2;
        _solarCalendarLabel.layer.masksToBounds = YES;
        _solarCalendarLabel.textColor = TEXT_COLOR_BLACK;
        _solarCalendarLabel.font = kFont(14);
        _solarCalendarLabel.layer.cornerRadius = _solarCalendarLabel.height/2;
        
        _lunarCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width*0.45, width, width*0.3)];
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.layer.cornerRadius = width/2.0;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
        [self addSubview:_solarCalendarLabel];
//        [self addSubview:_lunarCalendarLabel];
//        self.layer.cornerRadius = width/2.0;
//        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.923 alpha:1.000];

}


-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _backgroundView.backgroundColor = [UIColor clearColor];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _backgroundView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DID_SELETED_DATEVIEW" object:nil userInfo:@{@"dateModel":self.dateModel, @"selectedDateView":self}];
}


-(void)fillDate:(DateModel *)dateModel
{
    _dateModel = dateModel;
    self.solarCalendarLabel.text = [NSString stringWithFormat:@"%ld",dateModel.day];
    self.lunarCalendarLabel.text = dateModel.lunarDay;
    
    if (dateModel.isSelected) {
        self.solarCalendarLabel.backgroundColor = kAPPCOLOR;
        self.solarCalendarLabel.textColor = WHITE;
    }else{
        self.solarCalendarLabel.backgroundColor = [UIColor clearColor];
        self.solarCalendarLabel.textColor = TEXT_COLOR_BLACK;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.solarCalendarLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lunarCalendarLabel.font = [UIFont systemFontOfSize:9.0];
    self.lunarCalendarLabel.textAlignment = NSTextAlignmentCenter;
}



@end
