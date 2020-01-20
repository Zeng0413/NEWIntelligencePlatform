//
//  OCQuickChooseAnswerCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCQuickChooseAnswerCell.h"
#import "OCSubjectAnswerModel.h"
@interface OCQuickChooseAnswerCell ()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subjectTitle;
@property (strong, nonatomic) UILabel *scoreLab;
@end
@implementation OCQuickChooseAnswerCell

+(instancetype)initWithOCQuickChooseAnswerWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCSolutionTypeQuestionCellID";
    OCQuickChooseAnswerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OCQuickChooseAnswerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kBACKCOLOR;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backView = [UIView viewWithBgColor:WHITE frame:Rect(20*FITWIDTH, 24*FITWIDTH, kViewW-40*FITWIDTH, 0)];
    self.backView.layer.cornerRadius = 5*FITWIDTH;
    [self.contentView addSubview:self.backView];
    
    self.title = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(16*FITWIDTH, 16*FITWIDTH, 130*FITWIDTH, 14*FITWIDTH)];
    [self.backView addSubview:self.title];
    
    self.scoreLab = [UILabel labelWithText:@"2分" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.backView.width-16*FITWIDTH-80*FITWIDTH, 16*FITWIDTH, 80*FITWIDTH, 12*FITWIDTH)];
    self.scoreLab.textAlignment = NSTextAlignmentRight;
    [self.backView addSubview:self.scoreLab];
    
    self.subjectTitle = [UILabel labelWithText:@"（快速提问）" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(20*FITWIDTH, MaxY(self.title)+16*FITWIDTH, 150*FITWIDTH, 18*FITWIDTH)];
    [self.backView addSubview:self.subjectTitle];
}

-(void)setDataModel:(OCCourseSubjectModel *)dataModel{
    _dataModel = dataModel;
    NSString *typeStr = @"";
    if ([dataModel.type integerValue] ==1) {
        typeStr = @"单选题";
    }else if ([dataModel.type integerValue] == 2){
        typeStr = @"多选题";
    }else if ([dataModel.type integerValue] == 3){
        typeStr = @"简答题";
    }else if ([dataModel.type integerValue] == 4){
        typeStr = @"判断题";
    }else if ([dataModel.type integerValue] == 5){
        typeStr = @"多选题";
    }else if ([dataModel.type integerValue] == 6){
        typeStr = @"简答题";
    }
    self.title.text = [NSString stringWithFormat:@"%ld/%ld%@",self.currentPage,self.subjectCount,typeStr];
    self.scoreLab.text = [NSString stringWithFormat:@"%@分",dataModel.score];

    NSArray *answerList = dataModel.answerList;
    CGFloat border = 12*FITWIDTH;
    NSInteger col = 4;
    CGFloat btnW = (self.backView.width - 32*FITWIDTH - border*(col-1))/col;
    for (int i = 0; i<answerList.count; i++) {
        OCSubjectAnswerModel *answerModel = answerList[i];
        UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"%@",answerModel.key] titleColor:TEXT_COLOR_BLACK backgroundColor:RGBA(244, 244, 244, 1) font:18*FITWIDTH image:@"" target:self action:nil frame:CGRectZero];
        btn.size = CGSizeMake(btnW, 48*FITWIDTH);
        btn.x = 16*FITWIDTH + (btnW+border)*(i%col);
        btn.y = MaxY(self.subjectTitle) + 13*FITWIDTH + (btn.height+8*FITWIDTH)*(i/col);
        btn.layer.cornerRadius = 4;
        if ([answerModel.isCorrect integerValue] == 1) {
            btn.backgroundColor = RGBA(95, 232, 154, 1);
        }else if ([answerModel.isCorrect integerValue] == 0 && [answerModel.isSelected integerValue] == 1){
            btn.backgroundColor = RGBA(255, 141, 148, 1);
        }
        [self.backView addSubview:btn];
        
        if (i == answerList.count - 1) {
            self.backView.height = MaxY(btn)+24*FITWIDTH;
        }
    }
    
    self.cellH = MaxY(self.backView);
}

@end
