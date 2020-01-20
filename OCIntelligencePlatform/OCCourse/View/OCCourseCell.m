//
//  OCCourseCell.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseCell.h"

@interface OCCourseCell ()

@property (weak, nonatomic) UILabel *titleLab;
@property (weak, nonatomic) UILabel *subTitleLab;

@end

@implementation OCCourseCell

+(instancetype)initWithCourseTableView:(UITableView *)tableView cellForAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"courseCellID";
    OCCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[OCCourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *title = [UILabel labelWithText:@"" font:18 textColor:TEXT_COLOR_BLACK frame:Rect(20, 27*FITWIDTH, 100, 18*FITWIDTH)];
        [self.contentView addSubview:title];
        self.titleLab = title;
        
        UILabel *subTitle = [UILabel labelWithText:@"" font:16 textColor:TEXT_COLOR_BLACK frame:Rect(kViewW - 20 - 150, 28*FITWIDTH, 150, 16*FITWIDTH)];
        subTitle.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:subTitle];
        self.subTitleLab = subTitle;
        
    }
    return self;
}

-(void)setDataModel:(OCCourseLessonModel *)dataModel{
    _dataModel = dataModel;
    
    self.titleLab.text = dataModel.name;
    self.subTitleLab.textColor = TEXT_COLOR_BLACK;
    if (dataModel.taught == 0) {
        self.subTitleLab.text = @"";
    }else if (dataModel.taught == 1){
        self.subTitleLab.textColor = kAPPCOLOR;
        self.subTitleLab.text = @"正在上课";
    }else{
        self.subTitleLab.text = [NSString formateDate:dataModel.takeTime];
    }
}

@end
