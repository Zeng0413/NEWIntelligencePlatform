//
//  OCCommonTopChooseView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/9.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCommonTopChooseView.h"

@interface OCCommonTopChooseView ()
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *selectedBtn;
@end

@implementation OCCommonTopChooseView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithTopViewFrame:(CGRect)frame titleName:(NSArray *)titles aveWidth:(NSInteger)ave{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WHITE;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.contentSize = CGSizeMake((kViewW/ave)*titles.count, 0);
        scrollView.backgroundColor = WHITE;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        for (int i = 0; i<titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.width = kViewW/ave;
            btn.height = self.height-4*FITWIDTH;
            btn.x = i*btn.width;
            btn.y = 0;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14*FITWIDTH];
            [btn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            [btn setTitleColor:kAPPCOLOR forState:UIControlStateDisabled];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:btn];
            [scrollView addSubview:btn];
            
            if (i == 0) {
                self.lineView = [[UIView alloc] init];
                self.lineView.backgroundColor = kAPPCOLOR;
                self.lineView.height = 4*FITWIDTH;
                self.lineView.width = 18*FITWIDTH;
                self.lineView.layer.masksToBounds = YES;
                self.lineView.layer.cornerRadius = 2*FITWIDTH;
                self.lineView.y = CGRectGetMaxY(btn.frame);
                [scrollView addSubview:self.lineView];
            }
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
    
    [self scrolling:button.tag];
}

-(void)scrolling:(NSInteger)tag{
    UIButton *btn = self.buttons[tag];
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.centerX = btn.centerX;
    }];
}

-(void)selectedWithIndex:(NSInteger)index{
    UIButton *btn = self.buttons[index];
    [self btnClick:btn];
}
@end
