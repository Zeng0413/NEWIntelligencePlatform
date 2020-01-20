//
//  TSNavigationBar.m
//
//  Created by Seven on 15/10/13.
//  Copyright © 2015年 Seven Lv. All rights reserved.
//

/// 返回按钮图片
#define BackButtonImageName @"common_btn_back_black"
#define TitleColor TEXT_COLOR_BLACK
#define RightColor TEXT_COLOR_BLACK
#define BackColor WHITE
//#warning 改图片名字在这里改

#import "TSNavigationBar.h"
#import <objc/runtime.h>
typedef void (^ButtonClick)(void);

@interface TSNavigationBar ()

@property(nonatomic, copy)ButtonClick backBlock;
@property(nonatomic, copy)ButtonClick actionBlock;
@end

@implementation TSNavigationBar

#pragma mark - 对象方法
- (instancetype)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
        self.size = CGSizeMake(kViewW,kNavH);
        self.backgroundColor = BackColor;
        // 分隔线
        CALayer * layer = [CALayer layer];
        layer.frame = Rect(0, kNavH - 0.5, kViewW, 0.5);
        layer.backgroundColor = RGBA(212, 212, 212, 1).CGColor;
        self.lineLayer = layer;
        [self.layer addSublayer:layer];
        layer.hidden = YES;
        
        [self.superview bringSubviewToFront:self];
    }
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.size = CGSizeMake(kViewW,kNavH);
        self.backgroundColor = BackColor;
        // 分隔线
        CALayer * layer = [CALayer layer];
        layer.frame = Rect(0, kNavH - 0.5, kViewW, 0.5);
        layer.backgroundColor = RGBA(212, 212, 212, 1).CGColor;
        self.lineLayer = layer;
        [self.layer addSublayer:layer];
        
        [self.superview bringSubviewToFront:self];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)act
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:18 textColor:TitleColor frame:Rect(40, kStatusH, kViewW - 80, 44)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, kStatusH + 12, 54, 44)];
        [back addTarget:target action:act];
        back.contentEdgeInsets = UIEdgeInsetsMake(10, 11, 10, 11);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        self.backButton = back;
        [self addSubview:back];
        self.titleLabel = label;
    }
    return self;
}

- (instancetype)initWithTitle_:(NSString *)title
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:18 textColor:TitleColor frame:Rect(0, kStatusH, kViewW, 44)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        self.titleLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title backAction:(void (^)(void))backAction
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:18 textColor:TitleColor frame:Rect(40, kStatusH, kViewW - 80, 44)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, kStatusH + 12, 54, 44)];
        [back addTarget:self action:@selector(backClick)];
        back.contentEdgeInsets = UIEdgeInsetsMake(10, 11, 10, 11);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        self.backButton = back;
        [self addSubview:back];
        if (backAction) {
            self.backBlock = backAction;
        }
        self.titleLabel = label;
        
        [self.superview bringSubviewToFront:self];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(void (^)(void))action
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:18 textColor:TitleColor frame:Rect(0, kStatusH, kViewW, 44)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGSize size = [NSString getStringRect:rightTitle fontSize:14 width:300];
        UIButton * btn = [UIButton buttonWithTitle:rightTitle titleColor:RightColor backgroundColor:nil font:14 image:nil frame:Rect(kViewW - 15 - size.width, 0, size.width, 22)];
        [self addSubview:btn];
        btn.adjustsImageWhenHighlighted = NO;
        btn.centerY = label.centerY;
        
        [btn addTarget:self action:@selector(btnClick)];
        if (action) {
            self.actionBlock = action;
        }
        
        self.rightButton = btn;
        self.titleLabel = label;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title rightImage:(NSString *)rightImage rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:18 textColor:TitleColor frame:Rect(0, kStatusH, kViewW, 44)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton * btn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:rightImage frame:Rect(kViewW - 40, 0, 22, 22)];
        [self addSubview:btn];
        btn.adjustsImageWhenHighlighted = NO;
        btn.centerY = label.centerY;
        
        [btn addTarget:self action:@selector(btnClick)];
        if (action) {
            self.actionBlock = action;
        }
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, kStatusH + 12, 54, 44)];
        [back addTarget:self action:@selector(backClick)];
        back.contentEdgeInsets = UIEdgeInsetsMake(10, 11, 10, 11);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        self.backButton = back;
        [self addSubview:back];
        if (backAction) {
            self.backBlock = backAction;
        }
        
        self.titleLabel = label;
        self.rightButton = btn;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)right rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:18 textColor:TitleColor frame:Rect(0, kStatusH, kViewW, 44)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGSize size = [NSString getStringRect:right fontSize:14 width:300];
        if (size.width < 40) {
            size.width = 40;
        }
        
        UIButton * btn = [UIButton buttonWithTitle:right titleColor:RightColor backgroundColor:nil font:14 image:nil frame:Rect(kViewW - 15 - size.width, 0, size.width, 30)];
        [self addSubview:btn];
        btn.adjustsImageWhenHighlighted = NO;
        btn.centerY = label.centerY;
        
        [btn addTarget:self action:@selector(btnClick)];
        if (action) {
            self.actionBlock = action;
        }
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, kStatusH + 12, 54, 44)];
        [back addTarget:self action:@selector(backClick)];
        back.contentEdgeInsets = UIEdgeInsetsMake(10, 11, 10, 11);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        self.backButton = back;
        [self addSubview:back];
        if (backAction) {
            self.backBlock = backAction;
        }
        
        self.titleLabel = label;
        self.rightButton = btn;
    }
    return self;
}

#pragma mark - 类方法
+ (instancetype)navWithTitle:(NSString *)title
                  rightTitle:(NSString *)rightTitle
                 rightAction:(void(^)(void))action {
    return [[self alloc] initWithTitle:title rightTitle:rightTitle rightAction:action];
}
+ (instancetype)navWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle_:title];
}
+ (instancetype)navWithTitle:(NSString *)title backAction:(void (^)(void))backAction
{
    return [[self alloc] initWithTitle:title backAction:backAction];
}

+ (instancetype)navWithTitle:(NSString *)title rightImage:(NSString *)rightImage rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    return [[self alloc] initWithTitle:title rightImage:rightImage rightAction:action backAction:backAction];
}

+ (instancetype)navWithTitle:(NSString *)title rightTitle:(NSString *)right rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    return [[self alloc] initWithTitle:title rightTitle:right rightAction:action backAction:backAction];
}

#pragma mark - ButtonAction
- (void)btnClick {
    if (self.actionBlock) self.actionBlock();
}

- (void)backClick {
    
    if (self.backBlock) self.backBlock();
}
@end

#import "TSNavigationBar.h"
static const char MJRefreshFooterKey = '\0';
static const char notNeedPanKey = '\1';

@implementation UIViewController (NavigatiionBar)

- (void)setTs_navgationBar:(TSNavigationBar *)ts_navgationBar {
    if (self.ts_navgationBar != ts_navgationBar) {
        [self.ts_navgationBar removeFromSuperview];
        [self.view addSubview:ts_navgationBar];
        objc_setAssociatedObject(self, &MJRefreshFooterKey, ts_navgationBar, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (TSNavigationBar *)ts_navgationBar
{
    return objc_getAssociatedObject(self, &MJRefreshFooterKey);
}

- (void)setNotNeedPanPopReturn:(NSString *)notNeedPanPopReturn {
    objc_setAssociatedObject(self, &notNeedPanKey, notNeedPanPopReturn, OBJC_ASSOCIATION_ASSIGN);
    
}

- (NSString *)notNeedPanPopReturn {
    NSString * result = (NSString *)objc_getAssociatedObject(self, &notNeedPanKey);
    
    return result;
}

@end
