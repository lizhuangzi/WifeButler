//
//  WifeButlerLocationManager.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "WifeButlerNetWorking.h"
#import "NetWorkPort.h"

@interface WifeButlerLocationManager ()

@property (nonatomic,strong) AMapLocationManager * locationManager;

@property (nonatomic,copy)void(^locationInfoBlock)(WifeButlerLocationModel * info);
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



- (void)getCurrentLocationInfo:(void (^)(WifeButlerLocationModel *))infoBlock
{
    if ([WifeButlerAccount sharedAccount].isLogin) { //如果用户登录了
        [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KMoRenDiZhi parameter:@{@"token":KToken} success:^(NSDictionary * resultCode) {
            NSDictionary * dict = resultCode[@"address"];
            NSString * village = dict[@"village_name"];
            
            if (village.length == 0) {
                [self netWorkingJinWeiDu];
            }else{
                
                [WifeButlerLocationManager sharedManager].longitude =  [dict[@"longitude"] doubleValue];
                [WifeButlerLocationManager sharedManager].latitude =  [dict[@"latitude"] doubleValue];
                [WifeButlerLocationManager sharedManager].village = village;
               
            }
        } failure:^(NSError *error) {
            [self netWorkingJinWeiDu];
        }];
    }else{
        [self netWorkingJinWeiDu];
    }
}

- (void)netWorkingJinWeiDu{
    
    [self startLocationAndFinishBlock:^(WifeButlerLocationModel *locationInfo) {
        
        if (locationInfo.POIName.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            return ;
        }
        
        NSString * jingDu = [NSString stringWithFormat:@"%f",locationInfo.location2D.longitude];
        NSString * weiDu = [NSString stringWithFormat:@"%f",locationInfo.location2D.latitude];
        
        [WifeButlerLocationManager sharedManager].longitude = locationInfo.location2D.longitude;
        [WifeButlerLocationManager sharedManager].latitude = locationInfo.location2D.latitude;
        [WifeButlerLocationManager sharedManager].village = locationInfo.POIName;
    }];

}

@end
