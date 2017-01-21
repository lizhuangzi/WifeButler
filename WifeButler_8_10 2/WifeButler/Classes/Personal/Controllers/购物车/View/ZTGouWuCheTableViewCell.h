//
//  ZTGouWuCheTableViewCell.h
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTGouWuCheTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *xuanZhongBtn;


@property (nonatomic, copy) void (^addBlack)(void);

@property (nonatomic, copy) void (^jianBlack)(void);

@property (nonatomic, copy) void (^deleteBlack)(void);




@end
