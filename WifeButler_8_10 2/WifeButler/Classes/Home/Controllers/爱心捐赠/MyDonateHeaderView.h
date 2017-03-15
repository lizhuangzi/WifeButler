//
//  MyDonateHeaderView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDonateUserModel;

@interface MyDonateHeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic,strong) MyDonateUserModel * model;

@property (nonatomic,copy)void(^returnBlock)(MyDonateUserModel * model);

@end
