//
//  ZTXiangQinHealthyLifeViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/7.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTXiangQinHealthyLifeViewController.h"

@interface ZTXiangQinHealthyLifeViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *xiangQingWenb;

@end

@implementation ZTXiangQinHealthyLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"详情";
    
    [self createUI];
}

- (void)createUI
{
    
    NSString *str = [NSString stringWithFormat:@"%@goods/article/health_detail?article_id=%@", HTTP_BaseURL, self.id_temp];
    
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
