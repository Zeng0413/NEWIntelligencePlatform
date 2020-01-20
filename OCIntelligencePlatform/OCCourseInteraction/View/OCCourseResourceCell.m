//
//  OCCourseResourceCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseResourceCell.h"
@interface OCCourseResourceCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;

@end

@implementation OCCourseResourceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconH.constant = 34*FITWIDTH;
    self.iconW.constant = 34*FITWIDTH;
    self.titleLab.font = kFont(14*FITWIDTH);
    // Initialization code
}

-(void)setDataModel:(OCCourseWareModel *)dataModel{
    _dataModel = dataModel;
    self.titleLab.text = dataModel.name;
}

- (IBAction)oparetionClick:(UIButton *)sender {
    
}
@end
