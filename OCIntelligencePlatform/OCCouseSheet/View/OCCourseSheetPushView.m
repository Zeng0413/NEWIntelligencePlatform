//
//  OCCourseSheetPushView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCCourseSheetPushView.h"

@interface OCCourseSheetPushView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation OCCourseSheetPushView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIView *shadowView = [UIView viewWithBgColor:[UIColor blackColor] frame:self.bounds];
    shadowView.alpha = 0.6;
    shadowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewClick)];
    [shadowView addGestureRecognizer:tapGesture];
    [self addSubview:shadowView];
    
    UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(kViewW - 20*FITWIDTH - 126*FITWIDTH, kNavH, 126*FITWIDTH, 106*FITWIDTH)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4*FITWIDTH;
    [self addSubview:backView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:backView.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.rowHeight = 52*FITWIDTH;
    [backView addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"pushCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *imgArr = @[@"common_btn_scan", @"common_btn_time"];
    NSArray *labArr = @[@"扫一扫", @"日期"];
    cell.imageView.image = GetImage(imgArr[indexPath.row]);
    cell.textLabel.text = labArr[indexPath.row];
    cell.textLabel.font = kFont(16*FITWIDTH);
    cell.textLabel.textColor = TEXT_COLOR_GRAY;
    
    UIView *lineView = [UIView viewWithBgColor:RGBA(245, 245, 245, 1) frame:Rect(12*FITWIDTH, 51*FITWIDTH, cell.contentView.width - 24*FITWIDTH, 1*FITWIDTH)];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    if (self.block) {
        self.block(indexPath.row);
    }
}

-(void)shadowViewClick{
    [self removeFromSuperview];
}
@end
