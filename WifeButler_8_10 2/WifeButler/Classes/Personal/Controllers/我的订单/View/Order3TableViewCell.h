//
//  Order3TableViewCell.h
//  DingPurchasingSuSong
//
//  Created by zjtdmac2 on 16/3/29.
//  Copyright © 2016年 zjtdmac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Order3TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *pingJiaBtn;


@property (nonatomic, copy) void (^pingJiaBlack)(void);

@end
