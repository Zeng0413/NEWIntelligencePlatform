//
//  OCTodayLiveListCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/27.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface OCTodayLiveListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentBGV;
@property (weak, nonatomic) IBOutlet UIImageView *liveImage;

@property (weak, nonatomic) IBOutlet UILabel *liveHeadTitle;
@property (weak, nonatomic) IBOutlet UILabel *liveTitle;
@property (weak, nonatomic) IBOutlet UIButton *watchCount;
@property (weak, nonatomic) IBOutlet UIImageView *liveStaticImage;
@property (weak, nonatomic) IBOutlet UIWebView *liveAnimationImage;

+ (OCTodayLiveListCell *)creatLiveListCellWith:(UITableView *)tableView data:(NSArray *)data index:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
