//
//  ServiceListModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface ServiceListModel : WifeButlerCommonBaseModel

/**标题*/
@property (nonatomic,copy)NSString * title;
/**单位*/
@property (nonatomic,copy)NSString * unit;
/**原价*/
@property (nonatomic,copy)NSString * oldprice;
/**现价*/
@property (nonatomic,copy)NSString * money;
/**买出*/
@property (nonatomic,copy)NSString * sales;

@end
