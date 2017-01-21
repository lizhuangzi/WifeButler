//
//  ZTKaiDianAddressViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/20.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTKaiDianAddressViewController.h"
#import "TYAttributedLabel.h"

@interface ZTKaiDianAddressViewController () <TYAttributedLabelDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet TYAttributedLabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *zhangHaoLab;
@property (weak, nonatomic) IBOutlet UILabel *passwordLab;

@end




@implementation ZTKaiDianAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我要开店";
    
    self.addressLab.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 20;
    
    NSString *strText = [NSString stringWithFormat:@"管理地址:http://%@index.php/admin/enter/index", self.phpAddress];
    NSString *linkH5Str = [NSString stringWithFormat:@"http://%@index.php/admin/enter/index", self.phpAddress];
    [self.addressLab appendLinkWithText:strText linkFont:[UIFont systemFontOfSize:14] linkData:linkH5Str];
    self.addressLab.delegate = self;
    self.addressLab.characterSpacing = 2;
    self.addressLab.linesSpacing = 2;
    [self.addressLab sizeToFit];
    


    
    self.zhangHaoLab.text = [NSString stringWithFormat:@"账号:%@", self.zhangHao];
    self.passwordLab.text = [NSString stringWithFormat:@"密码:%@", self.passWord];
}



#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        
        if ([linkStr hasPrefix:@"http:"]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkStr]];
        
        }else {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point
{
    NSLog(@"textStorageLongPressed");
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *linkStr = ((TYLinkTextStorage*)textStorage).linkData;
    pasteboard.string = linkStr;
    
    [SVProgressHUD showSuccessWithStatus:@"拷贝成功"];
    
    ZJLog(@"%@", linkStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
