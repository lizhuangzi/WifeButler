//
//  WifeButlerLocationManager.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
#import "WifeButlerLocationModel.h"


@interface WifeButlerLocationManager : NSObject

HMSingletonH(Manager);

/**用于存放当前用户选择的的经度*/
@property (nonatomic,assign) CLLocationDegrees longitude;
/**用于存放当前用户选择的纬度*/
@property (nonatomic,assign) CLLocationDegrees latitude;
/**用于存放当前用户选择的小区*/
@property (nonatomic,copy)NSString * village;

/**请求高德定位信息*/
- (void)startLocationAndFinishBlock:(void(^)(WifeButlerLocationModel * locationInfo))returnInformation;
/**是否完成定位*/
@property (nonatomic,assign,getter=isFinishLocated , readonly) BOOL finishLocated;
@end
