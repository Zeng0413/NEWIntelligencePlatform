//
//  uploadImageView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "uploadImageView.h"

@interface uploadImageView ()

@end

@implementation uploadImageView

-(void)configpic:(NSArray*)picArray{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat imageWH = (self.width - self.imageBorder*FITWIDTH*(self.maxRow-1))/self.maxRow;
    for (int i = 0; i<picArray.count; i++) {
        self.iconView = [[UIImageView alloc] initWithFrame:Rect((i%self.maxRow)*(imageWH+self.imageBorder), 7.5*FITWIDTH+(i/self.maxRow)*(10*FITWIDTH+imageWH), imageWH, imageWH)];
        [self.iconView setCornerRadius:4*FITWIDTH];
        [self addSubview:self.iconView];
        
        if ([picArray[i] isKindOfClass:[UIImage class]]) {
            self.iconView.image=picArray[i];
        }else{
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:picArray[i]]];
        }
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.size = CGSizeMake(15*FITWIDTH, 15*FITWIDTH);
        self.deleteBtn.x = MaxX(self.iconView)-self.deleteBtn.width/2;
        self.deleteBtn.y = self.iconView.y - self.deleteBtn.height/2;
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:self.deleteImgStr] forState:UIControlStateNormal];
        self.deleteBtn.tag = i;
        [self.deleteBtn addTarget:self action:@selector(deleteImgClick:)];
        [self addSubview:self.deleteBtn];
    }
    
    NSInteger index = picArray.count;
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.size = CGSizeMake(imageWH, imageWH);
    self.addBtn.x = (index%self.maxRow)*(imageWH+self.imageBorder);
    self.addBtn.y = 7.5*FITWIDTH+(index/self.maxRow)*(10*FITWIDTH+imageWH);
    [self.addBtn setBackgroundImage:GetImage(self.defualtImgStr) forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addImageClick)];
    [self addSubview:self.addBtn];
    
    self.height = MaxY(self.addBtn)+5*FITWIDTH;
}

-(void)deleteImgClick:(UIButton *)button{
    if (self.dePicclick) {
        self.dePicclick(button.tag);
    }
}

-(void)addImageClick{
    if (self.adPicclick) {
        self.adPicclick();
        
    }
}

@end
