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

- (void)startLocationAndFinishBlock:(void (^)(LocationInfoStuct locationInfo))returnInformation
{
   
    self.locationManager = [[AMapLocationManager alloc]init];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        NSString * formatteAddress;
        if (!regeocode.formattedAddress) {
             formatteAddress = [NSString stringWithFormat:@"%@%@%@",regeocode.city,regeocode.district,regeocode.POIName];
        }else{
            formatteAddress  = regeocode.formattedAddress;
        }
       
        LocationInfoStuct lf = {};
        lf.POIName = formatteAddress.UTF8String;
        lf.location2D = location.coordinate;
        lf.formateAddress = regeocode.formattedAddress.UTF8String;

        !returnInformation?:returnInformation(lf);
    }];
}

@end
