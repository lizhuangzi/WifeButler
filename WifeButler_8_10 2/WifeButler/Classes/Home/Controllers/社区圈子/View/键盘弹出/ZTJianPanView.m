//
//  ZTJianPanView.m
//  WifeButler
//
//  Created by ZT on 16/6/15.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTJianPanView.h"

@implementation ZTJianPanView

- (IBAction)faSongClick:(id)sender {
    
    if (self.faSongBlack) {
        
        self.faSongBlack(self.textView.text);
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
