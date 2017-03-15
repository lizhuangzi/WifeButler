//
//  LoveDonateDetailModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface LoveDonateDetailModel : WifeButlerCommonBaseModel

@property (nonatomic,copy)NSString * title;
/**简介*/
@property (nonatomic,copy)NSString * brief;
/**图片路径*/
@property (nonatomic,copy)NSString * banner;
/** 用户捐款数*/
@property (nonatomic,copy)NSString * user_donation;
/**目标捐款数    */
@property (nonatomic,copy)NSString * target_sum;
/** 爱心份数*/
@property (nonatomic,copy)NSString * count;
/** 详情*/
@property (nonatomic,copy)NSString * details;
/**organization*/
@property (nonatomic,copy)NSString * organization;

@property (nonatomic,copy)NSString * percent;

@property (nonatomic,assign) CGFloat cell1H;

@property (nonatomic,assign) CGFloat cell2H;

@end
