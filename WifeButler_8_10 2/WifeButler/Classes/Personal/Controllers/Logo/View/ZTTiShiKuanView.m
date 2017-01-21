//
//  ZTTiShiKuanView.m
//  WifeButler
//
//  Created by ZT on 16/7/21.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTTiShiKuanView.h"

@implementation ZTTiShiKuanView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 5;
}

@end
