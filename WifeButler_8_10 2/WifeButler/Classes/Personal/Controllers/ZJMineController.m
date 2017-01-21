//
//  ZJMineController.m
//  Fish
//
//  Created by zjtdmac3 on 15/6/6.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "ZJMineController.h"
#import "ZJLoginController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZTYiJianFanKuiViewController.h"
#import "ZTGuangYuMyViewController.h"
#import "ZTNeiBuGongGao1ViewController.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZTYouHuiJuanViewController.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZTBianJiZiliaoTableViewController.h"
#import "ZTDingDanXiangQingViewController.h"
#import "ZTZhiFuFangShiTableViewController.h"
#import "ZTHuiZhuanPingJiaTableViewController.h"
#import "ZTWoYaoKaiDianTableViewController.h"
#import "ZTShenPiDianPuViewController.h"
#import "ZTKaiDianChengGongViewController.h"
#import "ZTDuiHuanDingDanViewController.h"
#import "UIColor+HexColor.h"
@interface ZJMineController ()
{
    BOOL isLogo;
}

/**
 *  进入资料编辑界面按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *meassgeBtn;


/**
 *  登录注册
 */
@property (weak, nonatomic) IBOutlet UIView *LogoResign;

/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/**
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *iphoneNumber;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

/**
 *  退出登录
 */
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

/**
 *  客服电话
 */
@property (weak, nonatomic) IBOutlet UILabel *KeFuPhone;



@end

@implementation ZJMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    
    [self setParam];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setPersonMessage];
    [self netWorkingPhone];
}

- (void)setPersonMessage
{
    
    if (NSGetUserDefaults(@"token_app") != nil) {
        
        self.LogoResign.hidden = YES;
        self.nameLab.hidden = NO;
        self.meassgeBtn.hidden = NO;
        self.logoutBtn.hidden = NO;
        
        self.nameLab.text = NSGetUserDefaults(@"nickname");
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:NSGetUserDefaults(@"avatar")] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        self.iphoneNumber.text = NSGetUserDefaults(@"mobile");

        
    }
    else
    {
        self.LogoResign.hidden = NO;
        self.nameLab.hidden = YES;
        self.meassgeBtn.hidden = YES;
        self.logoutBtn.hidden = YES;
    }
    
}

#pragma mark - 进入个人编辑资料
- (IBAction)goIntoPersonInfo:(id)sender {
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiInfo" bundle:nil];
    ZTBianJiZiliaoTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTBianJiZiliaoTableViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)createNav
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    
    [self.navigationController.navigationBar setBarTintColor:WifeButlerCommonRedColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (void)setParam
{
    // 设置显示时间
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];

    [self.logoutBtn setBackgroundColor:WifeButlerCommonRedColor];
    self.logoutBtn.layer.cornerRadius = 5;
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2.0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // 我要开店
    if (indexPath.row == 0) {
        
        if (KToken == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
            return;
        }
        
        [self downLoadInfoDiQu];
    }
    
    // 我的
    if (indexPath.row == 1) {
        
        if (KToken == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
            return;
        }
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJMineController" bundle:nil];
        ZTYouHuiJuanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTYouHuiJuanViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 我的兑换
    if (indexPath.row == 2) {
        
        if (KToken == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
            return;
        }
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTDuiHuanDingDan" bundle:nil];
        ZTDuiHuanDingDanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTDuiHuanDingDanViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    // 我的购物车
    if (indexPath.row == 3) {
        
        if (KToken == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
            return;
        }
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGouWuChe" bundle:nil];
        ZTPersonGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTPersonGouWuCheViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 地址管理
    if (indexPath.row == 4) {
        
        if (KToken == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
            return;
        }
        
        ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 关于我们
    if (indexPath.row == 5) {
        
        ZTGuangYuMyViewController *vc = [[ZTGuangYuMyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 意见反馈
    if (indexPath.row == 6) {
        
        if (KToken == nil) {
            
            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
            return;
        }
        
        ZTYiJianFanKuiViewController *vc = [[ZTYiJianFanKuiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    // 我的客服
    if (indexPath.row == 7) {
        


    }
}

#pragma mark - 登录
- (IBAction)logoOnclick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
    vc.isLogo = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 注册
- (IBAction)resigenOnclick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
    vc.isLogo = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 我的订单
- (IBAction)dingDanOnclick:(id)sender {
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
    ZTHuiZhuanDingDan1ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTHuiZhuanDingDan1ViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 我的消息
- (IBAction)messageOnclick:(id)sender {
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    ZTNeiBuGongGao1ViewController *vc = [[ZTNeiBuGongGao1ViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 推出登录
- (IBAction)LogoutOnclick:(id)sender {
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出将无法体验功能" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatar"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_ip"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_time"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_ip"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_time"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mechine"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"salts"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token_app"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_agent"];
        
        _iphoneNumber.text = @"您还没有登录";
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
        ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
        vc.isLogo = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [vc addAction:action];
    [vc addAction:otherAction];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 客服电话
- (IBAction)iPhoneNum:(id)sender {
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"将要拨打电话" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //        ZJMontherFarModel *model = _dataSource1[1];
        NSString *str = [NSString stringWithFormat:@"tel://%@", self.KeFuPhone.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    [vc addAction:action];
    [vc addAction:otherAction];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 开店查询
- (void)downLoadInfoDiQu
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KKaiDianChaXu];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showSuccessWithStatus:@"开店信息查询中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            // 审核中
            if ([responseObject[@"resultCode"][@"pass"] intValue] == 1)
            {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
                ZTShenPiDianPuViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTShenPiDianPuViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                vc.apply_time = responseObject[@"resultCode"][@"apply_time"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            // 审核通过
            if ([responseObject[@"resultCode"][@"pass"] intValue] == 2)
            {
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
                ZTKaiDianChengGongViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTKaiDianChengGongViewController"];
                vc.phpAddress = responseObject[@"resultCode"][@"url"];
                vc.zhangHao = responseObject[@"resultCode"][@"username"];
                vc.passWord = responseObject[@"resultCode"][@"passwd2"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            // 审核不通过
            if ([responseObject[@"resultCode"][@"pass"] intValue] == 3)
            {
                [SVProgressHUD showErrorWithStatus:@"你填写的信息有误,导致店铺未开通成功,请重新填写信息."];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
                ZTWoYaoKaiDianTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTWoYaoKaiDianTableViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else
        {
            if ([responseObject[@"code"] intValue] == 30000) {
                
                [SVProgressHUD dismiss];
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
                ZTWoYaoKaiDianTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTWoYaoKaiDianTableViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
}

#pragma mark - 客服电话
- (void)netWorkingPhone
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KKeFuPhone];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            self.KeFuPhone.text = responseObject[@"resultCode"];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
