//
//  OCCourseCallCountCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseCallCountCell.h"

@interface OCCourseCallCountCell ()
@property (weak, nonatomic) IBOutlet UILabel *callCount;
@property (weak, nonatomic) IBOutlet UILabel *addScoreCount;
@property (weak, nonatomic) IBOutlet UILabel *addScore;
@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation OCCourseCallCountCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.callCount.text = [NSString stringWithFormat:@"%@",[dataDict[@"callOutCount"] integerValue]==0?@"--":NSStringFormat(@"%@ 次",dataDict[@"callOutCount"])];
    self.addScoreCount.text = [NSString stringWithFormat:@"%@",[dataDict[@"addScoreCount"] integerValue] == 0?@"--":NSStringFormat(@"%@ 次",dataDict[@"addScoreCount"])];
    self.addScore.text = [NSString stringWithFormat:@"%@",[self.dataDict[@"score"] integerValue] == 0?@"--":NSStringFormat(@"%@ 分",self.dataDict[@"score"])];
}

@end
