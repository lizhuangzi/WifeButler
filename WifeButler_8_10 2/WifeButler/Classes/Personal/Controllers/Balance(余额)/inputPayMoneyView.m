//
//  inputPayMoneyView.m
//  docClient
//
//  Created by yms on 15/12/16.
//  Copyright © 2015年 luo. All rights reserved.
//

#import "inputPayMoneyView.h"
#import "PlaceHoderText.h"
#import "UIImage+ColorExistion.h"

@interface inputPayMoneyView ()
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet PlaceHoderText *moneyTextView;

@property (weak, nonatomic) IBOutlet UILabel *AgreeMentattributeText;


//背景黑色
@property (nonatomic,weak)UIView * backCover;

@end

@implementation inputPayMoneyView

+ (instancetype)inputMoney
{
    return [[NSBundle mainBundle]loadNibNamed:@"inputPayMoneyView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnPay setBackgroundImage:[UIImage imageWithColor:WifeButlerCommonRedColor size:self.btnPay.size] forState:UIControlStateNormal];
    self.btnPay.layer.cornerRadius = 5;
    self.btnPay.clipsToBounds = YES;
    
    NSString * preViousStr = @"同意支付条款, 查看支付协议";
    NSRange range = [preViousStr rangeOfString:@","];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString: preViousStr];
    
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(range.location+1, preViousStr.length - range.location-1)];
    
    self.AgreeMentattributeText.attributedText = str;
}

#pragma mark - 通知
- (void)keyBoardshow:(NSNotification *)notify
{
    CGFloat keyBoardH = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (duration <=0) {
        duration = 0.25;
    }
    
    [UIView animateWithDuration:duration animations:^{
      
        self.y = iphoneHeight - keyBoardH - self.height-64;
    }];
}

- (void)keyBoardHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.backCover.alpha = 0;
        [self.backCover removeFromSuperview];
        self.y = iphoneHeight;
    }];
}


- (void)showFrom:(UIView *)view
{
    UIButton * backCover = [UIButton buttonWithType:UIButtonTypeCustom];
    backCover.backgroundColor = [UIColor blackColor];
    backCover.frame = view.bounds;
    backCover.alpha = 0;
    [backCover addTarget:self action:@selector(inputViewHid) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backCover];
    self.backCover = backCover;
    
    [view addSubview:self];
    self.frame = CGRectMake(0, view.height, view.width, 230);
    
    [UIView animateWithDuration:0.7 animations:^{
       
        backCover.alpha = 0.5;
        self.y -= 230;
    }];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //键盘通知
    [center addObserver:self selector:@selector(keyBoardshow:) name:UIKeyboardWillShowNotification object:nil];
    
    [center addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)inputViewHid
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.7 animations:^{
        self.y = iphoneHeight + self.height;
        self.backCover.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.backCover removeFromSuperview];
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - 支付按钮点击
- (IBAction)payClick:(UIButton *)sender
{
    if (self.block) {
        self.block(self.moneyTextView.text);
    }
}
- (IBAction)agreeClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        self.btnPay.enabled = YES;
    }else
    {
        self.btnPay.enabled = NO;
    }
}

- (void)setfixedmoney:(NSString *)money
{
    self.moneyTextView.editable = NO;
    self.moneyTextView.text = money;
    self.moneyTextView.placeHoderLabel.hidden = YES;
    self.moneyTextView.textColor = WifeButlerCommonRedColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
