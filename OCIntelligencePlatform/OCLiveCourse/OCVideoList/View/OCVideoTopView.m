//
//  OCVideoTopView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/20.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCVideoTopView.h"

@interface OCVideoTopView ()
//@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) CGFloat maxOffsetX;
@end

@implementation OCVideoTopView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithTopViewFrame:(CGRect)frame titleName:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBACKCOLOR;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        self.scrollView.backgroundColor = kBACKCOLOR;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        UIButton *lastBtn = nil;
        for (int i = 0; i<titles.count; i++) {
            NSString *titleStr = titles[i];
            CGSize btnSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:14*FITWIDTH]];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.width = btnSize.width;
            btn.height = self.height-2;
            if (i == 0) {
                btn.x = 20*FITWIDTH;
            }else{
                btn.x = MaxX(lastBtn) + 20*FITWIDTH;
            }
            
            btn.y = 0;
            
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = kBoldFont(14*FITWIDTH);
            [btn setTitleColor:TEXT_COLOR_GRAY forState:UIControlStateNormal];
            [btn setTitleColor:kAPPCOLOR forState:UIControlStateDisabled];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:btn];
            [self.scrollView addSubview:btn];
            
            if (i == titles.count-1) {
                self.scrollView.contentSize = CGSizeMake(MaxX(btn)+20*FITWIDTH, 0);
            }
            lastBtn = btn;
        }
    }
    return self;
}

-(void)btnClick:(UIButton *)button{
    
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    if (self.block) {
        self.block(button.tag);
    }
    
}

-(void)selectedWithIndex:(NSInteger)index{
    UIButton *btn = self.buttons[index];
    [self btnClick:btn];
    
    if (self.buttons.count<6) {
        return;
    }
    CGFloat offsetX = btn.x-20*FITWIDTH;
    CGFloat maxOffsetX = self.scrollView.contentSize.width-self.scrollView.width;
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    self.scrollView.bouncesZoom = NO;
}

@end
