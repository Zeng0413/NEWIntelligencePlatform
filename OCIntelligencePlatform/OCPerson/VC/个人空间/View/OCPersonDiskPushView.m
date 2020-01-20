//
//  OCPersonDiskPushView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/7.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPersonDiskPushView.h"

@interface OCPersonDiskPushView ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation OCPersonDiskPushView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.6;
    
    self.confirmBtn.layer.cornerRadius = 14;
    self.confirmBtn.layer.borderColor = kAPPCOLOR.CGColor;
    self.confirmBtn.layer.borderWidth = 1.0f;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.backView addGestureRecognizer:tapGesture];
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
    self.titleLab.size = [titleStr sizeWithFont:kFont(14) maxW:self.backView.width - 44];
    self.textField.hidden = YES;
}

- (void) tapGesture
{
    [self removeFromSuperview];
}

+(OCPersonDiskPushView *)creatPersonDiskPushView{
    OCPersonDiskPushView *view = [OCPersonDiskPushView creatViewFromNib];
    return view;
}

- (IBAction)cancelClick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmClick:(id)sender {
    if (self.block) {
        self.block(self.textField.text);
    }
    [self removeFromSuperview];
}
@end
