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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addSuccess) name:CardPocketAddNextStepControllerAddSuccessNotification object:nil];
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
    if (![self isCorrect:self.identityCardFiled.text]) {
        [SVProgressHUD showErrorWithStatus:@"身份证号不正确"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在验证.."];
    NSDictionary * parm = @{@"bankcard":self.cardNumFiled.text};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KBankCardAffiliate parameter:parm success:^(NSDictionary * resultCode) {
        [SVProgressHUD dismiss];
        
        NSString * bankinfo = resultCode[@"bankinfo"];
        CardPocketAddNextStepController * next  = [[CardPocketAddNextStepController alloc]init];
        next.cardTypeStr = bankinfo;
        next.userName = self.cardPersonNameFiled.text;
        next.cardNum = self.cardNumFiled.text;
        next.userIdCard = self.identityCardFiled.text;
        
        [self.navigationController pushViewController:next animated:YES];

    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
}

- (BOOL)isCorrect:(NSString *)IDNumber
{
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    // 余数数组
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:string]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)textFieldDidChange
{
    if (self.cardNumFiled.isFirstResponder) {
        if (self.cardNumFiled.text.length > 19) {
            self.cardNumFiled.text = [self.cardNumFiled.text substringToIndex:19];
        }
        
        if (self.cardNumFiled.text.length == 19) {
            [self.cardNumFiled resignFirstResponder];
        }
    }
}


- (void)addSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
