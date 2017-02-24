//
//  WifebutlerRCRHomeHeaderView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class exchangeStationModel;
@interface WifebutlerRCRHomeHeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic,strong) exchangeStationModel * model;
@end
