//
//  WifeButlerLocationModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WifeButlerLocationModel : NSObject

@property (nonatomic,copy)NSString * formateAddress;

@property (nonatomic,copy)NSString * POIName;

@property (nonatomic,assign) CLLocationCoordinate2D location2D;



@end
