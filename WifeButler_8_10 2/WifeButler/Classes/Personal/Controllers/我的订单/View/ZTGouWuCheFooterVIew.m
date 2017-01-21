//
//  ZTGouWuCheFooterVIew.m
//  WifeButler
//
//  Created by ZT on 16/5/28.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTGouWuCheFooterVIew.h"

@implementation ZTGouWuCheFooterVIew

//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    
//    if (self = [super initWithCoder:aDecoder]) {
//        
//        NSLog(@"xxxxx");
//        
//        self.deleteBtn.layer.masksToBounds = YES;
//        self.deleteBtn.layer.cornerRadius = 5;
//        self.deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
//        
//        self.goShopBtn.layer.cornerRadius = 5;
//        self.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
//
//    }
//    
//    return self;
//}


//- (void)awakeFromNib
//{
//    self.deleteBtn.layer.masksToBounds = YES;
//    self.deleteBtn.layer.cornerRadius = 5;
//    self.deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    
//    self.goShopBtn.layer.cornerRadius = 5;
//    self.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
//}

- (IBAction)deleteClick:(id)sender {
    
    if (self.deleteBlack) {
        
        self.deleteBlack();
    }
}


- (IBAction)goShopClick:(id)sender {
    
    if (self.goShopBlack) {
        
        self.goShopBlack();
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
