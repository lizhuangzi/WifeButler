//
//  CardPocketAddViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketAddViewController.h"
#import "PersonalPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"

@interface CardPocketAddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *cardPersonNameFiled;
@property (weak, nonatomic) IBOutlet UITextField *cardNumNameFiled;

@property (weak, nonatomic) IBOutlet UITextField *ownerBankView;
@end

@implementation CardPocketAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加银行卡";
    self.ownerBankView.enabled = NO;
    self.sureButton.layer.cornerRadius = 5;
    self.sureButton.clipsToBounds = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)sureClick {
    
    if (self.cardNumNameFiled.text.length < 19) {
        [SVProgressHUD showErrorWithStatus:@"输入卡号不合法"];
        return;
    }
    if (self.cardPersonNameFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人身份"];
        return;
    }
    
}

- (void)textFieldDidChange
{
    if (self.cardNumNameFiled.isFirstResponder) {
        if (self.cardNumNameFiled.text.length > 19) {
            self.cardNumNameFiled.text = [self.cardNumNameFiled.text substringToIndex:19];
        }
        
        if (self.cardNumNameFiled.text.length == 19) {
            [self.cardNumNameFiled resignFirstResponder];
            [self requestBankOwn];
        }
    }
}

- (void)requestBankOwn
{
    NSDictionary * parm = @{@"bankcard":self.cardNumNameFiled.text};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KBankCardAffiliate parameter:parm success:^(NSDictionary * resultCode) {
        
        NSString * bankinfo = resultCode[@"bankinfo"];
        self.ownerBankView.text = bankinfo;
        
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
