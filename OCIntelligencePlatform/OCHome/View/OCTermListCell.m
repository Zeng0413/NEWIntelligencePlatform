//
//  OCTermListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTermListCell.h"
@interface OCTermListCell ()

@property (strong, nonatomic) UIImageView *moreImg;

@end
@implementation OCTermListCell

+(instancetype)initWithOCTermListCellWithTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"leftPushCell";
    OCTermListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCTermListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.moreImg = [UIImageView imageViewWithImage:GetImage(@"common_btn_more") frame:CGRectZero];
        self.moreImg.size = CGSizeMake(14*FITWIDTH, 14*FITWIDTH);
        self.moreImg.x = 258*FITWIDTH - 20*FITWIDTH - 14*FITWIDTH;
        self.moreImg.centerY = 24*FITWIDTH;
        self.moreImg.hidden = YES;
        [self.contentView addSubview:self.moreImg];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? RGBA(229, 236, 247, 1) : WHITE;
    self.textLabel.textColor = selected ? kAPPCOLOR : TEXT_COLOR_GRAY;
    self.moreImg.hidden = !selected;

    // Configure the view for the selected state
}

@end
