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

typedef  struct MainLocationInfoStuct{
    CLLocationCoordinate2D location2D;
    const char * POIName;
    const char * formateAddress;
}LocationInfoStuct;

@interface WifeButlerLocationManager : NSObject

HMSingletonH(Manager);

@property (nonatomic,assign) LocationInfoStuct currentlocationInfo;

- (void)startLocationAndFinishBlock:(void(^)(LocationInfoStuct locationInfo))returnInformation;

@end
