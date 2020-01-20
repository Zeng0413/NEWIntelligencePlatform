//
//  TreeTableViewViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/18.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^chooseCompleteBlock)(NSArray *dataArr, NSInteger allSchool);

@interface TreeTableViewViewController : UIViewController
@property (copy, nonatomic) chooseCompleteBlock block;
-(void)returnBlock:(chooseCompleteBlock)block;
@end

NS_ASSUME_NONNULL_END
