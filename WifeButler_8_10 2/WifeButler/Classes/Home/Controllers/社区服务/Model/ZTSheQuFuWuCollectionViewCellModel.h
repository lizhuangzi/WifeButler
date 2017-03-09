//
//  ZTSheQuFuWuCollectionViewCellModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTSheQuFuWuCollectionViewCellModel : NSObject

/**图片*/
@property (nonatomic,copy)NSString * file;
/**图片全路径*/
@property (nonatomic,copy)NSString * imageURLStr;
/**名字*/
@property (nonatomic,copy)NSString * name;

@property (nonatomic,copy)NSString * Id;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
