//
//  WifeButlerWebViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/5.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerWebViewController.h"
#import "Masonry.h"

@interface WifeButlerWebViewController ()

@property (nonatomic,copy) NSString  * urlStr;

@end

@implementation WifeButlerWebViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr
{
    if (self = [super init]) {
        self.urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载web
    [self loadwebView];
    
}


- (void)loadwebView
{
    if (!self.urlStr)
        return;
    UIWebView * webView = [[UIWebView alloc]init];
    [self.view addSubview:webView];
    NSURL * url = [NSURL URLWithString:self.urlStr];
    NSURLRequest * reuqest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:reuqest];
    webView.delegate = self;
    _webView = webView;
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

@end
