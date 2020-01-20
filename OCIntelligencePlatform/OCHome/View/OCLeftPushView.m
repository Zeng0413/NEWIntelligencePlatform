//
//  OCLeftPushView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCLeftPushView.h"
#import "OCTermListCell.h"

@interface OCLeftPushView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) UIView *listView;

@end

@implementation OCLeftPushView

+(instancetype)showLeftPushViewWithDataArr:(NSArray *)dataArr withSelectedIndex:(NSInteger)index{
    OCLeftPushView *pushView = [[OCLeftPushView alloc] initWithFrame:Rect(0, 0, kViewW, kViewH)];
    pushView.selectIndex = index;
    pushView.dataArray = dataArr;
    [pushView initWithUI];
    return pushView;
}

-(void)initWithUI{
    UIView *shadowView = [UIView viewWithBgColor:[UIColor blackColor] frame:self.bounds];
    shadowView.alpha = 0.6;
    shadowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewClick)];
    [shadowView addGestureRecognizer:tapGesture];
    [self addSubview:shadowView];
    
    self.listView = [UIView viewWithBgColor:WHITE frame:Rect(-258*FITWIDTH, 0, 258*FITWIDTH, kViewH)];
    [self addSubview:self.listView];
    
    UIView *headView = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, self.listView.width, 70*FITWIDTH)];
    UILabel *lab = [UILabel labelWithText:@"选择学期" font:18*FITWIDTH textColor:TEXT_COLOR_BLACK frame:Rect(16, 0, 100*FITWIDTH, 18*FITWIDTH)];
    lab.centerY = headView.height/2;
    lab.font = kBoldFont(18*FITWIDTH);
    [headView addSubview:lab];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.listView.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 48*FITWIDTH;
    tableView.tableHeaderView = headView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.listView addSubview:tableView];
    
    Weak;
    [UIView animateWithDuration:0.5 animations:^{
        wself.listView.x = 0;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTermListCell *cell = [OCTermListCell initWithOCTermListCellWithTableView:tableView cellForAtIndexPath:indexPath];
    
    OCTermModel *model = self.dataArray[indexPath.row];
    NSString *startStr = NSStringFormat(@"%ld",model.startYear);
    NSString *endStr = NSStringFormat(@"%ld",model.endYear);
    NSString *startTime = [startStr substringFromIndex:startStr.length-2];
    NSString *endTime = [endStr substringFromIndex:endStr.length-2];
    
    cell.textLabel.font = kBoldFont(16*FITWIDTH);
    cell.textLabel.text = NSStringFormat(@"%@-%@%@",startTime,endTime,model.termName);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTermModel *model = self.dataArray[indexPath.row];

    if (self.block) {
        self.block(model);
    }

    Weak;
    [UIView animateWithDuration:0.5 animations:^{
        wself.listView.x = -258*FITWIDTH;
    } completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];
}

-(void)shadowViewClick{
    Weak;
    [UIView animateWithDuration:0.5 animations:^{
        wself.listView.x = -258*FITWIDTH;
    } completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];
}
@end
