//
//  newCalenderViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/19.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "newCalenderViewController.h"
#import "FSCalendar.h"
@interface newCalenderViewController ()<FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation newCalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE;
    
    self.calendar = [[FSCalendar alloc] init];
        self.calendar.delegate = self;
        self.calendar.dataSource = self;
        self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        self.calendar.scope = FSCalendarScopeMonth;
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
// For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    [self.view addSubview:self.calendar];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.calendar addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    self.calendar.frame = CGRectMake(0, 0, kViewW, 300);
    [self setupTableView];
    // Do any additional setup after loading the view.
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame), kViewW, kViewH - CGRectGetMaxY(self.calendar.frame))];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}

#pragma mark - FSCalender delegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame), kViewW, kViewH - CGRectGetMaxY(calendar.frame));
    // Do other updates here
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    cell.textLabel.text = @"hello world";
    return cell;
}

@end
