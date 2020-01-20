//
//  OCClassroomListHeadView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/13.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCClassroomListHeadView.h"

@interface OCClassroomListHeadView ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation OCClassroomListHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = RGBA(12, 94, 210, 1);
    
    UIView *searchBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
    searchBackView.x = 20*FITWIDTH;
    searchBackView.width = kViewW - 40*FITWIDTH;
    searchBackView.height = 30*FITWIDTH;
    searchBackView.y = 30*FITWIDTH;
    searchBackView.layer.masksToBounds = YES;
    searchBackView.layer.cornerRadius = 3;
    searchBackView.userInteractionEnabled = YES;
    [self addSubview:searchBackView];

    UIImageView *searchIconImg = [UIImageView imageViewWithImage:GetImage(@"common_btn_search") frame:CGRectZero];
    searchIconImg.x = 12*FITWIDTH;
    searchIconImg.size = CGSizeMake(14*FITWIDTH, 14*FITWIDTH);
    searchIconImg.centerY = searchBackView.height/2;
    [searchBackView addSubview:searchIconImg];

    self.searchTextField = [[UITextField alloc] initWithFrame:Rect(MaxX(searchIconImg)+7*FITWIDTH, 0, searchBackView.width - (MaxX(searchIconImg)+7*FITWIDTH), searchBackView.height)];
    self.searchTextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    self.searchTextField.delegate=self;
    self.searchTextField.placeholder = @"搜索";
    self.searchTextField.font = kFont(14);
    [searchBackView addSubview:self.searchTextField];
    
    NSArray *imgArr = @[@"home_btn_scan",@"home_icon_borrow",@"common_btn_seat",@"common_btn_tv"];
    NSArray *titleArr = @[@"扫一扫",@"教室借用",@"预约座位",@"投屏"];
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(64*FITWIDTH, 64*FITWIDTH);
        btn.x = 20*FITWIDTH + (btn.width + 26*FITWIDTH)*i;
        btn.y = MaxY(searchBackView) + 10*FITWIDTH;
        
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnClick:)];
        btn.title = titleArr[i];
        btn.image = imgArr[i];
        btn.titleColor = WHITE;
        btn.titleFont = 14*FITWIDTH;
        [btn layoutButtonWithEdgInsetsStyle:WxyButtonEdgeInsetsStyleImageTop imageTitleSpacing:12*FITWIDTH];
        [self addSubview:btn];
        
        self.height = MaxY(btn) + 15*FITWIDTH;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(topViewBtnClickWithType:)]) {
        [self.delegate topViewBtnClickWithType:0];
    }
}

-(void)btnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(topViewBtnClickWithType:)]) {
        [self.delegate topViewBtnClickWithType:button.tag];
    }
}

@end
