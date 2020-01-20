//
//  OCSolutionTypeQuestionCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSolutionTypeQuestionCell.h"
@interface OCSolutionTypeQuestionCell ()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subjectTitle;
@property (strong, nonatomic) UILabel *scoreLab;
@property (strong, nonatomic) UIImageView *img;

@property(nonatomic,strong)UIImageView*messageBackView;

@property (strong, nonatomic) UILabel *messageLab;

@end
@implementation OCSolutionTypeQuestionCell

+(instancetype)initWithOCSolutionTypeQuestionWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCSolutionTypeQuestionCellID";
    OCSolutionTypeQuestionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OCSolutionTypeQuestionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    
    self.subjectTitle = [UILabel labelWithText:@"" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.subjectTitle.numberOfLines = 0;
    self.subjectTitle.x = 20*FITWIDTH;
    self.subjectTitle.y = MaxY(self.title)+16*FITWIDTH;
    [self.backView addSubview:self.subjectTitle];
    
    self.img = [UIImageView imageViewWithUrl:nil frame:Rect(self.subjectTitle.x, MaxY(self.subjectTitle)+13*FITWIDTH, self.backView.width - 32*FITWIDTH, 170*FITWIDTH)];
    self.img.backgroundColor = [UIColor clearColor];
    self.img.contentMode = UIViewContentModeScaleAspectFit;
    [self.backView addSubview:self.img];
    
    self.messageBackView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:self.messageBackView];
    UIImage*backImge=[UIImage imageNamed:@"course_bg_dialog_right_blue"];
    backImge=[backImge resizableImageWithCapInsets:UIEdgeInsetsMake(backImge.size.height/2,backImge.size.width/2,backImge.size.height/2,backImge.size.width/2) resizingMode:UIImageResizingModeStretch];
    self.messageBackView.image=backImge;
    
    self.messageLab=[[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLab.font=[UIFont systemFontOfSize:12*FITWIDTH];
    self.messageLab.textColor=TEXT_COLOR_BLACK;
    self.messageLab.numberOfLines=0;
    [self.messageBackView addSubview:self.messageLab];
}

-(void)setDataModel:(OCSubObjQuestionModel *)dataModel{
    NSString *typeStr = @"";
    NSInteger subjectType = dataModel.type;
    if (subjectType == 4){
        typeStr = @"简答题";
    }else if (subjectType == 5){
        typeStr = @"分组讨论";
    }else if (subjectType == 6){
        typeStr = @"自由讨论";
    }
    self.subjectTitle.text = dataModel.title;
    if (subjectType == 6) {
        self.img.hidden = YES;
        self.subjectTitle.text = @"（快速提问）";
    }
    self.subjectTitle.size = [self.subjectTitle.text sizeWithFont:self.subjectTitle.font maxW:self.backView.width - 32*FITWIDTH];
    self.title.text = [NSString stringWithFormat:@"%ld/%ld%@",self.currentPage,self.subjectCount,typeStr];
    self.scoreLab.text = [NSString stringWithFormat:@"%ld分",dataModel.score];
    
    self.img.y = MaxY(self.subjectTitle)+13*FITWIDTH;
    
    CGSize contentSize = [dataModel.answerContent sizeWithFont:kFont(12*FITWIDTH) maxW:self.backView.width - 64*FITWIDTH];
    if (dataModel.imgsList.count==0) {
        self.img.hidden = YES;
    }else{
        [self.img sd_setImageWithURL:[NSURL URLWithString:[dataModel.imgsList firstObject]]];
        self.img.hidden = NO;
    }
    
    
    
    self.messageBackView.frame = Rect(self.backView.width - 16*FITWIDTH - contentSize.width - 32*FITWIDTH, subjectType==6 || dataModel.imgsList.count==0 ? MaxY(self.subjectTitle)+13*FITWIDTH : MaxY(self.img)+13*FITWIDTH, contentSize.width+32*FITWIDTH, contentSize.height+32*FITWIDTH);
    self.messageLab.frame = Rect(16*FITWIDTH, 16*FITWIDTH, contentSize.width, contentSize.height);
    self.messageLab.text = dataModel.answerContent;
    
    if (dataModel.answerContent.length == 0) {
        self.messageBackView.height = 0;
    }
    
    self.backView.height = MaxY(self.messageBackView)+24*FITWIDTH;
    self.cellH = MaxY(self.backView);
}

@end
