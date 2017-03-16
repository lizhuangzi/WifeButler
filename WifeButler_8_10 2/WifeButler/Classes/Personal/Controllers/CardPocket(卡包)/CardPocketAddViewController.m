//
//  CardPocketAddViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketAddViewController.h"
#import "CardPocketAddNextStepController.h"
#import "PersonalPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"

@interface CardPocketAddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *cardPersonNameFiled;
@property (weak, nonatomic) IBOutlet UITextField * identityCardFiled;

@property (weak, nonatomic) IBOutlet UITextField *cardNumFiled;
@end

@implementation CardPocketAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加银行卡";
    self.sureButton.layer.cornerRadius = 5;
    self.sureButton.clipsToBounds = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)sureClick {
    
    if (self.cardNumFiled.text.length < 19) {
        [SVProgressHUD showErrorWithStatus:@"输入卡号不合法"];
        return;
    }
    if (self.cardPersonNameFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人身份"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在验证.."];
    NSDictionary * parm = @{@"bankcard":self.cardNumFiled.text};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KBankCardAffiliate parameter:parm success:^(NSDictionary * resultCode) {
        [SVProgressHUD dismiss];
        
        NSString * bankinfo = resultCode[@"bankinfo"];
        CardPocketAddNextStepController * next  = [[CardPocketAddNextStepController alloc]init];
        next.cardTypeStr = bankinfo;
        [self.navigationController pushViewController:next animated:YES];

    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
}

- (void)textFieldDidChange
{
    if (self.cardNumFiled.isFirstResponder) {
        if (self.cardNumFiled.text.length > 19) {
            self.cardNumFiled.text = [self.cardNumFiled.text substringToIndex:19];
        }
        
        if (self.cardNumFiled.text.length == 19) {
            [self.cardNumFiled resignFirstResponder];
            [self requestBankOwn];
        }
    }
}

- (void)requestBankOwn
{

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
