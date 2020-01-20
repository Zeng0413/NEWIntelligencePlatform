//
//  OCMyListCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCMyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *moreImg;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@end

NS_ASSUME_NONNULL_END
