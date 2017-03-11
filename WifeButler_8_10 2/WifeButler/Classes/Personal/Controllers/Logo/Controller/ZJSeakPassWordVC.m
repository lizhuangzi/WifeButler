//
//  ZJSeakPassWordVC.m
//  BaZhou
//
//  Created by JL on 15/10/8.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

#import "ZJSeakPassWordVC.h"
#import "NSString+ZJMyJudgeString.h"
#import "ZTTiShiKuanView.h"
#import "UIColor+HexColor.h"
@interface ZJSeakPassWordVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;
@property (weak, nonatomic) IBOutlet UITextField *codeFiled;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordFiled1;
@property (weak, nonatomic) IBOutlet UITextField *passWordFiled2;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation ZJSeakPassWordVC
{
    NSString *_code;

    int _timing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.sureButton.backgroundColor = WifeButlerCommonRedColor;
    self.title = @"忘记密码";
    
    self.phoneFiled.delegate = self;
    self.passWordFiled2.delegate = self;
    self.passWordFiled1.delegate = self;
}

- (IBAction)sendCodeBtnClick:(id)sender {
    //发送验证码
    [self getCodeNetWorking];
}
- (IBAction)seakBtnClick:(id)sender {
    
    //找回密码
    [self netWorking];
    
}


+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度6 - 13位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,13}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
    
}

- (void)netWorking
{
    if([self.passWordFiled1.text isEqualToString:self.passWordFiled2.text] != YES)
    {
        [SVProgressHUD showErrorWithStatus:@"二次密码不对"];
        return;
    }
    
    if ([self.class judgePassWordLegal:self.passWordFiled1.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不符合格式"];
        return;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.phoneFiled.text forKey:@"mobile"];
    [dic setObject:self.codeFiled.text forKey:@"captcha"];
    [dic setObject:self.passWordFiled1.text forKey:@"passwd"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KZhaoHui];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            ZTTiShiKuanView *tishiView = [[[NSBundle mainBundle] loadNibNamed:@"ZTTiShiView" owner:self options:nil] firstObject];
            tishiView.backView.alpha = 0.65;
            tishiView.frame = CGRectMake(0, 64, iphoneWidth, iphoneHeight);
            
            UIWindow *wid = [[UIApplication sharedApplication] keyWindow];
            [wid addSubview:tishiView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [tishiView removeFromSuperview];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];

}

//获得验证码接口
- (void)getCodeNetWorking
{
    if ([NSString validateMobile:self.phoneFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.phoneFiled.text forKey:@"mobile"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KZhaoHuiPasswod];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"resultCode"]];
            
            [self timer];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    }];

}

-(void)timer
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.sendCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.sendCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}

// 限制密码的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.passWordFiled1 || textField == self.passWordFiled2) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 13) {
            
            return NO;
        }
    }
    
    if (textField == self.phoneFiled) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 11) {
            
            return NO;
        }
    }
    return YES;
}
@end
