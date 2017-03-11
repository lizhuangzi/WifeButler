//
//  inputPayMoneyView.h
//  docClient
//
//  Created by yms on 15/12/16.
//  Copyright © 2015年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^payBlock)(NSString * price);

@interface inputPayMoneyView : UIView

@property (nonatomic,copy)payBlock block;

- (void)showFrom:(UIView *)view;

- (void)inputViewHid;

+ (instancetype)inputMoney;

@end
