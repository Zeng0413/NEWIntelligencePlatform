//
//  OCCourseProblemCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseProblemCell.h"

@interface OCCourseProblemCell ()

@property (strong, nonatomic) UIView *backView;
@end

@implementation OCCourseProblemCell

+(instancetype)initWithCourseProblemTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCCourseProblemCellID";
    OCCourseProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCCourseProblemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kBACKCOLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setCourseProblemArr:(NSArray *)courseProblemArr{
    _courseProblemArr = courseProblemArr;
    
    if (!self.backView) {
        self.backView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 12*FITWIDTH, kViewW, (161*2+13)*FITWIDTH)];
        [self.contentView addSubview:self.backView];
       
        for (int i = 0; i<courseProblemArr.count; i++) {
            NSDictionary *dict = courseProblemArr[i];
            CGFloat backViewW = (kViewW - 40*FITWIDTH - 12*FITWIDTH)/2;
            CGFloat backViewH = (self.backView.height - 13*FITWIDTH)/2;
            UIView *contentBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
            contentBackView.size = CGSizeMake(backViewW, backViewH);
            contentBackView.x = 20*FITWIDTH + (backViewW+12*FITWIDTH)*(i%2);
            contentBackView.y = (backViewH+13*FITWIDTH)*(i/2);
            contentBackView.layer.cornerRadius = 7;
            [self.backView addSubview:contentBackView];
            
            UILabel *correctCount = [UILabel labelWithText:dict[@"correctCount"] font:40*FITWIDTH textColor:kAPPCOLOR frame:CGRectZero];
            correctCount.font = [UIFont boldSystemFontOfSize:40*FITWIDTH];
            correctCount.size = [correctCount.text sizeWithFont:[UIFont boldSystemFontOfSize:40*FITWIDTH]];
            correctCount.height = 40*FITWIDTH;
            correctCount.x = contentBackView.width/2 - correctCount.width;
            correctCount.centerY = contentBackView.height/2;
            [contentBackView addSubview:correctCount];
            
            UILabel *problemCount = [UILabel labelWithText:NSStringFormat(@"/%@题",dict[@"totalCount"]) font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
            problemCount.font = [UIFont boldSystemFontOfSize:14*FITWIDTH];
            problemCount.size = [problemCount.text sizeWithFont:[UIFont boldSystemFontOfSize:14*FITWIDTH]];
            problemCount.x = contentBackView.width/2;
            problemCount.y = MaxY(correctCount)- problemCount.height - 3*FITWIDTH;
            [contentBackView addSubview:problemCount];
            
            NSString *typeStr = @"";
            NSInteger type = [dict[@"type"] integerValue];
            if (type == 1) {
                typeStr = @"单选题";
            }else if (type == 2){
                typeStr = @"多选题";
            }else if (type == 3){
                typeStr = @"判断题";
            }else{
                typeStr = @"简答题";
            }
            UILabel *problemType = [UILabel labelWithText:typeStr font:16*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
            problemType.font = [UIFont boldSystemFontOfSize:16*FITWIDTH];
            problemType.size = [problemType.text sizeWithFont:[UIFont boldSystemFontOfSize:16*FITWIDTH]];
            problemType.y = 24*FITWIDTH;
            problemType.centerX = contentBackView.width/2;
            [contentBackView addSubview:problemType];
            
            UILabel *decLab = [UILabel labelWithText:dict[@"name"] font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
            decLab.size = [decLab.text sizeWithFont:[UIFont systemFontOfSize:14*FITWIDTH]];
            decLab.y = contentBackView.height-decLab.height-24*FITWIDTH;
            decLab.centerX = contentBackView.width/2;
            [contentBackView addSubview:decLab];
            
            if (i == courseProblemArr.count-1) {
                self.cellH = MaxY(contentBackView)+18*FITWIDTH;
                self.backView.height = self.cellH;
            }
        }
    }
}

@end
