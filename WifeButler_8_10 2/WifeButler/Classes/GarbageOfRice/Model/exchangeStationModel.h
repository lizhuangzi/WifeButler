//
//  exchangeStationModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface exchangeStationModel : NSObject
/**商店名*/
@property (nonatomic,copy)NSString * shop_name;
/**地址*/
@property (nonatomic,copy)NSString * address;
/**商店图片*/
@property (nonatomic,copy)NSString * shop_pic;

/**电话*/
@property (nonatomic,copy)NSString * mobile;
/**公告*/
@property (nonatomic,copy)NSString * gonggao;

+ (instancetype)exchangeStationModelWithDict:(NSDictionary *)dictionary;

@end
