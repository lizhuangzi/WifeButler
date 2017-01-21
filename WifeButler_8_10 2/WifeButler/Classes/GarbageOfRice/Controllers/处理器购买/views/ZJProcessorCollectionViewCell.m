//
//  ZJProcessorCollectionViewCell.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJProcessorCollectionViewCell.h"

@implementation ZJProcessorCollectionViewCell
-(void)setColorLabel
{
    self.colorLabel.layer.borderColor = UIColor.grayColor.CGColor;
    self.colorLabel.layer.borderWidth = 1;
    self.colorLabel.layer.masksToBounds = YES;
}
@end
