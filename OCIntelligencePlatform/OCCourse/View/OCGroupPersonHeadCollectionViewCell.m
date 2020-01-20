//
//  OCGroupPersonHeadCollectionViewCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCGroupPersonHeadCollectionViewCell.h"
@interface OCGroupPersonHeadCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *personNumLab;
@property (strong, nonatomic) UILabel *gourpLeaderLab;
@end

@implementation OCGroupPersonHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImg.layer.cornerRadius = 32;
    self.scoreLab.backgroundColor = kAPPCOLOR;
    self.scoreLab.layer.masksToBounds = YES;
    self.scoreLab.layer.cornerRadius = 12;
    
    self.gourpLeaderLab = [UILabel labelWithText:@"组长" font:10 textColor:WHITE frame:Rect(0, self.headImg.height - 17*FITWIDTH, self.headImg.width, 17*FITWIDTH)];
    self.gourpLeaderLab.backgroundColor = kAPPCOLOR;
    self.gourpLeaderLab.textAlignment = NSTextAlignmentCenter;
    [self.headImg addSubview:self.gourpLeaderLab];
    // Initialization code
}

-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.scoreLab.text = dataDict[@"score"];
    self.nameLab.text = dataDict[@"name"];
    self.personNumLab.text = dataDict[@"number"];
}

-(void)setUserModel:(OCUserModel *)userModel{
    _userModel = userModel;
    self.scoreLab.text = NSStringFormat(@"%ld",userModel.score);
    self.nameLab.text = userModel.userName;
    self.personNumLab.text = userModel.userNumber;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:userModel.headImg]];
    if (userModel.leader == 1) {
        self.gourpLeaderLab.hidden = NO;
    }else{
        self.gourpLeaderLab.hidden = YES;
    }
}

@end
