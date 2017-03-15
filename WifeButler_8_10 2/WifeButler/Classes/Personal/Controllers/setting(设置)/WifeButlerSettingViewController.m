//
//  WifeButlerSettingViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/7.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerSettingViewController.h"
#import "masonry.h"
#import "WifeButlerDefine.h"
#import "SettingChangePasswordController.h"
#import "WifeButlerFileManager.h"
#import "WifeButlerDefine.h"
@interface WifeButlerSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView * tableView;

@end

@implementation WifeButlerSettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    
    UIButton * logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    logOutButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [logOutButton setTitleColor:WifeButlerCommonRedColor forState:UIControlStateNormal];
    [logOutButton setBackgroundColor:[UIColor whiteColor]];
    [logOutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    [logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    if (![WifeButlerAccount sharedAccount].isLogin) {
        logOutButton.hidden = YES;
    }
    
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(logOutButton.mas_top);
    }];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView = table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"aaa";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"清除缓存";
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
            label.textAlignment = NSTextAlignmentRight;
            label.text = [WifeButlerFileManager getCacheSize];
            cell.accessoryView =  label;
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"功能介绍";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"当前版本";
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = WifeButlerCommonRedColor;
            cell.accessoryView =  label;
            label.text = @"v1.0";
        }
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SettingChangePasswordController * vc = [[SettingChangePasswordController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            WEAKSELF
            D_CommonAlertShow(@"你确定要清除缓存吗",^{
                [SVProgressHUD showWithStatus:@""];
                [WifeButlerFileManager cleanCache];
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                [weakSelf.tableView reloadData];
            });

        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
        }
    }
}


- (void)logOut
{
    WEAKSELF
    D_CommonAlertShow(@"你确定要退出登录吗", ^{
        //1.首先注销用户单利对象
        [[WifeButlerAccount sharedAccount]loginOffCurrentUser];
        //2.发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:WifeButlerUserDidLogOutNotification object:nil userInfo:@{}];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}
@end
