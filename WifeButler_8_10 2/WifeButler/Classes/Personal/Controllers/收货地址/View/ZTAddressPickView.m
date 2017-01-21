//
//  ZTAddressPickView.m
//  YouHu
//
//  Created by ZT on 16/5/7.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTAddressPickView.h"

@implementation ZTAddressPickView


- (IBAction)doneOnclick:(id)sender {
    
    if (self.doneBlack) {
        
        self.doneBlack();
    }
}




@end
