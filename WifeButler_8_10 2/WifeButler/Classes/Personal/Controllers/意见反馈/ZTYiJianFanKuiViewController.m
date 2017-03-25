//
//  ZTYiJianFanKuiViewController.m
//  YouHu
//
//  Created by zjtd on 16/4/19.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTYiJianFanKuiViewController.h"
#import "ZJLoginController.h"

@interface ZTYiJianFanKuiViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *yiJianLab;


@property (weak, nonatomic) IBOutlet UITextView *textView1;


@property (weak, nonatomic) IBOutlet UIButton *tiJiaoBtn;


@end

@implementation ZTYiJianFanKuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"意见反馈";
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    self.tiJiaoBtn.layer.cornerRadius = 5;
    
    _textView1.delegate = self;
}

#pragma mark - 提交
- (IBAction)yiJianClick:(id)sender {
    
    [self netWorking];
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    self.textView1 = textView;
    
    if ([self.textView1.text length]==0)
    {
        [self.yiJianLab setHidden:NO];
        
    }else
    {
        [self.yiJianLab setHidden:YES];
        self.yiJianLab.text = @"请填写你的建议.意见.投诉等";
        
    }
}

- (void)netWorking
{
    
    if (self.textView1.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"输入不能够为空哦!"];
        return;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.textView1.text forKey:@"texts"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KYiJianFanKui];
    
    ZJLog(@"%@", dic);
        
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"意见提交成功"];
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    self.textView1 = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.view = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
