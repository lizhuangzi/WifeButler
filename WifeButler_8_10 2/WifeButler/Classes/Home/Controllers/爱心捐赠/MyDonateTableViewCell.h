//
//  MyDonateTableViewCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDonateUserlistModel;

@interface MyDonateTableViewCell : UITableViewCell

@property (nonatomic,strong) MyDonateUserlistModel * model;

@property (nonatomic,copy)void(^juankuanblock)( MyDonateUserlistModel * model);

@end
