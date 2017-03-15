//
//  MyDonateUserlistModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface MyDonateUserlistModel : WifeButlerCommonBaseModel

@property (nonatomic,copy)NSString * title;

@property (nonatomic,copy)NSString * banner;

@property (nonatomic,copy)NSString * brief;

/**捐赠次数*/
@property (nonatomic,copy)NSString * count;
/**"1"  是否结束 未结束 2已结束*/
@property (nonatomic,copy)NSString * isorno;

@end
