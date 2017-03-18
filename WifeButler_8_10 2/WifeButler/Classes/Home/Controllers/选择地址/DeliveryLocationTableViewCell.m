//
//  DeliveryLocationTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/13.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "DeliveryLocationTableViewCell.h"

@interface DeliveryLocationTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *mainInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation DeliveryLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    NSString * name = _dataDict[@"realname"];
    NSString * sex = _dataDict[@"sex"];
    NSString * phone = _dataDict[@"phone"];
    self.mainInfoLabel.text = [NSString stringWithFormat:@"%@ %@ %@",name,sex,phone];
    
    NSString * village = _dataDict[@"village_name"];
    
    
    if ([_dataDict[@"defaults"] integerValue] == 2) { //默认
        
        NSAttributedString * moren = [[NSAttributedString alloc]initWithString:@"[默认]"];

        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithAttributedString:moren];
        
       [attstr addAttribute:NSForegroundColorAttributeName value:WifeButlerCommonRedColor range:NSMakeRange(0, 4)];
       
        NSAttributedString * villageAttr = [[NSAttributedString alloc]initWithString:village];
        [attstr appendAttributedString:villageAttr];
        
        self.detailLabel.attributedText = attstr;
    }else{
        self.detailLabel.attributedText = nil;
        self.detailLabel.text = village;
    }
    
}

@end
