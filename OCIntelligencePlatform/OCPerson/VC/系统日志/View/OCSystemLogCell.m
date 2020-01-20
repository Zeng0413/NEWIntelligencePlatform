//
//  OCSystemLogCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSystemLogCell.h"

@interface OCSystemLogCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation OCSystemLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timeLab.text = NSStringFormat(@"2019/03/21\n07:30");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(OCTourClassRecordModel *)model{
    _model = model;
    NSString *dateStr = NSStringFormat(@"%ld",model.createTime);
    dateStr = [NSString formateDate:dateStr];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@" "];
    self.label1.text = NSStringFormat(@"%@\n%@",dateArr[0],dateArr[1]);
    self.lable2.text = model.courseName;
    self.label3.text = model.teachName;
    self.timeLab.text = NSStringFormat(@"%ld",model.score);
}

@end
