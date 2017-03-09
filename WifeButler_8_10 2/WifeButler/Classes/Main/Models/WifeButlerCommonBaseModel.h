//
//  WifeButlerCommonBaseModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifeButlerCommonBaseModel : NSObject

@property (nonatomic,copy)NSString * Id;

@property (nonatomic,copy)NSString * files;
@property (nonatomic,copy)NSString * file;
@property (nonatomic,strong)NSURL * imageURL;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
