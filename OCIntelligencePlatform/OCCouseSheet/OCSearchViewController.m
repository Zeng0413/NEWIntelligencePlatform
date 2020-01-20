//
//  OCSearchViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/13.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCSearchViewController.h"
#import "OCSearchCourseSheetModel.h"
#import "OCCourseSheetSearchCell.h"
#import "OCClassroomDetailViewController.h"
@interface OCSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, OCCourseSheetSearchCellDelegate>
@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *searchSheetArr;

@property (weak, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UITextField *searchTextField;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@end

@implementation OCSearchViewController

-(NSMutableArray *)searchSheetArr{
    if (!_searchSheetArr) {
        _searchSheetArr = [NSMutableArray array];
    }
    return _searchSheetArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBACKCOLOR;
    
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle_:@""];
    
    self.ts_navgationBar.backgroundColor = kBACKCOLOR;

    [self setupSearchTopView];
    
    [self setupTableView];

    self.page = 1;
    self.totalPage = 1;
    // Do any additional setup after loading the view.
}

#pragma mark - view figure
-(void)setupSearchTopView{
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kAPPCOLOR backgroundColor:CLEAR font:14 image:@"" frame:CGRectZero];
    [cancelBtn addTarget:self action:@selector(cancelClick)];
    cancelBtn.size = CGSizeMake(26+20+11, 26);
    cancelBtn.x = kViewW - cancelBtn.width;
    cancelBtn.y = kStatusH + 12;
    [self.ts_navgationBar addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    UIView *searchBackView = [UIView viewWithBgColor:WHITE frame:CGRectZero];
    searchBackView.x = 20*FITWIDTH;
    searchBackView.width = CGRectGetMinX(cancelBtn.frame) - 11*FITWIDTH - 20*FITWIDTH;
    searchBackView.height = 30;
    searchBackView.centerY = cancelBtn.centerY;
    searchBackView.layer.masksToBounds = YES;
    searchBackView.layer.cornerRadius = 3;
    searchBackView.userInteractionEnabled = YES;
    [self.ts_navgationBar addSubview:searchBackView];
    
    UIImageView *searchIconImg = [UIImageView imageViewWithImage:GetImage(@"common_btn_search") frame:CGRectZero];
        searchIconImg.x = 12*FITWIDTH;
        searchIconImg.size = CGSizeMake(14*FITWIDTH, 14*FITWIDTH);
        searchIconImg.centerY = searchBackView.height/2;
        [searchBackView addSubview:searchIconImg];

    self.searchTextField = [[UITextField alloc] initWithFrame:Rect(MaxX(searchIconImg)+7*FITWIDTH, 0, searchBackView.width - (MaxX(searchIconImg)+7*FITWIDTH), searchBackView.height)];
    [self.searchTextField becomeFirstResponder];
    self.searchTextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    self.searchTextField.delegate=self;
    self.searchTextField.placeholder = @"搜索";
    self.searchTextField.font = kFont(14);
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBackView addSubview:self.searchTextField];
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH)];
    tableView.backgroundColor = kBACKCOLOR;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    UIView *footView = [UIView viewWithBgColor:kBACKCOLOR frame:Rect(0, 0, kViewW, 15*FITWIDTH)];
    tableView.tableFooterView = footView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticePullRefresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeDropRefresh)];
    
  
    NSString *isHasNetWorking = [kUserDefaults valueForKey:kNetWorkAlertStr];


    if ([isHasNetWorking integerValue] == 1) {
        tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_two" titleStr:@"目前没有相关课程" detailStr:@"请好好预习和复习哦~"];
    }else{
        tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"common_img_one" titleStr:@"哎呀，您的网络还在沉睡中" detailStr:@"请找个开阔的的地方再试试哦～"];
    }
    
    
    tableView.ly_emptyView.detailLabFont = kFont(11);
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;

}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchSheetArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCCourseSheetSearchCell *cell = [OCCourseSheetSearchCell initOCCourseSheetSearchCellWithTableView:tableView cellForAtIndexPath:indexPath];
    cell.sheetModel = self.searchSheetArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200*FITWIDTH;
}

#pragma mark - cell delegate
-(void)courseSheetLookWithModel:(OCSearchCourseSheetModel *)model{
    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/timetable/%@",kURL,APICollegeURL,model.ID) parameters:@{}
                          success:^(id responseObject) {
                              BOOL flag = [OCPublicMethodManager checkUserPermission:OCUserPermissionCourseSheetDetail];
                              if (flag) {
                                  OCClassroomDetailViewController *vc = [[OCClassroomDetailViewController alloc] init];
                                  vc.currentCourseSheetArr = responseObject;
                                  [wself.navigationController pushViewController:vc animated:YES];
                              }else{
                                  [MBProgressHUD showText:PermissionAlertString];
                              }
                          } stateError:^(id responseObject) {
                          } failure:^(NSError *error) {
                          } viewController:self needCache:NO];
}

-(void)courseSheetCollectWithModel:(OCSearchCourseSheetModel *)model withForCell:(OCCourseSheetSearchCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [MBProgressHUD showMessage:@""];
    if (model.isCollect == 0) { // 收藏课表
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"code"] = model.courseCode;
        params[@"name"] = model.name;
        params[@"tbId"] = model.ID;
        Weak;
        [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/collect/timetable",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
            if (responseObject) {
                if (model.isCollect == 0) {
                    model.isCollect = 1;
                }else{
                    model.isCollect = 0;
                }
                [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            NSLog(@"%@",responseObject);
        } stateError:^(id responseObject) {
        } failure:^(NSError *error) {
        } viewController:self];
    }else{ // 取消收藏课表
        Weak;
        [APPRequest deleteRequestWithURLStr:NSStringFormat(@"%@/%@v1/collect/timetable/%@",kURL,APICollegeURL,model.ID) paramDic:@{} success:^(id responseObject) {
            if (responseObject) {
                if (model.isCollect == 0) {
                    model.isCollect = 1;
                }else{
                    model.isCollect = 0;
                }
                [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            NSLog(@"%@",responseObject);
        } error:^(id responseObject) {
        } failure:^(NSError *error) {
        } controller:self];
    }
    
}

#pragma mark - UITextField实时监听获取输入内容，中文状态去除预输入拼音
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        self.page = 1;
        [self requestSearchCourseSheetData:textField.text];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.page = 1;
    [self requestSearchCourseSheetData:textField.text];
}

#pragma mark - action method
-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)noticePullRefresh{
    self.page = 1;
    [self requestSearchCourseSheetData:self.searchTextField.text];
}

- (void)noticeDropRefresh {
    _page ++;
    if (_page > _totalPage) {
        _page --;
        SLEndRefreshing(_tableView);
        return;
    }
    [self requestSearchCourseSheetData:self.searchTextField.text];
    
}

#pragma mark - 网络请求
-(void)requestSearchCourseSheetData:(NSString *)contentStr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = NSStringFormat(@"%ld",_page);
    params[@"pageSize"] = @"20";
    params[@"keyword"] = contentStr;
    
//    [MBProgressHUD showMessage:@""];
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/timetable/search",kURL,APICollegeURL) parameters:params success:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
        NSArray *list = [OCSearchCourseSheetModel objectArrayWithKeyValuesArray:responseObject[@"pageList"]];
        if (wself.page == 1) {
            [wself.searchSheetArr removeAllObjects];
        }
        wself.totalPage = [responseObject[@"totalPage"] integerValue];
        if (wself.page >= wself.totalPage) {
            wself.tableView.mj_footer.hidden = YES;
        }else{
            wself.tableView.mj_footer.hidden = NO;
        }
        [wself.searchSheetArr addObjectsFromArray:list];
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        SLEndRefreshing(wself.tableView);
    } failure:^(NSError *error) {
        SLEndRefreshing(wself.tableView);
    } viewController:self];
}

@end
