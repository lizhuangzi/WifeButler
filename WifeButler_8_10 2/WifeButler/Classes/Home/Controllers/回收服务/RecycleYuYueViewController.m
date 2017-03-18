//
//  RecycleYuYueViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "RecycleYuYueViewController.h"
#import "ZTjieSuanModel.h"
#import "UserDeliverLocationReturnView.h"
#import "ZTShouHuoAddressModel.h"
#import "MJExtension.h"
#import "ZJLoginController.h"
#import "ZTXuanZeTimeViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "Masonry.h"

@interface RecycleYuYueViewController ()

{
    ZTjieSuanModel *_model;
    ZTShouHuoAddressModel * _locationModel;
}
@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *timeYuYueLab;

@property (weak, nonatomic) IBOutlet UIButton *phoneNumBtn;
@property (strong, nonatomic) UserDeliverLocationReturnView *userInfoView;

@property (nonatomic,copy)NSString * yuYueTime;
@end

@implementation RecycleYuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self netWorking];
}

- (void)setUpUI
{
    self.title = @"马上预约";
    
    //设置userInfoView
    self.userInfoView = [[NSBundle mainBundle]loadNibNamed:@"UserDeliverLocationReturnView" owner:nil options:nil].lastObject;
    self.userInfoView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.userInfoView setReturnBlock:^{
        
        ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
        vc.isBack = YES;
        
        
        [vc setAddressBlack:^(ZTShouHuoAddressModel *model) {
           
            [weakSelf pushSelectLocationVc];
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.addressView addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressView.mas_top).offset(5);
        make.left.mas_equalTo(self.addressView);
        make.right.mas_equalTo(self.addressView);
        make.bottom.mas_equalTo(self.addressView.mas_bottom).offset(-5);
    }];
    
    
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
}


- (IBAction)chooseTimeClick:(id)sender {
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTTimeXuanZe" bundle:nil];
    ZTXuanZeTimeViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTXuanZeTimeViewController"];
    nav.goods_id = self.goods_id;
    
    __weak typeof(self) weakSelf = self;
    
    [nav setBackTimeBlack:^(NSString *time) {
        
        ZJLog(@"%@", time);
        weakSelf.timeYuYueLab.text = time;
        weakSelf.yuYueTime = time;
    }];
    
    [self.navigationController pushViewController:nav animated:YES];

}

#pragma mark - 请求数据
- (void)netWorking
{
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KMoRenDiZhi];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            
            _model = [ZTjieSuanModel mj_objectWithKeyValues:responseObject[@"resultCode"][@"address"]];
            
            self.userInfoView.hidden = NO;
            
            self.userInfoView.userInfo.text = [NSString stringWithFormat:@"%@ %@ %@",_model.realname,_model.sex,_model.phone];
            
            self.userInfoView.LocationInfo.text = [NSString stringWithFormat:@"%@",_model.address];
            
            [self.phoneNumBtn setTitle:_model.phone forState:UIControlStateNormal];
            
        }
        else
        {
            
            if ([responseObject[@"code"] intValue] == 30000) {
                
                [SVProgressHUD dismiss];
            }
            else
            {
                // 登录失效 进行提示登录
                if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                    
                    [SVProgressHUD dismiss];
                    
                    __weak typeof(self) weakSelf = self;
                    
                    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                        ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                        vc.isLogo = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                    
                    [vc addAction:otherAction];
                    
                    [weakSelf presentViewController:vc animated:YES completion:nil];
                    
                }
                else
                {
                    
                    [SVProgressHUD showErrorWithStatus:message];
                }
                
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}

- (void)pushSelectLocationVc
{
    WEAKSELF;
    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    vc.isBack = YES;
    
    [vc setAddressBlack:^(ZTShouHuoAddressModel *model) {
        _locationModel = model;
        weakSelf.userInfoView.hidden = NO;
        
        weakSelf.userInfoView.userInfo.text = [NSString stringWithFormat:@"%@ %@ %@",model.realname,model.sex,model.phone];
        
        weakSelf.userInfoView.LocationInfo.text = [NSString stringWithFormat:@"%@",model.address];
    }];
    
    [weakSelf.navigationController pushViewController:vc animated:YES];
}
- (IBAction)noLocationClick:(id)sender {
    
    [self pushSelectLocationVc];
}

@end
