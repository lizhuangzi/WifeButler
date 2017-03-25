//
//  WifebutlerRCRHomeHeaderView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class exchangeStationModel;
@class WifebutlerRCRHomeHeaderView;

@protocol WifebutlerRCRHomeHeaderViewDelegate <NSObject>

- (void)WifebutlerRCRHomeHeaderViewdidClickQR:(WifebutlerRCRHomeHeaderView *)view;

@end

@interface WifebutlerRCRHomeHeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic,strong) exchangeStationModel * model;
@property (nonatomic,assign) id<WifebutlerRCRHomeHeaderViewDelegate> delegate;

@end
