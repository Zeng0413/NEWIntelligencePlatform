//
//  personInfoCommonCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface personInfoCommonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *subTextField;

@property (strong, nonatomic) id data;
@end

NS_ASSUME_NONNULL_END
