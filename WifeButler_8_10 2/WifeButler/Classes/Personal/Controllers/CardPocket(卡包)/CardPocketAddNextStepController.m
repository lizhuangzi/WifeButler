//
//  CardPocketAddNextStepController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/16.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketAddNextStepController.h"
#import "WifeButlerDefine.h"
#import "WifeButlerNetWorking.h"
#import "PersonalPort.h"
#import "NSString+ZJMyJudgeString.h"

@interface CardPocketAddNextStepController ()
@property (weak, nonatomic) IBOutlet UITextField *cardTypeView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumeFiled;

@property (weak, nonatomic) IBOutlet UITextField *checkNumFiled;
@property (nonatomic,weak)IBOutlet UIButton * registerSendCodeBtn;

@end

@implementation CardPocketAddNextStepController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cardTypeView.text = self.cardTypeStr;

}

NSString * const CardPocketAddNextStepControllerAddSuccessNotification = @"CardPocketAddNextStepControllerAddSuccessNotification";

#pragma mark - 调取添加接口
- (IBAction)sureClick:(id)sender {
    
    if ([NSString validateMobile:self.phoneNumeFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        
        return;
    }
    
    if (self.checkNumFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输正确的验证码"];
        
        return;
    }

    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"phone"] = self.phoneNumeFiled.text;
    parm[@"username"] = self.userName;
    parm[@"token"] = KToken;
    parm[@"userid"] = KUserId;
    parm[@"bankname"] = self.cardTypeStr;
    parm[@"bankcard"] = self.cardNum;
    parm[@"idcard"] = self.userIdCard;
    parm[@"rand"] = self.checkNumFiled.text;
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KBindingCard parameter:parm success:^(id resultCode) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:CardPocketAddNextStepControllerAddSuccessNotification object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
    
}

- (IBAction)sendCheckCodeClick {
    
    [self getCodeNetWorking];
}

//获得验证码接口
- (void)getCodeNetWorking
{
    if ([NSString validateMobile:self.phoneNumeFiled.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.phoneNumeFiled.text forKey:@"phone"];
    
    NSString *url = KBankVerifyMessage;
    
    [manager POST:url parameters:dic constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"massage"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
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


@end
