//
//  ZJGuangLiShouHuoDiZhiTableViewCell.h
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTShouHuoAddressModel.h"

@interface ZJGuangLiShouHuoDiZhiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *bianJiBtn;


@property (weak, nonatomic) IBOutlet UIView *backview;


@property (nonatomic, copy) void(^deleteBlack)(void);

@property (nonatomic, copy) void(^bianJiBlack)(void);


- (void)setAssignmentData:(ZTShouHuoAddressModel *)model;

@end
