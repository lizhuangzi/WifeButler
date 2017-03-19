//
//  GoodsDetailRemarkSectionHeader.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@interface GoodsDetailRemarkSectionHeader : UIView

+ (instancetype)DetailRemarkSectionHeader;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *reViewLabel;

@property (weak, nonatomic) IBOutlet XHStarRateView *startView;


@end
