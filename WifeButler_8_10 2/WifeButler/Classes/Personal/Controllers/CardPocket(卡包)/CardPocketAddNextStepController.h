//
//  CardPocketAddNextStepController.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/16.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardPocketAddNextStepController : UIViewController


UIKIT_EXTERN NSString * const CardPocketAddNextStepControllerAddSuccessNotification;

@property (nonatomic,copy)NSString * cardTypeStr;
@property (nonatomic,copy)NSString * userName;
@property (nonatomic,copy)NSString * cardNum;
//身份证
@property (nonatomic,copy)NSString * userIdCard;
@end
