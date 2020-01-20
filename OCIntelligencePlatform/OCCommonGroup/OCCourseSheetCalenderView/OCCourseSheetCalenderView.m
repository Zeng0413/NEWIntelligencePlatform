//
//  OCCourseSheetCalenderView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/12.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSheetCalenderView.h"
#import "WKBoundlessScrollView.h"
#import "WKBoundlessScrollViewCell.h"
#import "TipView.h"
#import "DateTools.h"
#import "CellDateModel.h"
#import "DateView.h"
#import "LXCalendarView.h"
@interface OCCourseSheetCalenderView ()<WKBoundlessScrollViewDelegate>
{
    TipView *_tipView;
    DateView *_lastDateView;
    
}
@property (strong, nonatomic) UIView *backView;
@property(nonatomic,strong)LXCalendarView *calenderView;

@end

@implementation OCCourseSheetCalenderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

//        [self setupUI];
    }
    return self;
}

-(void)setSelectedDateModel:(LXCalendarDayModel *)selectedDateModel{
    _selectedDateModel = selectedDateModel;
    [self setupUI];
}

-(void)setupUI{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelecteDate:) name:@"DID_SELETED_DATEVIEW" object:nil];
    
    UIView *shadowView = [UIView viewWithBgColor:[UIColor blackColor] frame:self.bounds];
    shadowView.alpha = 0.6;
    shadowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewClick)];
    [shadowView addGestureRecognizer:tapGesture];
    [self addSubview:shadowView];
    
//    self.backView = [UIView viewWithBgColor:WHITE frame:Rect(0, 222, kViewW, kViewH - 222)];
//    [self addSubview:self.backView];
    
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, 0, kViewW, 0)];
//    self.calenderView.currentMonthDate = [NSDate dateFromString:NSStringFormat(@"%ld-%ld-%ld",self.selectedDateModel.year,self.selectedDateModel.month,self.selectedDateModel.day)];
    self.calenderView.currentMonthDate = [NSString dateFromTimeStr:NSStringFormat(@"%ld-%ld-%ld",self.selectedDateModel.year,self.selectedDateModel.month,self.selectedDateModel.day)];
    self.calenderView.selectModel = self.selectedDateModel;
    self.calenderView.currentMonthTitleColor = TEXT_COLOR_BLACK;
    
    self.calenderView.isHaveAnimation = YES;
    
    self.calenderView.isCanScroll = YES;
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.todayTitleColor =TEXT_COLOR_BLACK;
    
    self.calenderView.selectBackColor = kAPPCOLOR;
    
    self.calenderView.isShowLastAndNextDate = NO;
    
    [self.calenderView dealData];
    
    self.calenderView.backgroundColor =[UIColor whiteColor];
    
    
    self.calenderView.y = kViewH - self.calenderView.height;
    [self addSubview:self.calenderView];
    
    Weak;
    self.calenderView.selectBlock = ^(LXCalendarDayModel *model) {
        [wself removeFromSuperview];
        if (wself.block) {
            wself.block(model);
        }
    };
    
//    NSArray *titleArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
//    CGFloat titleW = kViewW/titleArr.count;
//    for (int i = 0; i < titleArr.count; i++) {
//        UILabel *titleLab = [UILabel labelWithText:titleArr[i] font:14 textColor:RGBA(153, 153, 153, 1) frame:Rect(i*titleW, 0, titleW, 62)];
//        titleLab.textAlignment = NSTextAlignmentCenter;
//        [self.backView addSubview:titleLab];
//    }
//    UIView *lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20, 62, kViewW-40, 1)];
//    [self.backView addSubview:lineView];
//
//
//    WKBoundlessScrollView *boundlessScrollView = [[WKBoundlessScrollView alloc] initWithFrame:CGRectMake(0, MaxY(lineView), kViewW, self.backView.height - MaxY(lineView))];
//
//    boundlessScrollView.decelerationRate = 1.0;
//    boundlessScrollView.delegateForCell = self;
//    [self.backView addSubview:boundlessScrollView];
}


-(WKBoundlessScrollViewCell *)boundlessScrollViewCellWithDeviation:(NSInteger)deviation boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView
{
    
    static NSString *cellID = @"cellID";
    
    WKBoundlessScrollViewCell *cell = [boundlessScrollView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WKBoundlessScrollViewCell alloc] initWithIdentifier:cellID];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CellDateModel *cellDateModel = [DateTools dateToCell:deviation];
        
        for (DateModel *dateModel in cellDateModel.dateModelArray) {

            if (dateModel.year == self.selectedDateModel.year && dateModel.month == self.selectedDateModel.month && dateModel.day == self.selectedDateModel.day) {
                dateModel.isSelected = YES;
            }else{
                dateModel.isSelected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell fillDate:cellDateModel];
        });
    });
    //    }
    
    return cell;
}

-(void)didSelecteDate:(NSNotification *)notification
{
//    [self removeFromSuperview];
//
//    NSDictionary * dict = notification.userInfo;
//    DateModel *dateModel = dict[@"dateModel"];
//    self.selectedDateModel = dateModel;
//    if (self.block) {
//        self.block(dateModel);
//    }
//    
////    DateView *view = dict[@"selectedDateView"];
////    view.solarCalendarLabel.backgroundColor = kAPPCOLOR;
////    view.solarCalendarLabel.textColor = WHITE;
////    _lastDateView.solarCalendarLabel.backgroundColor = [UIColor clearColor];
////    _lastDateView.solarCalendarLabel.textColor = TEXT_COLOR_BLACK;
////
////    _lastDateView = view;
////    
////    NSLog(@"%@",dateModel);
}

-(CGFloat)boundlessScrollViewCellHeightWithdeviation:(NSInteger)deviation boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView{
    
    NSInteger row = [DateTools getDrawRow:deviation];
    CGFloat width = (kViewW/2)/7.0;
    return (width+15)*row+10+30;
}

-(void)didSelectedWithDeviation:(NSInteger)deviation boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView
{
    NSLog(@"%ld",(long)deviation);
}

-(void)boundlessScrollViewArriveTopVisible:(NSInteger)deviation
{
//    NSDateComponents *components = [DateTools getCellMonthDate:deviation];
//    NSString *string = [NSString stringWithFormat:@"%ld年%ld月",[components year],[components month]];
//    TipView *tipView = [self getTipLabel:string];
//    if (tipView.hidden == YES) {
//        tipView.hidden = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            tipView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.6 animations:^{
//                tipView.alpha = 0.6;
//            } completion:^(BOOL finished) {
//                tipView.hidden = YES;;
//            }];
//        }];
//    }
}

-(TipView *)getTipLabel:(NSString *)string
{
    if (!_tipView) {
        _tipView = [[TipView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50)];
        _tipView.backgroundColor = [UIColor clearColor];
        _tipView.hidden = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        label.tag = 100;
        [_tipView addSubview:label];
        _tipView.alpha = 0.0;
        //        _tipLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tipView];
    }
    UILabel *label = [_tipView viewWithTag:100];
    label.text = string;
    return _tipView;
}

-(void)shadowViewClick{
    [self removeFromSuperview];
}
@end
