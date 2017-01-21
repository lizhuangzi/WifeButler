//
//  ZJGuangLiShouHuoDiZhiTableViewCell.m
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZJGuangLiShouHuoDiZhiTableViewCell.h"

@implementation ZJGuangLiShouHuoDiZhiTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backview.layer.masksToBounds = YES;
    
    self.backview.layer.cornerRadius = 5.0;
}

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
    self.nameLab.text = model.realname;
    
    if ([model.defaults intValue] == 2) {
        
        NSSaveUserDefaults(model.longitude, @"jing");
        NSSaveUserDefaults(model.latitude, @"wei");
        NSSaveUserDefaults(model.village_name, @"xiaoQu");
        self.addressLab.text = [NSString stringWithFormat:@"【默认】%@", model.address];
    }
    else
    {
        self.addressLab.text = model.address;
    }
    
    self.iphoneLab.text = model.phone;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
