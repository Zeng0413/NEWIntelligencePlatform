//
//  OCMessageNotifCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface OCMessageNotifCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *iconLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
