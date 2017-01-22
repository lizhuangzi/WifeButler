//
//  ZTHuiZhuanPingJiaTableViewController.m
//  YouHu
//
//  Created by ZT on 16/5/3.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTHuiZhuanPingJiaTableViewController.h"
#import "UIImageView+Del.h"
#import "ZYQAssetPickerController.h"
#import "ZJLoginController.h"

@interface ZTHuiZhuanPingJiaTableViewController ()<UITextViewDelegate, UIActionSheetDelegate,  UINavigationControllerDelegate>

{
    UIButton *btn;
    
    UIScrollView *src;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UIButton *xinxin1;
@property (weak, nonatomic) IBOutlet UIButton *xinxin2;
@property (weak, nonatomic) IBOutlet UIButton *xinxin3;
@property (weak, nonatomic) IBOutlet UIButton *xinxin4;
@property (weak, nonatomic) IBOutlet UIButton *xinxin5;


@property (nonatomic, strong) NSArray *mArr;


@property (weak, nonatomic) IBOutlet UIButton *tiJiaoBtn;
@property (weak, nonatomic) IBOutlet UITextView *desTextV;
@property (weak, nonatomic) IBOutlet UILabel *haoPinLab;

@property (nonatomic, assign) int tempStar;

@end

@implementation ZTHuiZhuanPingJiaTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"评论";
    
    _tempStar = 1;
    
    self.tiJiaoBtn.layer.cornerRadius = 5;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.icon] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    self.titleLab.text = self.titleTemp;
}



- (IBAction)xinxinOnClick:(id)sender {
    
    
    UIButton *btn11 = sender;
    int i = (int)btn11.tag;
    
    switch (i) {
        case 1:
        {
            _xinxin1.selected = YES;
            _xinxin2.selected = NO;
            _xinxin3.selected = NO;
            _xinxin4.selected = NO;
            _xinxin5.selected = NO;
            
            _tempStar = 1;
        }
            break;
        case 2:
        {
            _xinxin1.selected = YES;
            _xinxin2.selected = YES;
            _xinxin3.selected = NO;
            _xinxin4.selected = NO;
            _xinxin5.selected = NO;
            
            _tempStar = 2;
        }
            break;
        case 3:
        {
            _xinxin1.selected = YES;
            _xinxin2.selected = YES;
            _xinxin3.selected = YES;
            _xinxin4.selected = NO;
            _xinxin5.selected = NO;
            
            _tempStar = 3;
        }
            break;
        case 4:
        {
            _xinxin1.selected = YES;
            _xinxin2.selected = YES;
            _xinxin3.selected = YES;
            _xinxin4.selected = YES;
            _xinxin5.selected = NO;
            
            _tempStar = 4;
        }
            break;
        case 5:
        {
            _xinxin1.selected = YES;
            _xinxin2.selected = YES;
            _xinxin3.selected = YES;
            _xinxin4.selected = YES;
            _xinxin5.selected = YES;
            
            _tempStar = 5;
        }
            break;
            
        default:
            break;
    }
    
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    self.desTextV = textView;
    
    if ([self.desTextV.text length]==0)
    {
        [self.haoPinLab setHidden:NO];
    }else
    {
        [self.haoPinLab setHidden:YES];
        self.haoPinLab.text = @"亲！给个好评";
    }
}

#pragma mark - 数据请求
- (void)netWorkingYype
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.goods_id forKey:@"goods_id"];
    [dic setObject:@(_tempStar) forKey:@"star"];
    [dic setObject:self.desTextV.text forKey:@"text"];
    [dic setObject:self.order_id forKey:@"order_id"];
    
    NSString *url;
    
    if ([self.shop_id intValue] == 0) {
        
        url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiChuLiQiPingJiaDingDan];
    }
    else
    {
        url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KPingJiaShop];
    }
    
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            
            if (self.shuaiXinBlack) {
                
                self.shuaiXinBlack();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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
                    [vc setShuaiXinShuJu:^{
                        
                        [self netWorkingYype];
                    }];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}



- (IBAction)pingLunClick:(id)sender {
    
    [self netWorkingYype];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
