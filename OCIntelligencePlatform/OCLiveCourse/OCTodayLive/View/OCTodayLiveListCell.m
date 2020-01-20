//
//  OCTodayLiveListCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/27.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCTodayLiveListCell.h"
#import "OCLiveVideoModel.h"

@implementation OCTodayLiveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentBGV.layer.masksToBounds = YES;
    self.contentBGV.layer.cornerRadius = 8;
    
    _liveTitle.textColor = RGBA(255, 255, 255, 0.8);
    _watchCount.titleColor = _liveTitle.textColor;
    
    CALayer * shadowLayer = [UIView creatShadowLayer:Rect(30, 10, kViewW - 60, (kViewW - 60) * 0.56) cornerRadius:_contentBGV.cornerRadius backgroundColor:WHITE shadowColor:TEXT_COLOR_GRAY shadowOffset:CGSizeMake(0, 1) shadowOpacity:0.5 shadowRadius:3];
    [self.contentView.layer insertSublayer:shadowLayer below:_contentBGV.layer];
    
    self.liveAnimationImage.contentMode = UIViewContentModeScaleToFill;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"live_icon" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    [self.liveAnimationImage loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.liveAnimationImage setBackgroundColor:CLEAR];
    self.liveAnimationImage.opaque = NO;
    self.contentView.backgroundColor = kBACKCOLOR;
}

+ (OCTodayLiveListCell *)creatLiveListCellWith:(UITableView *)tableView data:(NSArray *)data index:(NSIndexPath *)indexPath {
    static NSString * identifier = @"OCTodayLiveListCellID";
    OCTodayLiveListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [OCTodayLiveListCell creatViewFromNib];
    }
    cell.selectionStyle = 0;
    
    if (data.count>0) {
        OCLiveVideoModel *liveModel = data[indexPath.row];
        
        cell.liveImage.backgroundColor = TEXT_COLOR_GRAY;
        [cell.liveImage sd_setImageWithURL:[NSURL URLWithString:NSStringFormat(@"%@",liveModel.coverUri)] placeholderImage:GetImage(@"live_img_default")];
        cell.liveStaticImage.hidden = YES;
        cell.liveAnimationImage.hidden = NO;
        //    [cell.liveImage sd_setImageWithURL:[NSURL URLWithString:[WGHPublicMethod changeUrlForillegalityStr:NSStringFormat(@"%@",dic[@"imageUrl"])]] placeholderImage:kDefaultImg];
        //        if (type == 1) {
        //            cell.liveStatus.text = @"正在直播";
        //            cell.liveStatus.backgroundColor = kAPPCOLOR;
        //            cell.liveStaticImage.hidden = YES;
        //            cell.liveAnimationImage.hidden = NO;
        //        }else if(type == 2){
        //            cell.liveStatus.text = @"直播回放";
        //            cell.liveStatus.backgroundColor = WHITE;
        //            cell.liveStaticImage.hidden = NO;
        //            cell.liveAnimationImage.hidden = YES;
        //        }
        
        cell.liveHeadTitle.text = liveModel.title;
        cell.liveTitle.text = liveModel.speaker;
        
        cell.watchCount.title = NSStringFormat(@"观看人数：%@",@"92");
    }
    
    return cell;
}

@end
