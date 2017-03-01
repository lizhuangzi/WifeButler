//
//  LifeLineHeaderView.h
//  PatientClient
//
//  Created by GDXL2012 on 15/7/2.
//  Copyright (c) 2015年 ikuki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocFriendHeaderView : UITableViewHeaderFooterView

@property (readonly, nonatomic) UIImageView *headerImageView;
@property (readonly, nonatomic) UILabel *userNameLabel;
@property (readonly, nonatomic) UIImageView *userBgImageView;

// 点击头像或背景
@property (nonatomic, copy) void (^headerImageViewTapClick)(UITapGestureRecognizer *recognizer);

// 点击消息
@property (nonatomic, copy) void (^tapMessageRecognizerClick)();

/**
 * 返回view高度
 */
+(float)headerViewHeight;

// 有消息时的高度
+(float)headerMessageViewHeight;

/**
 * 返回个人相册高度
 */
+(float)userHeaderViewHeight;

-(void)binWithModel:(id)model;

@end
