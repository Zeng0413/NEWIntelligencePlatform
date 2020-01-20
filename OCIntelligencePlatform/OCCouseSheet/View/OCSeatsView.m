//
//  OCSeatsView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCSeatsView.h"
#import "OCSeatAreaModel.h"
@interface OCSeatsView ()

@property (nonatomic,copy) void (^actionBlock)(OCSeatButton *seatBtn,OCSeatsAreaView *seatsAreaView);

@end

@implementation OCSeatsView

-(instancetype)initWithSeatsArray:(NSArray *)seatsArray maxNomarHeight:(CGFloat)maxH seatBtnActionBlock:(void (^)(OCSeatButton * _Nonnull, OCSeatsAreaView * _Nonnull))actionBlock{
    if (self = [super init]) {
        self.actionBlock = actionBlock;

        //初始化座位
        [self initSeatBtns:seatsArray withViewH:maxH];
        
    }
    return self;
}

-(void)initSeatBtns:(NSArray *)seatsArray withViewH:(CGFloat)maxH{
    for (int i = 0; i<seatsArray.count; i++) {
        NSInteger row = i%3;
        NSInteger colunm = i/3;
        
        OCSeatAreaModel *areaModel = seatsArray[i];
        OCSeatsAreaView *seatAreaView = [[OCSeatsAreaView alloc] initWithFrame:CGRectMake(109*FITWIDTH+(54*FITWIDTH+51*FITWIDTH)*row, 20*FITWIDTH + (((maxH - 60*FITWIDTH)/2)+20*FITWIDTH)*colunm, 54*FITWIDTH, (maxH - ((212-114)*FITWIDTH)/2 - 12*FITWIDTH - 10*FITWIDTH)/2)];
        [seatAreaView setupUIWithAreaTag:i withSeatModel:areaModel.seatList];
        seatAreaView.x = (kViewW - 80*FITWIDTH-seatAreaView.width*3)/2 + (seatAreaView.width + 40*FITWIDTH) *row;
        seatAreaView.y = (seatAreaView.height + 12*FITWIDTH) * colunm;
        [seatAreaView setActionBlock:^(OCSeatButton * _Nonnull seatBtn) {
            if (self.actionBlock) {
                self.actionBlock(seatBtn, seatAreaView);
            }
        }];
        [self addSubview:seatAreaView];
    }
    
    
}
@end
