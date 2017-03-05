//
//  WifeButlerLocationManager.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface WifeButlerLocationManager ()

@property (nonatomic,strong) AMapLocationManager * locationManager;

@end

@implementation WifeButlerLocationManager

HMSingletonM(Manager);

- (void)startLocationAndFinishBlock:(void (^)(NSString * village, CLLocationCoordinate2D location))returnInformation
{
    self.locationManager = [[AMapLocationManager alloc]init];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        !returnInformation?:returnInformation(regeocode.formattedAddress,location.coordinate);
    }];
}

@end
