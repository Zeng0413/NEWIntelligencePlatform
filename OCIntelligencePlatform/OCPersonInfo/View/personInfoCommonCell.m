//
//  personInfoCommonCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "personInfoCommonCell.h"

@interface personInfoCommonCell ()



@end

@implementation personInfoCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImg.layer.cornerRadius = 20;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id)data{
    _data = data;
    
    if ([data isKindOfClass:[NSString class]]) {
        NSString *imageText = data;
        if ([imageText containsString:@"http"]) {
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:imageText] placeholderImage:nil];
        }else {
            self.headImg.image = GetImage(imageText);
        }
    }else if ([data isKindOfClass:[UIImage class]]){
        self.headImg.image = data;
    }
}

@end
