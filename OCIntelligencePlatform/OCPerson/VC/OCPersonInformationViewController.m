//
//  OCPersonInformationViewController.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPersonInformationViewController.h"
#import "OCSelectUserImageCell.h"
#import "OCPersonInfoDefaultCell.h"
#import "OCGetPhotoSheetView.h"
#import "OCForgetPwdViewController.h"
#import "bindingPhoneViewController.h"
#import "OCOldPwdModificationPwdViewController.h"

@interface OCPersonInformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) OCSelectUserImageCell *userHeadImgCell;
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation OCPersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Weak;
    self.ts_navgationBar = [[TSNavigationBar alloc]initWithTitle:@"个人资料" backAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [self setupTableView];
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, kNavH, kViewW, kViewH - kNavH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = kBACKCOLOR;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"OCPersonInfoDefaultCell" bundle:nil] forCellReuseIdentifier:@"OCPersonInfoDefaultCellID"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        OCSelectUserImageCell *cell = [OCSelectUserImageCell creatSelectUserImageCellWith:tableView indexPath:indexPath data:@{}];
        cell.selectionStyle = 0;
        self.userHeadImgCell = cell;
        return cell;
    }else{
        NSArray *titleArr = @[@"手机号",@"密码"];
        NSArray *subtitleArr = @[SINGLE.userModel.phone, @"修改"];
        OCPersonInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCPersonInfoDefaultCellID"];
        cell.titleLab.text = titleArr[indexPath.row-1];
        cell.subtitleLab.text = subtitleArr[indexPath.row-1];
        cell.selectionStyle = 0;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    
        Weak;
        [OCGetPhotoSheetView showPictureforController:self withMaxcount:1 withphoto:^(NSArray * _Nonnull photoDataArray) {
            wself.userHeadImgCell.userImage.image = [photoDataArray firstObject];
            [wself uploadPicWithImg:[photoDataArray firstObject]];
        }];
    }else if (indexPath.row == 1){
        bindingPhoneViewController *vc = [[bindingPhoneViewController alloc] init];
        Weak;
        [vc returnBlock:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        OCOldPwdModificationPwdViewController *vc = [[OCOldPwdModificationPwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}

#pragma mark - 网络请求
-(void)uploadPicWithImg:(UIImage *)userImg{
    userImg = [OCPublicMethodManager reduceImage:userImg percent:0.6];
    NSArray *imgArr = userImg ? @[userImg] : @[];
    
    Weak;
    [APPRequest postImageRequest:NSStringFormat(@"%@/%@v1/file/upload/4",kURL,APICollegeURL) fileName:@"userImg.jpeg" parameter:@{} postImageArray:imgArr success:^(id responseObject) {
        [wself saveUserHeader:responseObject];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } controller:self];
}

-(void)saveUserHeader:(id)headID{
    [APPRequest postRequestWithUrl:NSStringFormat(@"%@/%@v1/user/change/headImg/%@",kURL,APIUserURL,headID) parameters:@{} success:^(id responseObject) {
        NSMutableDictionary *userData = [[NSDictionary bg_valueForKey:@"userInfoData"] mutableCopy];
        userData[@"headImg"] = responseObject;
        [NSDictionary bg_updateValue:userData forKey:@"userInfoData"];
        
        SINGLE.userModel = [OCUserModel objectWithKeyValues:userData];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } viewController:self];
}
@end
