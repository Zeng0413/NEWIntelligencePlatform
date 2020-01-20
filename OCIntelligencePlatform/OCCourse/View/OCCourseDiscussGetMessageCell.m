//
//  OCCourseDiscussGetMessageCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseDiscussGetMessageCell.h"

@interface OCCourseDiscussGetMessageCell ()

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLab;

@property(nonatomic,strong)UIImageView*backView;

@property (strong, nonatomic) UILabel *messageLab;
@end

@implementation OCCourseDiscussGetMessageCell

+(instancetype)initWithCourseDiscussGetMessageTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCCourseDiscussGetMessageCellID";
    OCCourseDiscussGetMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCCourseDiscussGetMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.contentView.backgroundColor = kBACKCOLOR;
    
    self.iconView = [UIImageView imageViewWithUrl:nil frame:Rect(20*FITWIDTH, 12*FITWIDTH, 36*FITWIDTH, 36*FITWIDTH)];
    self.iconView.contentMode=UIViewContentModeScaleToFill;
    self.iconView.clipsToBounds=YES;
    self.iconView.backgroundColor = [UIColor lightGrayColor];
    self.iconView.layer.cornerRadius=18*FITWIDTH;
    self.iconView.layer.masksToBounds=YES;
    [self.contentView addSubview:self.iconView];
    
    self.nameLab = [UILabel labelWithText:@"周杰伦" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:Rect(MaxX(self.iconView)+12*FITWIDTH, self.iconView.y, 100*FITWIDTH, 12*FITWIDTH)];
    [self.contentView addSubview:self.nameLab];
    
    self.backView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.backView];
    
    UIImage*backImge=[UIImage imageNamed:@"course_bg_dialog_left"];
    backImge=[backImge resizableImageWithCapInsets:UIEdgeInsetsMake(backImge.size.height/2,backImge.size.width/2,backImge.size.height/2,backImge.size.width/2) resizingMode:UIImageResizingModeStretch];
    self.backView.image=backImge;
    
    self.messageLab=[[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLab.font=[UIFont systemFontOfSize:14*FITWIDTH];
    self.messageLab.textColor=TEXT_COLOR_BLACK;
    self.messageLab.numberOfLines=0;
    [self.backView addSubview:self.messageLab];
}


-(void)setDataModel:(OCDiscussContentModel *)dataModel{
    _dataModel = dataModel;
    NSString *contentStr = dataModel.content;
    CGSize contentSize = [contentStr sizeWithFont:kFont(14*FITWIDTH) maxW:kViewW-20*FITWIDTH-self.nameLab.x-32*FITWIDTH];
    
    self.backView.frame = Rect(self.nameLab.x, MaxY(self.nameLab)+4*FITWIDTH, contentSize.width+32*FITWIDTH, contentSize.height+32*FITWIDTH);
    self.messageLab.frame = Rect(16*FITWIDTH, 16*FITWIDTH, contentSize.width, contentSize.height);
    self.messageLab.text = contentStr;
    
    self.nameLab.text = dataModel.userName;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.headImg]];
    self.cellH = MaxY(self.backView)+12*FITWIDTH;
}

@end
