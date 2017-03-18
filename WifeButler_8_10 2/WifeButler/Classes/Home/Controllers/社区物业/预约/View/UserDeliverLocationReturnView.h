//
//  UserDeliverLocationReturnView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDeliverLocationReturnView : UIView

@property (nonatomic,copy)void(^returnBlock)();

@property (weak, nonatomic) IBOutlet UILabel *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *LocationInfo;

@end
