//
//  HomePageCommodityView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageCellModel.h"

@interface HomePageCommodityView : UIControl

@property (nonatomic,strong) HomePageCellModel * cellModel;

+ (instancetype)HomePageCommodityView;

@end
