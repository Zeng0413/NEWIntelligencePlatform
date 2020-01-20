//
//  OCSeatsAreaView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCSeatsAreaView.h"
#import "AppDelegate.h"

@interface OCSeatsAreaView ()

@end

@implementation OCSeatsAreaView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)setupUIWithAreaTag:(NSInteger)areaTag withSeatModel:(NSArray *)seatsArr{
    CGFloat btnWH = (self.height - 12*FITWIDTH - 6*FITWIDTH - 9*3*FITWIDTH)/10;
    NSArray *areaArr = @[@"A区",@"B区",@"C区",@"D区",@"E区",@"F区"];
    static NSInteger seatIndex = 0;
        for (int i = 0; i < seatsArr.count; i++) {
            OCSeatsModel *seatModel = seatsArr[i];
            
            seatIndex++;
            self.width = btnWH*2 + (6+0.4)*FITWIDTH;
            
            OCSeatButton *seatView = [[OCSeatButton alloc] init];
            seatView.backgroundColor = [UIColor whiteColor];
            seatView.width = btnWH;
            seatView.height = btnWH;
            [seatView setBackgroundColor:WHITE];
            seatView.layer.borderWidth = 0.5;
            seatView.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
            seatView.layer.cornerRadius = 4;
//            [seatView setImage:[UIImage imageNamed:@"mine_icon_white_mini"] forState:UIControlStateNormal];//这里更改座位图标
//            [seatView setImage:[UIImage imageNamed:@"mine_icon_green"] forState:UIControlStateSelected];
            
//            if (i == 5 || i == 9 || i == 16) {
//                seatModel.status = 1;
//            }
            if (seatModel.status == 1 || seatModel.status == 2) {
                seatView.layer.borderColor = CLEAR.CGColor;
                [seatView setBackgroundColor:kAPPCOLOR];
                seatView.userInteractionEnabled = NO;
            }
            
            NSInteger colunm = i/2;
            NSInteger row = i%2;
            seatView.x = (seatView.width+6*FITWIDTH)*row;
            seatView.y = (seatView.height + 3*FITWIDTH)*colunm;
            seatView.tag = i;
            seatView.seatModel = seatsArr[i];
            
            if (i == 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(seatView.frame)+3*FITWIDTH, 0, 0.4*FITWIDTH, self.height-18*FITWIDTH)];
                lineView.backgroundColor = RGBA(216, 216, 216, 1);
                [self addSubview:lineView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(lineView)+8*FITWIDTH, self.width, 12*FITWIDTH)];
                label.font = [UIFont systemFontOfSize:12*FITWIDTH];
                label.textColor = TEXT_COLOR_GRAY;
                label.text = areaArr[areaTag];
                label.textAlignment = NSTextAlignmentCenter;
                [self addSubview:label];
            }
            [seatView addTarget:self action:@selector(seatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:seatView];
            
        }
}


-(void)seatBtnAction:(OCSeatButton *)seatbtn{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    OCSeatButton *lastBtn = appDelegate.lastSeatBtn;
    if (lastBtn == seatbtn) {
        seatbtn.selected = NO;
        appDelegate.lastSeatBtn = [[OCSeatButton alloc] init];
    }else{
        lastBtn.selected = NO;
        seatbtn.selected = YES;
        appDelegate.lastSeatBtn = seatbtn;
    }

    if (seatbtn.selected) {
        seatbtn.layer.borderColor = CLEAR.CGColor;
        [seatbtn setBackgroundColor:RGBA(39, 185, 140, 1)];
    }else{
        seatbtn.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
        [seatbtn setBackgroundColor:WHITE];
    }
    
    if (lastBtn.selected) {
        lastBtn.layer.borderColor = CLEAR.CGColor;
        [lastBtn setBackgroundColor:RGBA(39, 185, 140, 1)];
    }else{
        lastBtn.layer.borderColor = RGBA(213, 213, 213, 1).CGColor;
        [lastBtn setBackgroundColor:WHITE];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.actionBlock) self.actionBlock(seatbtn);
    });
}

@end
