//
//  CardPocklistModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/12.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocklistModel.h"

@implementation CardPocklistModel

- (void)mj_keyValuesDidFinishConvertingToObject
{
    [super mj_keyValuesDidFinishConvertingToObject];
    _cardNum = [NSString stringWithFormat:@"**** **** **** *** %@",self.bank_card1];
}
@end
