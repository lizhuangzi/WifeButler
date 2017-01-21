//
//  ZTGuangYuMyViewController.m
//  YouHu
//
//  Created by zjtd on 16/4/19.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTGuangYuMyViewController.h"

@interface ZTGuangYuMyViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *xiangQingWenb;

@end

@implementation ZTGuangYuMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    
    [self createUI];
}

- (void)createUI
{
    
    NSString *str = [NSString stringWithFormat:@"%@html5/about", HTTP_BaseURL];
    
    NSURL *loginUrl = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:loginUrl];
    _xiangQingWenb.delegate = self;
    [_xiangQingWenb loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
