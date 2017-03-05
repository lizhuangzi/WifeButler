//
//  WifeButlerLocationManager.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
#import <CoreLocation/CoreLocation.h>

struct MainLocationInfoStuct{
    CLLocationCoordinate2D location2D;
    char * village;
};

@interface WifeButlerLocationManager : NSObject

HMSingletonH(Manager);



- (void)startLocationAndFinishBlock:(void(^)(NSString * village,CLLocationCoordinate2D  location))returnInformation;

@end
