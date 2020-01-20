//
//  TableViewCell.m
//  MultilevelMenuWithCheckbox
//
//  Created by hyt on 2017/11/2.
//  Copyright © 2017年 hyt. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

@property (nonatomic, strong) MultilevelMenuModel *model;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *openImg;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateByModel:(MultilevelMenuModel *)currentModel {
    self.model = currentModel;
    [self setBaseInfoByDict];
    [self setOpenOrClose];
    [self setSelectState];
}

/**
 Set value with datasource
 */
- (void)setBaseInfoByDict {
    // you can use custom cell instead of UITableViewCell
    NSDictionary *dataDict = self.model.dataDict;
    NSString *blank = @"";
    NSInteger count = 4 * self.model.MMLevel;
    NSInteger x = 10;
    for (int i = 0; i <= count; i++) {
        blank = [blank stringByAppendingString:@" "];
    }
    self.openImg.x = 5*count;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@",blank,dataDict[@"text"]];
}


/**
 Set states by Image
 */
- (void)setOpenOrClose {
    if (self.model.MMSubArray.count == 0) {
        self.openImg.image = [UIImage imageNamed:@""];
    } else if (self.model.MMIsOpen) {
         self.openImg.image = [UIImage imageNamed:@"PlanMiddle_open"];
    } else {
         self.openImg.image = [UIImage imageNamed:@"PlanMiddle_n"];
    }
}

/**
 Set selection state by Image
 */
- (void)setSelectState {
    
    NSString *imageName = @"";
    switch (self.model.MMSelectState) {
        case selectAll:
            imageName = @"course_btn_square_nor";
            [self.dateArr addObject:self.model];
            break;
        case  selectHalf:
            imageName = @"course_btn_square_sel";
            break;
        default:
            imageName = @"course_btn_square_sel";
            break;
    }
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 10, 60, 30);
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}

-(UIImageView *)openImg{
    if (!_openImg) {
        _openImg = [UIImageView imageViewWithImage:GetImage(@"PlanMiddle_n") frame:Rect(13, 13, 20, 20)];
        [self addSubview:_openImg];
    }
    return _openImg;
}


- (void)buttonAction {
    self.dateArr = [NSMutableArray array];
    [DATAHANDLER changModelSelecteState:self.model];
    [self setSelectState];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
