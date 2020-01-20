//
//  OCOrderSeatCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/11.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCOrderSeatCell.h"
#import "OCInfoMessagePushView.h"

@interface OCOrderSeatCell ()

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UILabel *seatAreaLab;

@property (strong, nonatomic) UIImageView *QRImg;

@property (strong, nonatomic) UILabel *statusLab;

@property (strong, nonatomic) UIButton *seatBtn;

@end

@implementation OCOrderSeatCell

+(instancetype)initWithOCOrderSeatCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCOrderSeatCellID";
    OCOrderSeatCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCOrderSeatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.timeLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, 15*FITWIDTH, 200*FITWIDTH, 14*FITWIDTH)];
    [self.contentView addSubview:self.timeLab];

    
    UITapGestureRecognizer *QRImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QRImgClick)];
    self.QRImg = [UIImageView imageViewWithImage:GetImage(@"mine_btn_qr code") frame:Rect(kViewW - 20*FITWIDTH - 26*FITWIDTH, 20*FITWIDTH, 26*FITWIDTH, 26*FITWIDTH)];
    self.QRImg.hidden = YES;
    self.QRImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.QRImg];
    [self.QRImg addGestureRecognizer:QRImgTap];
    
    self.seatBtn = [UIButton buttonWithTitle:@"取消预约" titleColor:kAPPCOLOR backgroundColor:WHITE font:12*FITWIDTH image:@"" frame:Rect(kViewW - 20*FITWIDTH - 56*FITWIDTH, 21*FITWIDTH, 56*FITWIDTH, 24*FITWIDTH)];
    self.seatBtn.layer.borderColor = RGBA(80, 153, 255, 1).CGColor;
    self.seatBtn.layer.borderWidth = 1.0;
    self.seatBtn.layer.cornerRadius = 7*FITWIDTH;
    [self.seatBtn addTarget:self action:@selector(cancelOrder)];
    [self.contentView addSubview:self.seatBtn];
    
    self.seatAreaLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, MaxY(self.timeLab)+8*FITWIDTH,CGRectGetMinX(self.seatBtn.frame) - 10*FITWIDTH - 20*FITWIDTH, 14*FITWIDTH)];
    [self.contentView addSubview:self.seatAreaLab];
    
    self.statusLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:kAPPCOLOR frame:Rect(kViewW - 20*FITWIDTH - 100*FITWIDTH, 27*FITWIDTH, 100*FITWIDTH, 12*FITWIDTH)];
    self.statusLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.statusLab];
    
    UIView *lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, MaxY(self.seatAreaLab)+12*FITWIDTH, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self.contentView addSubview:lineView];
    
}


-(void)setModel:(OCOrderListModel *)model{
    _model = model;

    if (self.index == 1) {
        self.timeLab.textColor = RGBA(153, 153, 153, 1);
        self.seatAreaLab.textColor = RGBA(153, 153, 153, 1);
    }else{
        self.timeLab.textColor = TEXT_COLOR_BLACK;        
        self.seatAreaLab.textColor = TEXT_COLOR_BLACK;
    }
    
    NSString *endDateToDay = [NSString formateDateToDay:NSStringFormat(@"%ld",(long)model.endTime)];
    NSDate *endD = [NSString dateFromTimeStr:endDateToDay];
    BOOL isToday = endD.isToday;
    BOOL isTorrom = endD.isTorromday;
    BOOL isTorromLast = endD.isTorromdayLast;
    
    NSString *timeStr = @"";
    if (isToday) {
        self.QRImg.hidden = NO;
        self.seatBtn.hidden = YES;
        self.statusLab.hidden = YES;
        timeStr = @"今天";
    }else if (isTorrom){
        timeStr = @"明天";
    }else if (isTorromLast){
        timeStr = @"后天";
    }
    
    model.endTime = model.endTime + 1000;
    NSString *endDate = [NSString formateDateOnlyYueri:NSStringFormat(@"%ld",(long)model.endTime)];
    NSString *startTime = [NSString formateDateOnlyShifen:NSStringFormat(@"%ld",(long)model.starTime)];
    NSString *endTime = [NSString formateDateOnlyShifen:NSStringFormat(@"%ld",(long)model.endTime)];
   
    NSString *orderSeatTime = @"";
    if (timeStr.length>0) {
        orderSeatTime = NSStringFormat(@"%@ %@ %@-%@",timeStr,endDate,startTime,endTime);
    }else{
        orderSeatTime = NSStringFormat(@"%@ %@-%@",endDate,startTime,endTime);
    }
    self.timeLab.text = orderSeatTime;
    
    self.seatAreaLab.text = NSStringFormat(@"%@%@ %@%@座位",model.buildingName,model.roomName,model.seatArea,model.seatName);

    // 1.准时到场 2.迟到 3.缺席 4.已取消
  
    if (model.status == 0) {
        if (isToday) {
            self.QRImg.hidden = NO;
            self.seatBtn.hidden = YES;
            self.statusLab.hidden = YES;
        }else{
            self.QRImg.hidden = YES;
            self.seatBtn.hidden = NO;
            self.statusLab.hidden = YES;
        }
        
    }else{
        self.QRImg.hidden = YES;
        self.seatBtn.hidden = YES;
        self.statusLab.hidden = NO;
        if (model.status == 1) {
            self.statusLab.text = @"准时";
            self.statusLab.textColor = RGBA(153, 153, 153, 1);
        }else if (model.status == 2){
            self.statusLab.text = @"迟到";
            self.statusLab.textColor = RGBA(254, 106, 107, 1);
        }else if (model.status == 3){
            self.statusLab.text = @"缺勤";
            self.statusLab.textColor = RGBA(254, 106, 107, 1);
        }
        else if (model.status == 4){
            self.statusLab.text = @"已取消";
            self.statusLab.textColor = kAPPCOLOR;
        }
    }
}


-(void)QRImgClick{
    CIImage *QRImg = [OCPublicMethodManager getCodeImage:self.model.ID];
    
    OCInfoMessagePushView *infoPushView = [[OCInfoMessagePushView alloc] initWithPushViewFrame:Rect(0, 0, 250*FITWIDTH, 250*FITWIDTH) withImg:[QRImg createNonInterpolatedWithSize:176*FITWIDTH]];
    TYAlertController * tyVC = [TYAlertController alertControllerWithAlertView:infoPushView preferredStyle:TYAlertControllerStyleAlert];
    tyVC.backgoundTapDismissEnable = YES;
    [[OCPublicMethodManager getCurrentVC] presentViewController:tyVC animated:YES completion:nil];
   [infoPushView setCancelBlock:^{
       [tyVC dismissViewControllerAnimated:NO];
   }];
}

-(void)cancelOrder{
    if ([self.delegate respondsToSelector:@selector(cancelOrderSeatWithModel:)]) {
        [self.delegate cancelOrderSeatWithModel:self.model];
    } 
}
@end
