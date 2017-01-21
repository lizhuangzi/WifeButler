//
//  ZJTrendsDetailHeaderView.m
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJTrendsDetailHeaderView.h"

@implementation ZJTrendsDetailHeaderView

-(void)awakeFromNib{
    
    self.icon.layer.cornerRadius = self.icon.height/2;
    self.icon.layer.masksToBounds = YES;
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.size = CGSizeMake(iphoneWidth, 80);
    
}



@end
