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

- (void)startLocationAndFinishBlock:(void (^)(WifeButlerLocationModel * locationInfo))returnInformation
{
 
    _finishLocated = NO;
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout =2;
    self.locationManager.reGeocodeTimeout = 2;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        NSString * formatteAddress;
        if (!regeocode.formattedAddress) {
             formatteAddress = [NSString stringWithFormat:@"%@%@%@",regeocode.city,regeocode.district,regeocode.POIName];
        }else{
            formatteAddress  = regeocode.formattedAddress;
        }
       
        WifeButlerLocationModel * lf = [WifeButlerLocationModel new];
        lf.POIName = regeocode.POIName;
        lf.location2D = location.coordinate;
        lf.formateAddress = formatteAddress;
        
        self.locationInfo = lf;
        _finishLocated = YES;
        
        !returnInformation?:returnInformation(lf);
    }];
}

- (NSString *)village
{
    if (!_village) {
        return @"";
    }
    return _village;
}
@end
