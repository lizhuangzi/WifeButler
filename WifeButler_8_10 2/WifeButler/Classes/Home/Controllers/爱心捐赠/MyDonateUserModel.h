//
//  MyDonateUserModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface MyDonateUserModel : NSObject

@property (nonatomic,copy)NSString * nickname;

@property (nonatomic,copy)NSString * avatar;

@property (nonatomic,copy)NSString * sum;


@property (nonatomic,strong) NSURL * iconFullPath;

+ (instancetype)userWithDictionary:(NSDictionary *)dict;

@end
