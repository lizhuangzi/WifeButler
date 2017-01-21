//
//  ZJFriendsCircleNavgationbar.m
//  weiCity
//
//  Created by 陈振奎 on 16/3/22.
//  Copyright © 2016年 Mr.chen. All rights reserved.
//

#import "ZJFriendsCircleNavgationbar.h"

@implementation ZJFriendsCircleNavgationbar


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.size = CGSizeMake(iphoneWidth, 44);
    
}

- (IBAction)subBtn_clicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(friendsCircleNavgationbar:btnClicked:)]) {
        [self.delegate friendsCircleNavgationbar:self btnClicked:sender.tag];
    }
    
}




@end
