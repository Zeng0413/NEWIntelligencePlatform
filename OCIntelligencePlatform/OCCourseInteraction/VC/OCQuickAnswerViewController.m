//
//  OCQuickAnswerViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/20.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCQuickAnswerViewController.h"

@interface OCQuickAnswerViewController ()

@end

@implementation OCQuickAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLab = [UILabel labelWithText:@"（快速提问）" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, kNavH+24*FITWIDTH, 150*FITWIDTH, 18*FITWIDTH)];
    titleLab.font = kBoldFont(18*FITWIDTH);
    [self.view addSubview:titleLab];
}



@end
