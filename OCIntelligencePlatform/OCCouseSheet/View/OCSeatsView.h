//
//  OCSeatsView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSeatButton.h"
#import "OCSeatsAreaView.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCSeatsView : UIView

/**  seatsArray座位数组 maxW默认最大座位父控件的宽度 actionBlock按钮点击回调－>传回是当前选中的按钮和全部可选的座位*/

-(instancetype)initWithSeatsArray:(NSArray *)seatsArray
                    maxNomarHeight:(CGFloat)maxH
               seatBtnActionBlock:(void(^)(OCSeatButton *seatBtn, OCSeatsAreaView *seatsAreaView))actionBlock;

@end

NS_ASSUME_NONNULL_END
