//
//  OCDefaultClassroomApplyView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCDefaultClassroomApplyViewDelegate <NSObject>

-(void)defaultClassroomSubmitApplyWithApplyClassroomName:(NSString *)classroomName withDateInterval:(NSString *)timeInterval withBorrowTimes:(NSString *)times withReason:(NSString *)reasonStr;

@end

@interface OCDefaultClassroomApplyView : UIView

typedef void(^DefaultClassroomApplyBlock)(NSInteger type);

@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UILabel *applyClassroomLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (copy, nonatomic) DefaultClassroomApplyBlock block;

@property (assign, nonatomic) BOOL isCanBtnClick;

+(OCDefaultClassroomApplyView *)defaultClassroomApplyView;

@property (strong, nonatomic) NSMutableArray *buttons;

-(void)refreshBtnsStatus:(NSArray *)timeStatusArr;

@property (weak, nonatomic) id<OCDefaultClassroomApplyViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
