//
//  OCSeatButton.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSeatsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCSeatButton : UIButton

/**座位绑定索引，用于判断独坐*/
@property (nonatomic,assign) NSInteger seatIndex;

/**区域名*/
@property (nonatomic, copy) NSString *areaStr;

@property (strong, nonatomic) OCSeatsModel *seatModel;
@end

NS_ASSUME_NONNULL_END
