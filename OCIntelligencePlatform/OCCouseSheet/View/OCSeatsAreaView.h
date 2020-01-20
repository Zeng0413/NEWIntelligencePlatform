//
//  OCSeatsAreaView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSeatButton.h"
#import "OCSeatsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCSeatsAreaView : UIView

@property (nonatomic,copy) void (^actionBlock)(OCSeatButton *seatBtn);

@property (nonatomic,assign) CGFloat superViewH;


-(void)setupUIWithAreaTag:(NSInteger)areaTag withSeatModel:(NSArray *)seatsArr;
@end

NS_ASSUME_NONNULL_END
