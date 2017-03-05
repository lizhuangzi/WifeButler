//
//  WifeButlerWebViewController.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/5.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifeButlerWebViewController : UIViewController<UIWebViewDelegate>

- (instancetype)initWithUrlStr:(NSString *)urlStr;

@property (nonatomic,weak) UIWebView * webView;

@end
