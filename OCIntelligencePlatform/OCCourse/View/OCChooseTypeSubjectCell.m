//
//  OCChooseTypeSubjectCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCChooseTypeSubjectCell.h"
#import "OCSubjectAnswerModel.h"
#import "OCCourseOptionModel.h"

@interface OCChooseTypeSubjectCell ()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *answerBackView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subjectTitle;
@property (strong, nonatomic) UILabel *scoreLab;


@end

@implementation OCChooseTypeSubjectCell

+(instancetype)initWithOCChooseTypeSubjectWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCChooseTypeSubjectCellID";
    OCChooseTypeSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCChooseTypeSubjectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    
    self.title = [UILabel labelWithText:@"1/10单选题" font:14*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(16*FITWIDTH, 16*FITWIDTH, 130*FITWIDTH, 14*FITWIDTH)];
    [self.backView addSubview:self.title];
    
    self.scoreLab = [UILabel labelWithText:@"2分" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(self.backView.width-16*FITWIDTH-80*FITWIDTH, 16*FITWIDTH, 80*FITWIDTH, 12*FITWIDTH)];
    self.scoreLab.textAlignment = NSTextAlignmentRight;
    [self.backView addSubview:self.scoreLab];
    
    self.subjectTitle = [UILabel labelWithText:@"" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.subjectTitle.numberOfLines = 0;
    self.subjectTitle.x = 20*FITWIDTH;
    self.subjectTitle.y = MaxY(self.title)+16*FITWIDTH;
    [self.backView addSubview:self.subjectTitle];
    
}

-(void)setDataModel:(OCSubObjQuestionModel *)dataModel{
    _dataModel = dataModel;
    
    NSString *typeStr = @"";
    if (dataModel.type==1) {
        typeStr = @"单选题";
    }else if (dataModel.type==2){
        typeStr = @"多选题";
    }else if (dataModel.type==3){
        typeStr = @"判断题";
    }
    self.subjectTitle.text = dataModel.title;
    self.subjectTitle.size = [dataModel.title sizeWithFont:self.subjectTitle.font maxW:self.backView.width - 32*FITWIDTH];
    self.title.text = [NSString stringWithFormat:@"%ld/%ld%@",self.currentPage,self.subjectCount,typeStr];
    self.scoreLab.text = [NSString stringWithFormat:@"%ld分",dataModel.score];
    NSArray *answerList = dataModel.optionList;
    
    NSArray *optionIdList = [dataModel.userAnswer componentsSeparatedByString:@","];
    /** 避免循环引用 **/
    [self.answerBackView removeFromSuperview];
    self.answerBackView = nil;
    
    if (!self.answerBackView) {
        self.answerBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
        self.answerBackView.x = 0;
        self.answerBackView.y = MaxY(self.subjectTitle)+13*FITWIDTH;
        self.answerBackView.width = self.backView.width;
        [self.backView addSubview:self.answerBackView];
    
        UIButton *lastBtn = nil;
        for (int i = 0; i<answerList.count; i++) {
            OCCourseOptionModel *answerModel = answerList[i];
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"%@.%@",answerModel.opKey,answerModel.opValue] titleColor:TEXT_COLOR_BLACK backgroundColor:RGBA(244, 244, 244, 1) font:12*FITWIDTH image:@"" target:self action:nil frame:CGRectZero];
            btn.titleLabel.numberOfLines = 0;
            btn.x = 16*FITWIDTH;
            CGSize btnSize = [btn.titleLabel.text sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW-32*FITWIDTH];
            btn.size = CGSizeMake(self.backView.width - 32*FITWIDTH, btnSize.height+14*FITWIDTH);
            if (i == 0) {
                btn.y = 0;
            }else{
                btn.y = MaxY(lastBtn) + 8*FITWIDTH;
            }
            btn.layer.cornerRadius = 6;
            if (answerModel.correct == 1) {
                btn.backgroundColor = RGBA(95, 232, 154, 1);
            }
            
            for (int j = 0; j<optionIdList.count; j++) {
                NSInteger selectID = [optionIdList[j] integerValue];
                
                if (answerModel.correct == 0 && selectID == answerModel.optionId){
                    btn.backgroundColor = RGBA(255, 141, 148, 1);
                }
            }
            
            [self.answerBackView addSubview:btn];
            
            lastBtn = btn;
            if (i == answerList.count-1) {
                self.answerBackView.height = MaxY(btn);
            }
        }
    }
    
    self.backView.height = MaxY(self.answerBackView)+34*FITWIDTH;
    self.cellH = MaxY(self.backView);
}

@end
