//
//  OCGroupPersonHeadCollectionViewCell.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/15.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCGroupPersonHeadCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *dataDict;

@property (strong, nonatomic) OCUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
