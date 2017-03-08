//
//  GoodsDetailRemarkSectionHeader.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "GoodsDetailRemarkSectionHeader.h"

@interface GoodsDetailRemarkSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *reViewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;


@end


@implementation GoodsDetailRemarkSectionHeader

+ (instancetype)DetailRemarkSectionHeader
{
    return [[NSBundle mainBundle]loadNibNamed:@"GoodsDetailRemarkSectionHeader" owner:nil options:nil].lastObject;
}



@end
