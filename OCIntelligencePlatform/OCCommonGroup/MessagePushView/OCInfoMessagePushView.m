//
//  OCInfoMessagePushView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/13.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCInfoMessagePushView.h"

@interface OCInfoMessagePushView ()

@property (strong, nonatomic) UIView *contentBackView;

@property (strong, nonatomic) UILabel *contentLab;

@property (assign, nonatomic) NSInteger btnCount;

@property (copy, nonatomic) NSString *btn1Str;

@property (copy, nonatomic) NSString *btn2Str;

@property (copy, nonatomic) NSString *allStr;

@property (copy, nonatomic) NSString *pointStr;

@property (strong, nonatomic) UIColor *pointStrColor;

@end

@implementation OCInfoMessagePushView

-(instancetype)initWithPushViewFrame:(CGRect)frame withAllStr:(NSString *)allStr withPointStr:(NSString *)pointStr withPointStrColor:(UIColor *)strColor withBtnCount:(NSInteger)count withBtn1Str:(NSString *)btn1Str withBtn2Str:(NSString *)btn2Str{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WHITE;
        self.btnCount = count;
        self.btn1Str = btn1Str;
        self.btn2Str = btn2Str;
        self.allStr = allStr;
        self.pointStr = pointStr;
        self.pointStrColor = strColor;
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithPushViewFrame:(CGRect)frame withImg:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WHITE;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.size = CGSizeMake(16*FITWIDTH, 16*FITWIDTH);
        cancelBtn.y = 8*FITWIDTH;
        cancelBtn.x = self.width - 8*FITWIDTH - cancelBtn.width;
        [cancelBtn addTarget:self action:@selector(cancelClick)];
        cancelBtn.image = @"common_btn_close";
        [self addSubview:cancelBtn];
        
        UIImageView *contentImg = [UIImageView imageViewWithImage:image frame:CGRectZero];
        contentImg.size = CGSizeMake(176*FITWIDTH, 176*FITWIDTH);
        contentImg.y = 42*FITWIDTH;
        contentImg.centerX = self.centerX;
        [self addSubview:contentImg];
        
        [self setCornerRadius:7*FITWIDTH];
    }
    return self;
}

-(void)setupUI{
//    self.contentBackView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, kViewW - 67*2*FITWIDTH, 0)];
//    [self addSubview:self.contentBackView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.size = CGSizeMake(16*FITWIDTH, 16*FITWIDTH);
    cancelBtn.y = 8*FITWIDTH;
    cancelBtn.x = self.width - 8*FITWIDTH - cancelBtn.width;
    [cancelBtn addTarget:self action:@selector(cancelClick)];
    cancelBtn.image = @"common_btn_close";
    [self addSubview:cancelBtn];
    
    self.contentLab = [UILabel labelWithText:self.allStr font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.contentLab.size = [self.allStr sizeWithFont:kFont(14*FITWIDTH) maxW:self.width - 50*FITWIDTH];
    self.contentLab.numberOfLines = 0;
    self.contentLab.x = 25*FITWIDTH;
    self.contentLab.y = 40*FITWIDTH;

    NSArray *lineArr = [OCPublicMethodManager getLinesArrayOfStringInLabel:self.allStr withLabSize:14*FITWIDTH];
    self.contentLab.height = self.contentLab.height + lineArr.count * 7;
    self.contentLab.attributedText = [NSString attrStrFrom:self.allStr pointStr:self.pointStr color:self.pointStrColor font:kFont(14*FITWIDTH)];
//    self.contentLab.attributedText = [NSString setLineSpacingString:self.allStr lineSpacing:4];
    [self addSubview:self.contentLab];
    
    if (self.btnCount == 0) {
        self.height = MaxY(self.contentLab)+30*FITWIDTH;
    }else if (self.btnCount == 1){
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.size = CGSizeMake(100*FITWIDTH, 28*FITWIDTH);
        btn1.y = MaxY(self.contentLab)+30*FITWIDTH;
        btn1.x = (self.width - btn1.width)/2;
        [btn1 setBackgroundColor:kAPPCOLOR];
        btn1.title = self.btn1Str;
        btn1.titleColor = WHITE;
        btn1.titleFont = 12*FITWIDTH;
        btn1.layer.cornerRadius = btn1.height/2;
        btn1.tag = 1;
        [btn1 addTarget:self action:@selector(btnClick:)];
        [self addSubview:btn1];
        self.height = MaxY(btn1)+30*FITWIDTH;
    }else if (self.btnCount == 2){
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.size = CGSizeMake(64*FITWIDTH, 28*FITWIDTH);
        btn1.y = MaxY(self.contentLab)+30*FITWIDTH;
        btn1.x = self.width/2 - 10*FITWIDTH - btn1.width;
        [btn1 setBackgroundColor:kAPPCOLOR];
        btn1.title = self.btn1Str;
        btn1.titleColor = WHITE;
        btn1.titleFont = 12*FITWIDTH;
        btn1.tag = 1;
        btn1.layer.cornerRadius = btn1.height/2;
        [btn1 addTarget:self action:@selector(btnClick:)];
        [self addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.size = btn1.size;
        btn2.y = btn1.y;
        btn2.x = self.width/2 + 10*FITWIDTH;
        [btn2 setBackgroundColor:WHITE];
        btn2.title = self.btn2Str;
        btn2.titleColor = kAPPCOLOR;
        btn2.titleFont = 12*FITWIDTH;
        btn2.tag = 2;
        btn2.layer.borderColor = kAPPCOLOR.CGColor;
        btn2.layer.borderWidth = 1.0;
        btn2.layer.cornerRadius = btn2.height/2;
        [btn2 addTarget:self action:@selector(btnClick:)];
        [self addSubview:btn2];
        self.height = MaxY(btn1)+30*FITWIDTH;
    }
    
    [self setCornerRadius:7*FITWIDTH];
    
}

-(void)cancelClick{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

-(void)btnClick:(UIButton *)button{
    if (self.btnBlock) {
        self.btnBlock(button.tag);
    }
}

@end
