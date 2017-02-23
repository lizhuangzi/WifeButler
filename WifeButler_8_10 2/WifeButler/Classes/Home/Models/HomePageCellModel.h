//
//  HomePageCellModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**首页内容模型*/
@interface HomePageCellModel : NSObject
/**商品id*/
@property (nonatomic,copy)NSString * commodityId;
/**商品名称*/
@property (nonatomic,copy)NSString * title;
/**商品图片*/
@property (nonatomic,copy)NSString * imageURLstr;
/**价格*/
@property (nonatomic,copy)NSString * money;
/**销量*/
@property (nonatomic,copy)NSString * sales;
/**单位*/
@property (nonatomic,copy)NSString * danwei;

@end
