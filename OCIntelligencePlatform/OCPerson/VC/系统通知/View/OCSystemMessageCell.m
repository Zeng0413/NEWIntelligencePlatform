//
//  OCSystemMessageCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/30.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSystemMessageCell.h"
#import <WebKit/WebKit.h>
@interface OCSystemMessageCell ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UIImageView *signImg;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) WKWebView *contenWebView;

@property (strong, nonatomic) UIButton *webBtn;

@end

@implementation OCSystemMessageCell

+(instancetype)initWithOCSystemMessageCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCSystemMessageCellID";
    OCSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//    OCSystemMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OCSystemMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
    self.titleLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    self.titleLab.font = kBoldFont(14*FITWIDTH);
    [self.contentView addSubview:self.titleLab];
    
    self.signImg = [UIImageView imageViewWithImage:GetImage(@"mine_icon_newMessage") frame:Rect(0, 16*FITWIDTH, 15*FITWIDTH, 16*FITWIDTH)];
    self.signImg.hidden = YES;
    [self.contentView addSubview:self.signImg];
    
    self.timeLab = [UILabel labelWithText:@"" font:14*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(kViewW - 24*FITWIDTH - 160*FITWIDTH, 16*FITWIDTH, 160*FITWIDTH, 14*FITWIDTH)];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLab];
    
    self.contentLab = [UILabel labelWithText:@"" font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    self.contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.contentLab];
    
    self.contenWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.contenWebView.hidden = YES;
    self.contenWebView.scrollView.scrollEnabled = NO;
    self.contenWebView.scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.contenWebView];
    
    self.webBtn = [[UIButton alloc] init];
    self.webBtn.backgroundColor = [UIColor clearColor];
    [self.webBtn addTarget:self action:@selector(webClick)];
    [self.contentView addSubview:self.webBtn];
    
    self.lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(20*FITWIDTH, 0, kViewW-40*FITWIDTH, 1*FITWIDTH)];
    [self.contentView addSubview:self.lineView];
}

-(void)setModel:(OCSystemMessageModel *)model{
    _model = model;
    
    NSString *titleStr = model.title;
//    if (model.messageType!=2) {
//        titleStr = @"教师申请成功";
//    }else{
//        titleStr = @"直播提醒";
//    }
    
    self.titleLab.x = 20*FITWIDTH;
    self.titleLab.y = 22*FITWIDTH;
    self.titleLab.size = [titleStr sizeWithFont:kBoldFont(14*FITWIDTH)];
    self.titleLab.text = titleStr;
    
    self.signImg.x = MaxX(self.titleLab)+8*FITWIDTH;
//    if (model.isNew) {
//        self.signImg.hidden = NO;
//    }else{
//        self.signImg.hidden = YES;
//    }
    
    NSString *timeStr = [NSString formateDate:NSStringFormat(@"%ld",model.createTime)];
    
    self.timeLab.centerY = self.titleLab.centerY;
    self.timeLab.text = timeStr;
    
    self.contentLab.x = self.titleLab.x;
    self.contentLab.y = MaxY(self.titleLab)+12*FITWIDTH;
    self.contentLab.size = [model.content sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW-40*FITWIDTH];
    self.contentLab.text = model.content;
    
    self.lineView.y = MaxY(self.contentLab)+15*FITWIDTH;
    
    self.cellH = MaxY(self.lineView);
}

-(void)setCollegeNotiModel:(OCCollegeNotiModel *)collegeNotiModel{
    _collegeNotiModel = collegeNotiModel;
    self.titleLab.x = 20*FITWIDTH;
    self.titleLab.y = 22*FITWIDTH;
    self.titleLab.size = [collegeNotiModel.title sizeWithFont:kBoldFont(14*FITWIDTH)];
    self.titleLab.width = 180*FITWIDTH;
    self.titleLab.text = collegeNotiModel.title;
    
    self.timeLab.centerY = self.titleLab.centerY;
    self.timeLab.text = collegeNotiModel.createTime;
    
    self.contenWebView.frame = Rect(self.titleLab.x, MaxY(self.titleLab)+12*FITWIDTH, kViewW-40*FITWIDTH, 50*FITWIDTH);
    self.webBtn.frame = self.contenWebView.frame;
    if ([collegeNotiModel.content containsString:@"<p"] || [collegeNotiModel.content containsString:@"<p style"] || [collegeNotiModel.content containsString:@"<div "]) {
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[collegeNotiModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        
//        
//        self.contentLab.attributedText = attrStr;
//        self.contentLab.x = self.titleLab.x;
//        self.contentLab.y = MaxY(self.titleLab)+12*FITWIDTH;
//        self.contentLab.size = CGSizeMake(kViewW-40*FITWIDTH, 50);
        self.contentLab.hidden = YES;
        self.contenWebView.hidden = NO;
        self.webBtn.hidden = NO;
        [self.contenWebView loadHTMLString:collegeNotiModel.content baseURL:nil];
        self.lineView.y = MaxY(self.contenWebView)+15*FITWIDTH;

    }else{
        self.contentLab.hidden = NO;
        self.contenWebView.hidden = YES;
        self.webBtn.hidden = YES;
        self.contentLab.x = self.titleLab.x;
        self.contentLab.y = MaxY(self.titleLab)+12*FITWIDTH;
        self.contentLab.size = [collegeNotiModel.content sizeWithFont:kFont(12*FITWIDTH) maxW:kViewW-40*FITWIDTH];
        self.contentLab.text = collegeNotiModel.content;
        self.lineView.y = MaxY(self.contentLab)+15*FITWIDTH;

    }
    
    
    
    self.cellH = MaxY(self.lineView);
}

-(void)webClick{
    if ([self.delegate respondsToSelector:@selector(clickWithCell:)]) {
        [self.delegate clickWithCell:self];
    }
}

@end
