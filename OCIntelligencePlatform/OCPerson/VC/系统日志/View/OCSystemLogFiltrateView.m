//
//  OCSystemLogFiltrateView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSystemLogFiltrateView.h"

@interface OCSystemLogFiltrateView ()
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation OCSystemLogFiltrateView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.resetBtn.layer.borderColor = kAPPCOLOR.CGColor;
    self.resetBtn.layer.borderWidth = 1.0f;
    self.resetBtn.layer.cornerRadius = 14;

    [self LX_SetShadowPathWith:TEXT_COLOR_GRAY shadowOpacity:0.1 shadowRadius:2 shadowSide:LXShadowPathBottom shadowPathWidth:10];
}

+(OCSystemLogFiltrateView *)creatSystemLogFiltrateView{
    OCSystemLogFiltrateView *view = [OCSystemLogFiltrateView creatViewFromNib];
    return view;
}

@end
