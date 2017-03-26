//
//  ZJGuangLiShouHuoDiZhiTableViewCell.m
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZJGuangLiShouHuoDiZhiTableViewCell.h"

@implementation ZJGuangLiShouHuoDiZhiTableViewCell



- (IBAction)bianJiBtn:(id)sender {
    
    if (self.bianJiBlack) {
        
        self.bianJiBlack();
    }
}

- (IBAction)deleteOnclick:(id)sender {
    
    if (self.deleteBlack) {
        
        self.deleteBlack();
    }
}


- (void)setAssignmentData:(ZTShouHuoAddressModel *)model
{
    self.InfoLab.text = [NSString stringWithFormat:@"%@ %@ %@",model.realname,model.sex,model.phone];
    
    if ([model.defaults intValue] == 2) {
        
        self.addressLab.text = [NSString stringWithFormat:@"【默认】%@ %@",model.qu, model.address];
    }
    else
    {
        self.addressLab.text = [NSString stringWithFormat:@"%@ %@",model.qu, model.address];
    }
}

@end
