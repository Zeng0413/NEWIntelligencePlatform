//
//  OCSelectUserImageCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCSelectUserImageCell.h"

@implementation OCSelectUserImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImageBGV.cornerRadius = 40;
    self.userImage.cornerRadius = 35;
    
    CALayer * shadowLayer = [UIView creatShadowLayer:Rect(kViewW - 12 - 34 - 80, 30, 80, 80) cornerRadius:40 backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(2, 3) shadowOpacity:0.3 shadowRadius:6];
    [self.contentView.layer insertSublayer:shadowLayer below:self.userImageBGV.layer];
    _shadowLayer = shadowLayer;
    // Initialization code
}

+ (OCSelectUserImageCell *)creatSelectUserImageCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data {
    static NSString * identifier = @"OCSelectUserImageCellID";
    OCSelectUserImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OCSelectUserImageCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = 0;
    
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:SINGLE.userModel.headImg] placeholderImage:nil];
//    id image = data[@"data"];
//    if ([image isKindOfClass:[NSString class]]) {
//        NSString * imageText = image;
//        if ([imageText containsString:@"http"]) {
//            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:imageText] placeholderImage:nil];
//        }else {
//            cell.userImage.image = GetImage(imageText);
//        }
//
//    }else if ([image isKindOfClass:[UIImage class]]) {
//        cell.userImage.image = image;
//    }
    
    return cell;
}

@end
