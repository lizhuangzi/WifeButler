//
//  ZJCommunityShopHeaderView.m
//  YouHu
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZJCommunityShopHeaderView.h"

@implementation ZJCommunityShopHeaderView

-(void)setLabel
{
    self.label1.layer.borderColor = [UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000].CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.layer.masksToBounds = YES;
    [self.label1 setTextColor:[UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000]];
    
    self.label2.layer.borderColor = UIColor.grayColor.CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.layer.masksToBounds = YES;
    
    self.label3.layer.borderColor = UIColor.grayColor.CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.layer.masksToBounds = YES;
    
    UITapGestureRecognizer*tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick1)];
    UITapGestureRecognizer*tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick2)];
    UITapGestureRecognizer*tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick3)];
    
    self.label1.userInteractionEnabled=YES;
    self.label2.userInteractionEnabled=YES;
    self.label3.userInteractionEnabled=YES;
    
    [self.label1 addGestureRecognizer:tap1];
    [self.label2 addGestureRecognizer:tap2];
    [self.label3 addGestureRecognizer:tap3];
    
}

-(void)labelClick1
{
    self.label1.layer.borderColor = [UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000].CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.layer.masksToBounds = YES;
    self.label2.layer.borderColor = UIColor.grayColor.CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.layer.masksToBounds = YES;
    self.label3.layer.borderColor = UIColor.grayColor.CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.layer.masksToBounds = YES;
    [self.label1 setTextColor:[UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000]];
    [self.label2 setTextColor:[UIColor grayColor]];
    [self.label3 setTextColor:[UIColor grayColor]];
    [self.delegate labelClickWithType:@"1"];
}

-(void)labelClick2
{
    self.label2.layer.borderColor = [UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000].CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.layer.masksToBounds = YES;
    self.label1.layer.borderColor = UIColor.grayColor.CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.layer.masksToBounds = YES;
    self.label3.layer.borderColor = UIColor.grayColor.CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.layer.masksToBounds = YES;
    [self.label2 setTextColor:[UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000]];
    [self.label1 setTextColor:[UIColor grayColor]];
    [self.label3 setTextColor:[UIColor grayColor]];
    [self.delegate labelClickWithType:@"2"];
}

-(void)labelClick3
{
    self.label3.layer.borderColor = [UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000].CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.layer.masksToBounds = YES;
    self.label2.layer.borderColor = UIColor.grayColor.CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.layer.masksToBounds = YES;
    self.label1.layer.borderColor = UIColor.grayColor.CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.layer.masksToBounds = YES;
    [self.label3 setTextColor:[UIColor colorWithRed:0.809 green:0.000 blue:0.008 alpha:1.000]];
    [self.label2 setTextColor:[UIColor grayColor]];
    [self.label1 setTextColor:[UIColor grayColor]];
    [self.delegate labelClickWithType:@"3"];
}

@end
