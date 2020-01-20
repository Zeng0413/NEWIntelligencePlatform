//
//  OCSeatSelectionView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSeatButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCSeatSelectionView : UIView

-(instancetype)initWithFrame:(CGRect)frame seatsArray:(NSArray *)seatsArray seatBtnActionBlock:(void(^)(OCSeatButton *seatBtn))actionBlock;

@end

NS_ASSUME_NONNULL_END
