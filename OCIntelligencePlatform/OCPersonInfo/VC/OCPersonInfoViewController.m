//
//  OCPersonInfoViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPersonInfoViewController.h"
#import "personInfoCommonCell.h"
#import "BRStringPickerView.h"
#import "OCRootViewControllerViewController.h"
#import "OCGetPhotoSheetView.h"
#import "OCClassModel.h"
#import "NSDate+GFCalendar.h"

@interface OCPersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *subTitleArr;

@property (strong, nonatomic) NSArray *academyDataArr;
@property (strong, nonatomic) NSArray *schoolDataArr;
@property (strong, nonatomic) NSArray *classDataArr;
@property (nonatomic, strong) UIImage * userImg;

@property (copy, nonatomic) NSString *headImgId;

@property (strong, nonatomic) id imgData;
@end

@implementation OCPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE;
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc] initWithTitle:@"个人资料" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    NSDictionary *userData = [NSDictionary bg_valueForKey:@"userInfoData"];
    SINGLE.userModel = [OCUserModel objectWithKeyValues:userData];
    if ([SINGLE.userModel.userRole integerValue] == 1) {
        self.titleArr = @[@"头像",@"真实姓名",@"手机号码",@"学校",@"院系",@"部门"];
        self.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                             SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName, SINGLE.userModel.bm.length==0?@"":SINGLE.userModel.bm];
    }else{
        self.titleArr = @[@"头像",@"真实姓名",@"手机号码",@"学校",@"院系",@"入学年份",@"班级",@"学号"];
        self.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                             SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                             SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                             SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                             SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
    }
    
    
    
    [self requsetSchoolListData];
    
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, kViewW, kViewH - kNavH - 112*FITWIDTH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 55;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"personInfoCommonCell" bundle:nil] forCellReuseIdentifier:@"personInfoCommonCellID"];
    [self.view addSubview:self.tableView];
}

-(void)setupFootView{
    UIView *footView = [UIView viewWithBgColor:WHITE frame:Rect(0, kViewH - 112*FITWIDTH, kViewW, 112*FITWIDTH)];
    

    
    UIButton *saveBtn = [UIButton buttonWithTitle:@"保存" titleColor:WHITE backgroundColor:kAPPCOLOR font:16 image:@"" frame:Rect(40*FITWIDTH, 32*FITWIDTH, kViewW-80*FITWIDTH, 48*FITWIDTH)];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 24;
    [footView addSubview:saveBtn];
    
    [self.view addSubview:footView];
}

#pragma mark - action method
-(void)saveClick{
    
    
    if (SINGLE.userModel.userName.length==0 || SINGLE.userModel.phone.length==0 || SINGLE.userModel.school.length==0 || SINGLE.userModel.majorName.length==0 || SINGLE.userModel.time.length==0 || SINGLE.userModel.clazzName.length==0 || SINGLE.userModel.userNumber.length==0) {
        [MBProgressHUD showText:@"请先完善资料"];
        return;
    }
    
    Weak;
    [OCPublicMethodManager checkWordsWithContent:SINGLE.userModel.userName complete:^(id  _Nonnull result) {
        NSArray * illegalList = result[@"sensitiveWordsList"];
        if (illegalList.count > 0) {
            [MBProgressHUD showError:NSStringFormat(@"检测到敏感字符 %@",illegalList[0])];
        }else {
            [wself saveUserData];
        }
    }];
}


-(void)saveUserData{
    if (_userImg) {
        _userImg = [OCPublicMethodManager reduceImage:_userImg percent:0.6];
        NSArray *imageArr = _userImg ? @[_userImg] : @[];
        
        [MBProgressHUD showMessage:@""];
        
        Weak;
        [APPRequest postImageRequest:NSStringFormat(@"%@/%@v1/file/upload/4",kURL,APICollegeURL) fileName:@"userImg.jpeg" parameter:@{} postImageArray:imageArr success:^(id responseObject) {
            wself.headImgId = responseObject;
            NSLog(@"%@",responseObject);
            [wself postData];
        } stateError:^(id responseObject) {
            [MBProgressHUD showText:responseObject[@"msg"]];
        } failure:^(NSError *error) {
        } controller:self];
    }else{
        [self postData];
    }
}

-(void)postData{
    Weak;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clazzId"] = @(SINGLE.userModel.clazzId);
    params[@"clazzName"] = SINGLE.userModel.clazzName;
    params[@"collegeId"] = @(SINGLE.userModel.majorId);
    params[@"collegeName"] = SINGLE.userModel.majorName;
    params[@"enrollmentYear"] = SINGLE.userModel.time;
    params[@"mark"] = @"0";
    params[@"phone"] = SINGLE.userModel.phone;
    params[@"schoolId"] = SINGLE.userModel.schoolId;
    params[@"schoolName"] = SINGLE.userModel.school;
    params[@"userName"] = SINGLE.userModel.userName;
    params[@"userNumber"] = SINGLE.userModel.userNumber;
    params[@"id"] = SINGLE.userModel.userId;
    if (self.headImgId.length>0) {
        params[@"headImgId"] = self.headImgId;
    }
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/save/info",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        [NSDictionary bg_removeValueForKey:@"userInfoData"];
        [OCUserModel handleLoginData:responseObject];
        SINGLE.userModel = [OCUserModel objectWithKeyValues:responseObject];
        [NSDictionary bg_setValue:responseObject forKey:@"userInfoData"];
        OCRootViewControllerViewController *rootTab = [[OCRootViewControllerViewController alloc] init];
        TSNavigationController *tabNav = [[TSNavigationController alloc] initWithRootViewController:rootTab];
        [UIApplication sharedApplication].delegate.window.rootViewController = tabNav;
    } stateError:^(id responseObject) {
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"])
    } failure:^(NSError *error) {
    } viewController:self];
}


#pragma mark - tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    personInfoCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personInfoCommonCellID"];
    if (indexPath.row == 0) {
        cell.data = self.imgData;
        cell.headImg.hidden = NO;
        cell.subTextField.hidden = YES;
    }else{
        cell.headImg.hidden = YES;
        cell.subTextField.hidden = NO;
        cell.subTextField.text = self.subTitleArr[indexPath.row - 1];
    }
    
    if (indexPath.row == 7) {
        cell.subTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row == 2) {
        cell.subTextField.userInteractionEnabled = NO;
    }
    cell.subTextField.delegate = self;
    cell.subTextField.tag = indexPath.row+100;
    cell.titleLab.text = self.titleArr[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        Weak;
        [OCGetPhotoSheetView showPictureforController:self withMaxcount:1 withphoto:^(NSArray * _Nonnull photoDataArray) {
            wself.userImg = [photoDataArray firstObject];
            wself.imgData = [photoDataArray firstObject];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else if (indexPath.row == 3){ //学校
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in self.schoolDataArr) {
            [tempArr addObject:dict[@"name"]];
        }
        Weak;
        [BRStringPickerView showStringPickerWithTitle:@"" dataSource:tempArr defaultSelValue:SINGLE.userModel.majorName resultBlock:^(id selectValue, NSInteger row) {
            
            SINGLE.userModel.school = selectValue;
            wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                  SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                                  SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                  SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                  SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
            if ([self.schoolDataArr[row][@"id"] integerValue] != [SINGLE.userModel.schoolId integerValue]) {
                SINGLE.userModel.majorName = @"";
                SINGLE.userModel.majorId = 0;
                SINGLE.userModel.clazzName = @"";
                SINGLE.userModel.clazzId = 0;
                wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                      SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                                      SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                      SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                      SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
                [wself.tableView reloadData];
            }else{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            SINGLE.userModel.schoolId = self.schoolDataArr[row][@"id"];
        }];
    }else if (indexPath.row == 4){ //学院
        if (SINGLE.userModel.school.length==0) {
            [MBProgressHUD showText:@"请先选择学校"];
            return;
        }
        [self requestAcademyListData];
    }else if (indexPath.row == 5){ //入学年份
        Weak;
        if ([SINGLE.userModel.userRole integerValue] == 1) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int i = 2000; i<=2024; i++) {
                NSString *str = [NSString stringWithFormat:@"%d",i];
                [tempArr addObject:str];
            }
            NSDate *date = [NSDate date];
            NSUInteger year = [date dateYear];
            [BRStringPickerView showStringPickerWithTitle:@"" dataSource:tempArr defaultSelValue:NSStringFormat(@"%ld",year) resultBlock:^(id selectValue, NSInteger row) {
                SINGLE.userModel.time = selectValue;
                SINGLE.userModel.clazzName = @"";
                SINGLE.userModel.clazzId = 0;
                wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                      SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                                      SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                      SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                      SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }else{
            NSLog(@"部门");
        }
        
        
    }else if (indexPath.row == 6){ //班级
        if (SINGLE.userModel.majorName.length == 0) {
            [MBProgressHUD showText:@"请先选择院系"];
            return;
        }
        if (SINGLE.userModel.time.length == 0) {
            [MBProgressHUD showText:@"请先选择年份"];
            return;
        }
        [self requestClassListData];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 36;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView viewWithBgColor:WHITE frame:Rect(0, 0, kViewW, 36)];
    
    UILabel *titleLab = [UILabel labelWithText:@"注意：保存后无法再次修改，请认真填写。" font:12 textColor:kAPPCOLOR frame:Rect(40, 24, kViewW-80, 12)];
    [view addSubview:titleLab];
    
    return view;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSInteger textFieldTag = textField.tag;
    if (textFieldTag == 101 || textFieldTag == 107) {
        [textField addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES;
    }else{
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO;
    }
}

-(void)textFieldEndEdit:(UITextField *)textField{
    NSLog(@"结束编辑：%@",textField.text);
    switch (textField.tag) {
        case 101:
        {
            SINGLE.userModel.userName = textField.text;
        }
            break;
            case 102:
        {
            SINGLE.userModel.phone = textField.text;
        }
            break;
        case 107:{
            SINGLE.userModel.userNumber = textField.text;
        }
        default:
            break;
    }
}

-(void)handlerTextFieldSelect:(UITextField *)textField{
    switch (textField.tag) {
        case 103: // 学校
        {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in self.schoolDataArr) {
                [tempArr addObject:dict[@"name"]];
            }
            Weak;
            [BRStringPickerView showStringPickerWithTitle:@"" dataSource:tempArr defaultSelValue:SINGLE.userModel.majorName resultBlock:^(id selectValue, NSInteger row) {
                
                //            textField.text = SINGLE.userModel.school = selectValue;
                SINGLE.userModel.school = selectValue;
                wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                      SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                                      SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                      SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                      SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
                if ([self.schoolDataArr[row][@"id"] integerValue] != [SINGLE.userModel.schoolId integerValue]) {
                    SINGLE.userModel.majorName = @"";
                    SINGLE.userModel.majorId = 0;
                    SINGLE.userModel.clazzName = @"";
                    SINGLE.userModel.clazzId = 0;
                    wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                          SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                                          SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                          SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                          SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
                    [wself.tableView reloadData];
                }else{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                SINGLE.userModel.schoolId = self.schoolDataArr[row][@"id"];
            }];
            
        }
            break;
            case 104: // 院系
        {
            if (SINGLE.userModel.school.length==0) {
                [MBProgressHUD showText:@"请先选择学校"];
                return;
            }
            [self requestAcademyListData];
        }
            break;
            
            case 105: // 入学年份
        {
            if ([SINGLE.userModel.userRole integerValue] == 1) {
                NSLog(@"部门");
            }else{
                Weak;
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int i = 2000; i<=2024; i++) {
                    NSString *str = [NSString stringWithFormat:@"%d",i];
                    [tempArr addObject:str];
                }
                NSDate *date = [NSDate date];
                NSUInteger year = [date dateYear];
                [BRStringPickerView showStringPickerWithTitle:@"" dataSource:tempArr defaultSelValue:NSStringFormat(@"%ld",year) resultBlock:^(id selectValue, NSInteger row) {
                    //            textField.text = SINGLE.userModel.time = selectValue;
                    SINGLE.userModel.time = selectValue;
                    SINGLE.userModel.clazzName = @"";
                    SINGLE.userModel.clazzId = 0;
                    wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                          SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                                          SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                          SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                          SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                    [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }
            break;
            case 106: // 班级
        {
            if (SINGLE.userModel.majorName.length == 0) {
                [MBProgressHUD showText:@"请先选择院系"];
                return;
            }
            if (SINGLE.userModel.time.length == 0) {
                [MBProgressHUD showText:@"请先选择年份"];
                return;
            }
            [self requestClassListData];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 网络请求
// 请求班级列表
-(void)requestClassListData{
    [MBProgressHUD showMessage:@""];
    Weak;
    
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/clazz/list/%ld/%@",kURL,APIUserURL,SINGLE.userModel.majorId,SINGLE.userModel.time) parameters:nil success:^(id responseObject) {
        wself.classDataArr = [OCClassModel objectArrayWithKeyValuesArray:responseObject];
        [wself showClassPickView];
    } stateError:^(id responseObject) {
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

// 请求学院列表
-(void)requestAcademyListData{
    [MBProgressHUD showMessage:@""];
    NSDictionary *params = @{@"currentPage":@"1", @"pageSize":@"1000", @"schoolId":SINGLE.userModel.schoolId};
    Weak;
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/college/list/all",kURL,APIUserURL) parameters:params success:^(id responseObject) {
        NSArray *tempArr = responseObject[@"pageList"];
        [wself showAcademyPickView:tempArr];
        NSLog(@"%@",responseObject);
    } stateError:^(id responseObject) {
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
    } viewController:self];
}

-(void)requsetSchoolListData{
    Weak;
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/school/list",kURL,APIUserURL) parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [wself setupTableView];
        
        [wself setupFootView];
        wself.schoolDataArr = responseObject;
        [wself.tableView reloadData];
    } stateError:^(id responseObject) {
        [MBProgressHUD hideHUD];

        [MBProgressHUD showError:responseObject[@"msg"]];
        WGHLog2(@"获取验证码失败----%@",responseObject[@"msg"]);
    } failure:^(NSError *error) {
    } viewController:self needCache:NO];
}

#pragma mark --- 自定义方法
-(void)showAcademyPickView:(NSArray *)dataArr{
    Weak;
    [BRAddressPickerView showAcademyPickerWithShowType: BRAcademyPickerMode dataSource:dataArr defaultSelected:nil isAutoSelect:YES themeColor:nil resultBlock:^(BRAcademyModel *academy, BRSubjectModel *subject, BRProfessionModel *profession) {
        NSString *className = [NSString stringWithFormat:@"%@ %@ %@",academy.name,subject.name.length==0?@"":subject.name,profession.name.length==0?@"":profession.name];
        wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                              className.length==0?@"":className,
                              SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                              SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                              SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
        
        if (![className isEqualToString:SINGLE.userModel.majorName]) {
            SINGLE.userModel.clazzName = @"";
            SINGLE.userModel.clazzId = 0;
            wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                                  className.length==0?@"":className,
                                  SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                                  SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                                  SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
            [wself.tableView reloadData];
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (profession.name.length>0) {
            SINGLE.userModel.majorName = profession.name;
            SINGLE.userModel.majorId  = profession.ID;
        }else if (subject.name.length>0){
            SINGLE.userModel.majorName = subject.name;
            SINGLE.userModel.majorId  = subject.ID;
        }else{
            SINGLE.userModel.majorName = academy.name;
            SINGLE.userModel.majorId  = academy.ID;
        }
        
        SINGLE.userModel.majorName = className;
    } cancelBlock:^{
        
    }];
}

-(void)showClassPickView{
    NSMutableArray *tempArr = [NSMutableArray array];
    if (self.classDataArr.count == 0) {
        tempArr = [NSMutableArray arrayWithObjects:@"一班",@"二班",@"三班",@"四班",@"五班",@"六班",@"七班",@"八班",@"九班",@"十班", nil];
    }else{
        for (OCClassModel *model in self.classDataArr) {
            NSString *nameStr = [NSString stringWithString:model.clazzName];
            [tempArr addObject:nameStr];
        }
    }
    
    Weak;
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:tempArr defaultSelValue:nil resultBlock:^(id selectValue, NSInteger row) {
        if (self.classDataArr.count == 0) {
            NSString *classStr = tempArr[row];
            SINGLE.userModel.clazzName = classStr;
            SINGLE.userModel.clazzId = 0;
        }else{
            OCClassModel *model = self.classDataArr[row];
            SINGLE.userModel.clazzName = model.clazzName;
            SINGLE.userModel.clazzId = model.ID;
        }
        
        
        wself.subTitleArr = @[SINGLE.userModel.userName,SINGLE.userModel.phone,SINGLE.userModel.school.length==0?@"": SINGLE.userModel.school,
                              SINGLE.userModel.majorName.length==0?@"":SINGLE.userModel.majorName,
                              SINGLE.userModel.time.length==0?@"":SINGLE.userModel.time,
                              SINGLE.userModel.clazzName.length==0?@"":SINGLE.userModel.clazzName,
                              SINGLE.userModel.userNumber.length==0?@"":SINGLE.userModel.userNumber];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
@end
