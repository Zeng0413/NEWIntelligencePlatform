//
//  OCAcademyClassListViewController.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/20.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickAcademyBlock)(NSInteger index);

@interface OCAcademyClassListViewController : UIViewController

@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) clickAcademyBlock block;
-(void)returnBlock:(clickAcademyBlock)block;
@end

