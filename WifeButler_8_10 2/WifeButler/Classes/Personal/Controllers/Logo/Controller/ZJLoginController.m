//
//  ZJLoginController.m
//  BaZhou
//
//  Created by JL on 15/10/8.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

#import "ZJLoginController.h"
#import "ZTLogoModel.h"
#import "NSString+ZJMyJudgeString.h"
#import  "MJExtension.h"

@interface ZJLoginController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *selectLineView;
@property (weak, nonatomic) IBOutlet UIView *loginBgView;
@property (weak, nonatomic) IBOutlet UITextField *loginPhoneFiled;
@property (weak, nonatomic) IBOutlet UITextField *loginPassWordFiled;
@property (weak, nonatomic) IBOutlet UIButton *topLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *topRegisterBtn;


@property (weak, nonatomic) IBOutlet UIView *registerBgView;
@property (weak, nonatomic) IBOutlet UITextField *registerPhoneFiled;
@property (weak, nonatomic) IBOutlet UITextField *registerPassWordFiled;

@property (weak, nonatomic) IBOutlet UITextField *registerPassWordQueFiled;

@property (weak, nonatomic) IBOutlet UITextField *registerCodeFiled;
@property (weak, nonatomic) IBOutlet UIButton *registerSendCodeBtn;


// 记住密码
@property (weak, nonatomic) IBOutlet UIButton *isRememberPasswrod;


// 是否记住密码
@property (nonatomic, assign) BOOL  isJiZhuPassword;

//登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@end

@implementation ZJLoginController
{
    int _timing;
    
    NSString *_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录/注册";
    
    self.loginPhoneFiled.delegate = self;
    self.loginPassWordFiled.delegate = self;
    
    
    self.registerPhoneFiled.delegate = self;
    self.registerPassWordFiled.delegate = self;
    self.registerPassWordQueFiled.delegate = self;
    
    [self.topLoginBtn setTitleColor:WifeButlerCommonRedColor forState:UIControlStateSelected];
    [self.topRegisterBtn setTitleColor:WifeButlerCommonRedColor forState:UIControlStateSelected];
    [self.topLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.topRegisterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectLineView.backgroundColor = WifeButlerCommonRedColor;
    self.loginButton.backgroundColor = WifeButlerCommonRedColor;
    self.registButton.backgroundColor = WifeButlerCommonRedColor;
    
    [self gunDongXianTiao];
    
    [self getLogoDes];
}

- (void)getLogoDes
{
    
    if ([NSGetUserDefaults(@"isRememberPasswrod") intValue] == 1) {
        
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]) {
            
            _loginPhoneFiled.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) {
            
            _loginPassWordFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            _isRememberPasswrod.selected = YES;
            
        }
    }
}

#pragma mark - 加上0.1秒的延迟，不然会出现滚动线条不滚动
- (void)gunDongXianTiao
{
    // 加上0.1秒的延迟，不然会出现滚动线条不滚动
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if (self.isLogo == YES) {
            
            [self loginBtnClick:nil];
        }
        else
        {
            [self registerBtnClick:nil];
        }
        
    });
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (self.navigationController.viewControllers.count>1) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

- (void)back
{
    if (self.navigationController.viewControllers.count>1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 登录View
- (IBAction)loginBtnClick:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.selectLineView.center = CGPointMake(self.topLoginBtn.center.x, self.selectLineView.center.y);
    }];
    
    //登录显示登录页面
    self.topLoginBtn.selected = YES;
    self.topRegisterBtn.selected = NO;
    
    self.loginBgView.hidden = NO;
    self.registerBgView.hidden = YES;
    [self.registerBgView endEditing:YES];
}

#pragma mark - 注册View
- (IBAction)registerBtnClick:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.selectLineView.center = CGPointMake(self.topRegisterBtn.center.x, self.selectLineView.center.y);
    }];
    
    //注册显示注册页面
    self.topLoginBtn.selected=NO;
    self.topRegisterBtn.selected=YES;
    
    self.loginBgView.hidden=YES;
    self.registerBgView.hidden=NO;
    [self.loginBgView endEditing:YES];
}


- (IBAction)goToLoginClick:(id)sender {
    //登录按钮
    [self loginNetWorking];
}

- (IBAction)goToRegisterClick:(id)sender {
    //注册
    [self registerNetWorking];
}

- (IBAction)registerSendCodeBtnClick:(id)sender {
    //发送验证码
    [self getCodeNetWorking];

}



//登录调用接口
- (void)loginNetWorking
{
    
    if ([NSString validateMobile:self.loginPhoneFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        
        return;
    }
    
    if ([NSString judgePassWordLegal:self.loginPassWordFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不符合格式"];
        return;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.loginPhoneFiled.text forKey:@"mobile"];
    [dic setObject:self.loginPassWordFiled.text forKey:@"passwd"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLogo];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            ZTLogoModel *model = [ZTLogoModel mj_objectWithKeyValues:responseObject[@"resultCode"]];            
            
            [SVProgressHUD dismiss];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
            NSSaveUserDefaults(self.loginPassWordFiled.text, @"password");
            [ud setObject:model.mobile forKey:@"mobile"];
   
            [ud setObject:model.avatar forKey:@"avatar"];
            [ud setObject:model.gender forKey:@"gender"];
            [ud setObject:model.id forKey:@"id"];
            [ud setObject:model.last_ip forKey:@"last_ip"];
            [ud setObject:model.last_time forKey:@"last_time"];
            [ud setObject:model.login_ip forKey:@"login_ip"];
            [ud setObject:model.login_time forKey:@"login_time"];
            [ud setObject:model.mechine forKey:@"mechine"];
            [ud setObject:model.nickname forKey:@"nickname"];
            [ud setObject:model.salts forKey:@"salts"];
            [ud setObject:model.token_app forKey:@"token_app"];
            [ud setObject:model.user_agent forKey:@"user_agent"];
            
            NSSaveUserDefaults(model.jing, @"jing");
            NSSaveUserDefaults(model.wei, @"wei");
            NSSaveUserDefaults(model.village, @"xiaoQu");

            [ud synchronize];
            
            
            if (self.shuaiXinShuJu) {
                
                self.shuaiXinShuJu();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];

}


+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度6 - 12位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
    
}

//注册接口
- (void)registerNetWorking
{
    
    if ([NSString validateMobile:self.registerPhoneFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        
        return;
    }
    
    if ([self.registerPassWordFiled.text isEqualToString:self.registerPassWordQueFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"二次输入的密码不一致"];
        return;
    }
    
    if ([self.class judgePassWordLegal:self.registerPassWordFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不符合格式"];
        
        return;
    }

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.registerPhoneFiled.text forKey:@"mobile"];
    [dic setObject:self.registerCodeFiled.text forKey:@"captcha"];
    [dic setObject:self.registerPassWordFiled.text forKey:@"passwd"];

    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KRegsion];

    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            
            [self loginBtnClick:nil];
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
    if ([NSString validateMobile:self.registerPhoneFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.registerPhoneFiled.text forKey:@"mobile"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KHuoYanZhenMa];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            
//            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"验证码:%@", responseObject[@"resultCode"]]];
            
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

#pragma mark - 记住密码
- (IBAction)jizhuPassword:(id)sender {
    
    self.isRememberPasswrod.selected = !self.isRememberPasswrod.selected;
    
    if (self.isRememberPasswrod.selected == YES) {
        
        NSSaveUserDefaults(@"1", @"isRememberPasswrod");
    }
    else
    {
        
        NSSaveUserDefaults(@"0", @"isRememberPasswrod");
    }
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
                [self.registerSendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.registerSendCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.registerSendCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.registerSendCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}

// 限制密码的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.loginPassWordFiled || textField == self.registerPhoneFiled || textField == self.registerPassWordFiled) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 13) {
            
            return NO;
        }
    }
    
    if (textField == self.loginPhoneFiled || textField == self.registerPhoneFiled) {
        
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
