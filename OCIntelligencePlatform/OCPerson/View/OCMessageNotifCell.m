//
//  OCMessageNotifCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCMessageNotifCell.h"
@interface OCMessageNotifCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;

@end
@implementation OCMessageNotifCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconW.constant = 32*FITWIDTH;
    self.iconH.constant = 32*FITWIDTH;
    self.titleLab.font = kFont(14*FITWIDTH);
    
    self.iconLab.layer.masksToBounds = YES;
    self.iconLab.layer.cornerRadius = 16*FITWIDTH;
}

-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    NSString *titleStr = dataDict[@"title"];
    NSString *firstStr = [titleStr substringToIndex:1];
    
    self.iconLab.text = firstStr;
    self.titleLab.text = titleStr;
}

@end
