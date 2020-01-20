//
//  lectureApplyView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, NotificationType){
    messageType,
    joinType
};

@protocol lectureApplyViewDelegate <NSObject>

-(void)classroomOrDateClickWithType:(NSInteger)type;

-(void)lectureApplySubmitWithLectureName:(NSString *)lectureName withSpeaker:(NSString *)speaker withDec:(NSString *)dec isLive:(NSInteger)liveStatus isSaveVideo:(NSInteger)saveVideoStatus notificationRange:(NSString *)notifRange joinRange:(NSInteger)joinRange withApplyClassroom:(NSString *)classroomName withDateInterval:(NSString *)timeInterval withBorrowTimes:(NSString *)times;
@end

@interface lectureApplyView : UIView

typedef void(^lectureNotificationBlock)(NotificationType type);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifWidthW;

@property (weak, nonatomic) IBOutlet UITextField *lectureNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *speakerTextField;
@property (weak, nonatomic) IBOutlet UITextView *lectureDecTextView;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *notificationRangeLab;
@property (weak, nonatomic) IBOutlet UILabel *joinRangeLab;
@property (weak, nonatomic) IBOutlet UILabel *applyClassroomLab;
@property (weak, nonatomic) IBOutlet UILabel *borrowDateLab;

@property (copy, nonatomic) lectureNotificationBlock notificationBlock;

@property (weak, nonatomic) id<lectureApplyViewDelegate> delegate;
+(lectureApplyView *)creatLectureApplyView;
@property (weak, nonatomic) IBOutlet UIView *timeBackView;

@property (strong, nonatomic) NSMutableArray *buttons;

-(void)refreshBtnsStatus:(NSArray *)timeStatusArr;


@property (assign, nonatomic) BOOL isCanBtnClick;

@end

NS_ASSUME_NONNULL_END
