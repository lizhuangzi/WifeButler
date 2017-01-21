//
//  ZTQuanZiView.m
//  WifeButler
//
//  Created by ZT on 16/6/21.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTQuanZiView.h"

@implementation ZTQuanZiView

- (IBAction)woDeDongTaiClick:(id)sender {
    
    if (self.woDeDongTaiBlack) {
        
        self.woDeDongTaiBlack();
    }
}


- (IBAction)faBuDongTaiClick:(id)sender {
    
    if (self.faBuDongTaiBlack) {
        
        self.faBuDongTaiBlack();
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
