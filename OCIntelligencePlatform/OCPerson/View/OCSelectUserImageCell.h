//
//  OCSelectUserImageCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSelectUserImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *userImageBGV;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (nonatomic, strong) CALayer * shadowLayer;

+ (OCSelectUserImageCell *)creatSelectUserImageCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
