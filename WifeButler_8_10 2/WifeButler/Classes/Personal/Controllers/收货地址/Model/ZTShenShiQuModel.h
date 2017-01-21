//
//  ZTShenShiQuModel.h
//  WifeButler
//
//  Created by ZT on 16/7/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTShenShiQuModel : NSObject

@property (nonatomic, copy) NSString * id;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, strong) NSArray * list_a;

@end


@interface ZTShiModel : NSObject

@property (nonatomic, copy) NSString * id;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, strong) NSArray * list_b;


@end

@interface ZTQuModel : NSObject

@property (nonatomic, copy) NSString * id;

@property (nonatomic, copy) NSString * name;

@end
