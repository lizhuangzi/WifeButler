//
//  WifeButlerLocationManager.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"

@interface WifeButlerLocationManager : NSObject

HMSingletonH(Manager);


@property (nonatomic,assign) CGFloat longtitude;

@property (nonatomic,assign) CGFloat latitude;

@end
