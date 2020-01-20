//
//  OCOrderSeatViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCOrderSeatViewController.h"
#import "OCSeatButton.h"
#import "OCSeatSelectionView.h"
#import "OCSeatAreaModel.h"
#import "OCInfoMessagePushView.h"
@interface OCOrderSeatViewController ()
{
    UIView *seatStatusView;
    OCSeatSelectionView *selectView;
}
@property (strong, nonatomic) UIView *chooseSeatView;

@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) NSMutableArray *selectedBtnArr;

@property (strong, nonatomic) NSArray *seatsArr;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *confirmBtn;

@property (strong, nonatomic) UILabel *seatAreaLab;

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) OCSeatsModel *SelseatModel;

@property (copy, nonatomic) NSString *timeSectionStr;

@property (strong, nonatomic) NSArray *timeSectionArr;

@end

@implementation OCOrderSeatViewController

-(NSMutableArray *)selectedBtnArr{
    if (!_selectedBtnArr) {
        _selectedBtnArr = [NSMutableArray array];
    }
    return _selectedBtnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(241, 245, 249, 1);
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:NSStringFormat(@"%@%@",self.classroomModel.buildingName,self.classroomModel.roomName) backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.timeSectionArr = @[@"8:00-10:00", @"10:00-12:00", @"13:00-15:00", @"15:00-17:00", @"18:00-20:00", @"20:00-22:00"];
    
    [self setupTopSectionView];
    [self setBottomView];
    
    [self requestSeatsData];
    
    
   
}

#pragma mark - view figure
-(void)setBottomView{
    self.bottomView = [UIView viewWithBgColor:WHITE frame:Rect(0, kViewH - 56*FITWIDTH, kViewW, 56*FITWIDTH)];
    [self.view addSubview:self.bottomView];
    self.bottomView.layer.mask = [self setArcView];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.size = CGSizeMake(kViewW - 40*FITWIDTH, 40*FITWIDTH);
    self.confirmBtn.x = 20*FITWIDTH;
    self.confirmBtn.y = self.bottomView.height - 8*FITWIDTH - self.confirmBtn.height;
    self.confirmBtn.title = @"确认预约";
    self.confirmBtn.titleColor = WHITE;
    self.confirmBtn.titleFont = 16*FITWIDTH;
    self.confirmBtn.layer.cornerRadius = self.confirmBtn.height/2;
    [self.confirmBtn setBackgroundColor:kAPPCOLOR];
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.alpha = 0.6;
    [self.confirmBtn addTarget:self action:@selector(confirmClick)];
    [self.bottomView addSubview:self.confirmBtn];
    
    self.seatAreaLab = [UILabel labelWithText:@"" font:16*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.seatAreaLab.font = kBoldFont(16*FITWIDTH);
    [self.bottomView addSubview:self.seatAreaLab];
    
    self.timeLab = [UILabel labelWithText:@"今天 12月25日15:00 - 17:00" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    [self.bottomView addSubview:self.timeLab];

}

-(void)refreshBottomView:(BOOL)isSelected{
    if (isSelected) {
        self.bottomView.frame = Rect(0, kViewH - 114*FITWIDTH, kViewW, 114*FITWIDTH);
        self.bottomView.layer.mask = [self setArcView];
        self.confirmBtn.y = self.bottomView.height - 8*FITWIDTH - self.confirmBtn.height;

        self.seatAreaLab.frame = Rect(20*FITWIDTH, 15*FITWIDTH, 150*FITWIDTH, 16*FITWIDTH);
        self.timeLab.frame = Rect(self.seatAreaLab.x, MaxY(self.seatAreaLab)+8*FITWIDTH, 200*FITWIDTH, 12*FITWIDTH);
        
        NSString *monthStr = [self.dateStr componentsSeparatedByString:@"-"][1];
        NSString *dayStr = [self.dateStr componentsSeparatedByString:@"-"][2];
        NSString *timeStr = NSStringFormat(@"%@ %@月%@日%@",self.weekStr,monthStr,dayStr,self.timeSectionStr);
        self.timeLab.text = timeStr;
        self.timeLab.attributedText = [NSString attrStrFrom:timeStr pointStr:self.weekStr color:RGBA(254, 106, 107, 1) font:kFont(12*FITWIDTH)];
        self.seatAreaLab.text = NSStringFormat(@"%@ %@",self.SelseatModel.area, self.SelseatModel.name);
    }else{
        self.bottomView.frame = Rect(0, kViewH - 56*FITWIDTH, kViewW, 56*FITWIDTH);
        self.bottomView.layer.mask = [self setArcView];
        self.confirmBtn.y = self.bottomView.height - 8*FITWIDTH - self.confirmBtn.height;

        self.seatAreaLab.frame = CGRectZero;
        self.timeLab.frame = CGRectZero;
        self.seatAreaLab.text = NSStringFormat(@"%@ %@",self.SelseatModel.area, self.SelseatModel.name);
    }
    
}

-(void)setupTopSectionView{
    NSArray *titleArr = @[@"一大节",@"二大节",@"三大节",@"四大节",@"五大节",@"六大节"];
    
    UIView *sectionBackView = [UIView viewWithBgColor:WHITE frame:Rect(0, kNavH, kViewW, 12*FITWIDTH + 21*FITWIDTH + 12*FITWIDTH)];
   
    [self.view addSubview:sectionBackView];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sectionBtn.size = CGSizeMake((kViewW - 28*FITWIDTH*2 - (7*FITWIDTH*(titleArr.count-1)))/titleArr.count, 21*FITWIDTH);
        sectionBtn.x = 20*FITWIDTH + (sectionBtn.width + 9*FITWIDTH)*i;
        sectionBtn.y = 12*FITWIDTH;
        sectionBtn.title = titleArr[i];
        sectionBtn.tag = i+1;
        [sectionBtn setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
        sectionBtn.layer.cornerRadius = 4*FITWIDTH;
        sectionBtn.titleFont = 13*FITWIDTH;
        sectionBtn.layer.borderColor = RGBA(112, 112, 112, 1).CGColor;
        sectionBtn.layer.borderWidth = 0.5;
        [sectionBtn addTarget:self action:@selector(sectionClick:)];
        [sectionBackView addSubview:sectionBtn];
        
        if (self.selIndex1 == i+1 || self.selIndex2 == i+1) {
            [self.selectedBtnArr addObject:sectionBtn];
            sectionBtn.selected = YES;
            sectionBtn.backgroundColor = RGBA(184, 205, 255, 1);
            [sectionBtn setTitleColor:WHITE];
            sectionBtn.layer.borderColor = CLEAR.CGColor;
        }
    }
    
    [self getTimeSectionStr];
    
    seatStatusView = [UIView viewWithBgColor:RGBA(241, 245, 249, 1) frame:Rect(0, MaxY(sectionBackView), kViewW, 46*FITWIDTH)];
    UIButton *canSelBtn = [UIButton buttonWithTitle:@"可选" titleColor:TEXT_COLOR_BLACK backgroundColor:CLEAR font:10*FITWIDTH image:@"mine_icon_white_mini" frame:Rect(kViewW/2 - 17*FITWIDTH - 44*FITWIDTH, 12*FITWIDTH, 44*FITWIDTH, 16*FITWIDTH)];
    [canSelBtn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageLeft imageTitleSpacing:8*FITWIDTH];
    [seatStatusView addSubview:canSelBtn];
    
    UIButton *seledBtn = [UIButton buttonWithTitle:@"已选" titleColor:TEXT_COLOR_BLACK backgroundColor:CLEAR font:10*FITWIDTH image:@"mine_icon_blue_mini" frame:Rect(kViewW/2 + 17*FITWIDTH, 12*FITWIDTH, 44*FITWIDTH, 16*FITWIDTH)];
    [seledBtn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageLeft imageTitleSpacing:8*FITWIDTH];
    [seatStatusView addSubview:seledBtn];

    [self.view addSubview:seatStatusView];
}

-(CAShapeLayer *)setArcView{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20,20)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

-(void)setSeatSelectView:(NSArray *)seatArr{
    [selectView removeFromSuperview];
    
    Weak;
    selectView = [[OCSeatSelectionView alloc] initWithFrame:Rect(0, MaxY(seatStatusView), kViewW, kViewH - MaxY(seatStatusView) - 114*FITWIDTH) seatsArray:seatArr seatBtnActionBlock:^(OCSeatButton * _Nonnull seatBtn) {
        wself.confirmBtn.userInteractionEnabled = seatBtn.selected;
        wself.confirmBtn.alpha = seatBtn.selected?1.0:0.5;
        
        wself.SelseatModel = seatBtn.seatModel;
        [wself refreshBottomView:seatBtn.selected];
    }];
    [self.view addSubview:selectView];
}

#pragma mark - 网络请求
-(void)requestSeatsData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = @(1);
    params[@"date"] = self.dateStr;
    params[@"pageSize"] = @(20);
    params[@"roomId"] = self.classroomModel.ID;
    
    NSString *sectionStr = @"";
    if (self.selectedBtnArr.count==1) {
        UIButton *btn = [self.selectedBtnArr firstObject];
        sectionStr = NSStringFormat(@"%ld",btn.tag);
    }else if(self.selectedBtnArr.count==2){
        UIButton *btn1 = [self.selectedBtnArr firstObject];
        UIButton *btn2 = [self.selectedBtnArr lastObject];
        if (btn1.tag>btn2.tag) {
            sectionStr = NSStringFormat(@"%ld",btn2.tag);
            sectionStr = [sectionStr stringByAppendingString:NSStringFormat(@",%ld",btn1.tag)];
        }else{
            sectionStr = NSStringFormat(@"%ld",btn1.tag);
            sectionStr = [sectionStr stringByAppendingString:NSStringFormat(@",%ld",btn2.tag)];
        }

    }
    params[@"session"] = sectionStr;

    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/reservation/seat/list",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        wself.seatsArr = [OCSeatAreaModel objectArrayWithKeyValuesArray:responseObject];
        wself.confirmBtn.userInteractionEnabled = NO;
        wself.confirmBtn.alpha = 0.5;
        [wself setSeatSelectView:wself.seatsArr];
        [wself refreshBottomView:NO];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

#pragma mark - action method

-(void)confirmClick{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"date"] = self.dateStr;
    params[@"roomId"] = self.classroomModel.ID;
    params[@"seatId"] = self.SelseatModel.ID;
    
    NSString *sectionStr = @"";
    if (self.selectedBtnArr.count==1) {
        UIButton *btn = [self.selectedBtnArr firstObject];
        sectionStr = NSStringFormat(@"%ld",btn.tag);
    }else if(self.selectedBtnArr.count==2){
        UIButton *btn1 = [self.selectedBtnArr firstObject];
        UIButton *btn2 = [self.selectedBtnArr lastObject];
        if (btn1.tag>btn2.tag) {
            sectionStr = NSStringFormat(@"%ld",btn2.tag);
            sectionStr = [sectionStr stringByAppendingString:NSStringFormat(@",%ld",btn1.tag)];
        }else{
            sectionStr = NSStringFormat(@"%ld",btn1.tag);
            sectionStr = [sectionStr stringByAppendingString:NSStringFormat(@",%ld",btn2.tag)];
        }
        
    }
    params[@"session"] = sectionStr;
    
    
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/reservation/seat/commit",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        
        OCInfoMessagePushView *infoPushView = [[OCInfoMessagePushView alloc]initWithPushViewFrame:Rect(0, 0, kViewW - 67*2*FITWIDTH, 0) withAllStr:NSStringFormat(@"恭喜你成功预约%@时段%@座位，在我的页面中，打开座位二维码，扫码打开闸机进入自习室。\n\n注意：迟到半小时以上不可进入自习室，当月累计迟到三次则暂停预约功能一周，已预约的座位会自动取消。请同学们自觉遵守时间哦！",self.timeLab.text,self.seatAreaLab.text) withPointStr:self.timeLab.text withPointStrColor:RGBA(254, 106, 107, 1) withBtnCount:1 withBtn1Str:@"我知道了" withBtn2Str:@""];
        TYAlertController * tyVC = [TYAlertController alertControllerWithAlertView:infoPushView preferredStyle:TYAlertControllerStyleAlert];
        tyVC.backgoundTapDismissEnable = YES;
        [self presentViewController:tyVC animated:YES completion:nil];
        [infoPushView setCancelBlock:^{
            [tyVC dismissViewControllerAnimated:NO];
        }];
        [infoPushView setBtnBlock:^(NSInteger type) {
            if (type == 1) {
                [wself.navigationController popViewControllerAnimated:YES];
            }
            [tyVC dismissViewControllerAnimated:NO];

        }];
        
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)sectionClick:(UIButton *)button{
    if (!button.selected) {
        if (self.selectedBtnArr.count<2) {
            if (self.selectedBtnArr.count>0) {
                UIButton *tempBtn = [self.selectedBtnArr firstObject];
                if (tempBtn.tag-1 == button.tag || tempBtn.tag+1 == button.tag) {
                    button.backgroundColor = RGBA(184, 205, 255, 1);
                    [button setTitleColor:WHITE];
                    button.layer.borderColor = CLEAR.CGColor;
                    [self.selectedBtnArr addObject:button];
                    button.selected = !button.selected;
                }else{
                    [tempBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
                    tempBtn.backgroundColor = WHITE;
                    tempBtn.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
                    tempBtn.selected = NO;
                    [self.selectedBtnArr removeObject:tempBtn];
                    
                    button.backgroundColor = RGBA(184, 205, 255, 1);
                    [button setTitleColor:WHITE];
                    button.layer.borderColor = CLEAR.CGColor;
                    [self.selectedBtnArr addObject:button];
                    button.selected = !button.selected;
                }
            }else{
                button.backgroundColor = RGBA(184, 205, 255, 1);
                [button setTitleColor:WHITE];
                button.layer.borderColor = CLEAR.CGColor;
                [self.selectedBtnArr addObject:button];
                button.selected = !button.selected;
            }
        }else{
            UIButton *tempBtn1 = [self.selectedBtnArr firstObject];
            UIButton *tempBtn2 = [self.selectedBtnArr lastObject];
            [tempBtn1 setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            tempBtn1.selected = NO;
            tempBtn1.backgroundColor = WHITE;
            tempBtn1.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
            
            [tempBtn2 setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            tempBtn2.selected = NO;
            tempBtn2.backgroundColor = WHITE;
            tempBtn2.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
            [self.selectedBtnArr removeAllObjects];
            
            button.backgroundColor = RGBA(184, 205, 255, 1);
            [button setTitleColor:WHITE];
            button.layer.borderColor = CLEAR.CGColor;
            [self.selectedBtnArr addObject:button];
            button.selected = !button.selected;
        }
    }else{
        if (self.selectedBtnArr.count != 1) {
            [button setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
            button.backgroundColor = WHITE;
            button.layer.borderColor = RGBA(112, 112, 112, 1).CGColor;
            [self.selectedBtnArr removeObject:button];
            button.selected = !button.selected;
        }
        
    }
    
    [self getTimeSectionStr];
    [self requestSeatsData];
}


#pragma mark - other method
-(void)getTimeSectionStr{
    if (self.selectedBtnArr.count == 1) {
        UIButton *tempBtn1 = [self.selectedBtnArr firstObject];
        self.timeSectionStr = self.timeSectionArr[tempBtn1.tag-1];
    }else{
        UIButton *tempBtn1 = [self.selectedBtnArr firstObject];
        UIButton *tempBtn2 = [self.selectedBtnArr lastObject];
        
        NSString *startTime = @"";
        NSString *endTime = @"";
        if (tempBtn1.tag>tempBtn2.tag) {
            startTime = self.timeSectionArr[tempBtn2.tag-1];
            startTime = [[startTime componentsSeparatedByString:@"-"] firstObject];
            endTime = self.timeSectionArr[tempBtn1.tag-1];
            endTime = [[endTime componentsSeparatedByString:@"-"] lastObject];
        }else{
            startTime = self.timeSectionArr[tempBtn1.tag-1];
            startTime = [[startTime componentsSeparatedByString:@"-"] firstObject];
            endTime = self.timeSectionArr[tempBtn2.tag-1];
            endTime = [[endTime componentsSeparatedByString:@"-"] lastObject];
        }
        self.timeSectionStr = NSStringFormat(@"%@-%@",startTime,endTime);
    }
}

@end
