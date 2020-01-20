//
//  OCClassSheetCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCClassSheetCell.h"

@interface OCClassSheetCell ()
@property (strong, nonatomic) UIView *backView;

@end

@implementation OCClassSheetCell

+(instancetype)initWithOCClassSheetCellTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OCClassSheetCellID";
//    OCClassSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    OCClassSheetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OCClassSheetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kBACKCOLOR;
    }
    return self;
}


-(void)setClassroomModel:(OCClassSheetClassroomModel *)classroomModel{
    _classroomModel = classroomModel;
    
    if (self.backView) {
        return;
    }
    
    self.backView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, self.contentView.height)];
    [self.contentView addSubview:self.backView];
    
    UILabel *titleLab = [UILabel labelWithText:classroomModel.roomCode font:15*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(0, 0, 73*FITWIDTH, 48*FITWIDTH)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kBoldFont(15*FITWIDTH);
    [self.contentView addSubview:titleLab];
    
    UILabel *lastLab = nil;
    CGFloat border = 6*FITWIDTH;
    CGFloat defaultW = (kViewW - MaxX(titleLab) - 20*FITWIDTH - border*5)/6;
    
    NSDate *nowDate = [NSDate date];
    NSInteger nowHourInt = nowDate.br_hour;
    NSInteger nowMinuteInt = nowDate.br_minute;
    NSDate *nowHourDate = [NSDate br_setHour:nowHourInt minute:nowMinuteInt];
    for (int i = 0; i<classroomModel.times.count; i++) {
        OCClassSheetSubject *subjectModel = classroomModel.times[i];
       
        BOOL isNoSubject = NO;
        if (subjectModel.lessonCode.length == 0) {
            isNoSubject = YES;
        }
        
        UILabel *contenLab = [[UILabel alloc] init];
        if (i == 0) {
            contenLab.x = MaxX(titleLab);
        }else{
            contenLab.x = MaxX(lastLab)+border;
        }
        contenLab.y = 0;
        contenLab.height = 48*FITWIDTH;
        if ([subjectModel.mergeSection integerValue] == 1) {
            contenLab.width = (defaultW - border)/2;
        }else if ([subjectModel.mergeSection integerValue] == 2){
            contenLab.width = defaultW;
        }else if ([subjectModel.mergeSection integerValue] == 3){
            contenLab.width = defaultW + border + (defaultW - border)/2;
        }else if ([subjectModel.mergeSection integerValue] == 4){
            contenLab.width = defaultW*2+border;
        }
        contenLab.textAlignment = NSTextAlignmentCenter;
        contenLab.layer.masksToBounds = YES;
        contenLab.layer.cornerRadius = 3*FITWIDTH;
        contenLab.text = isNoSubject ? @"无课" : subjectModel.lessonName;
        contenLab.textColor = WHITE;
        contenLab.font = kFont(12*FITWIDTH);
        contenLab.backgroundColor = isNoSubject ? RGBA(235, 235, 235, 1) : RGBA(141, 188, 255, 1);
        contenLab.layer.borderWidth = 2;
        contenLab.layer.borderColor = contenLab.backgroundColor.CGColor;
        contenLab.numberOfLines = 0;
        
        if (!isNoSubject) {
            NSDictionary *startTimeDict = self.timeArray[[subjectModel.section integerValue]-1];
            NSDictionary *endTimeDict = self.timeArray[[subjectModel.section integerValue]+[subjectModel.mergeSection integerValue]-2];
            NSString *startHourInt = [[startTimeDict[@"kssj"] componentsSeparatedByString:@":"] firstObject];
            NSString *startMinuteInt = [[startTimeDict[@"kssj"] componentsSeparatedByString:@":"] lastObject];
            NSDate *startHourDate = [NSDate br_setHour:[startHourInt integerValue] minute:[startMinuteInt integerValue]];

            NSString *endHourInt = [[endTimeDict[@"jssj"] componentsSeparatedByString:@":"] firstObject];
            NSString *endMinuteInt = [[endTimeDict[@"jssj"] componentsSeparatedByString:@":"] lastObject];
            NSDate *endHourDate = [NSDate br_setHour:[endHourInt integerValue] minute:[endMinuteInt integerValue]];
            NSLog(@"%@",nowHourDate);
            
            if ([OCPublicMethodManager date:nowHourDate isBetweenDate:startHourDate andDate:endHourDate]) {
                contenLab.backgroundColor = RGBA(254, 106, 107, 1);
                contenLab.layer.borderColor = contenLab.backgroundColor.CGColor;
            }
        }
        
        
        contenLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subjectClick:)];
        [contenLab addGestureRecognizer:tapGuest];
        UIView *tapView1 = [tapGuest view];
        tapView1.tag = i;
        [self.contentView addSubview:contenLab];
        
        lastLab = contenLab;
    }
    
}

-(void)subjectClick:(UITapGestureRecognizer *)tapGesture{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tapGesture;
    NSInteger index = singleTap.view.tag;
    OCClassSheetSubject *subjectModel = self.classroomModel.times[index];
    if (subjectModel.lessonCode.length!=0) {
        if ([self.delegate respondsToSelector:@selector(chooseClaseeSheetCourseWithModel:)]) {
            [self.delegate chooseClaseeSheetCourseWithModel:subjectModel];
        }
    }
    
}
@end
