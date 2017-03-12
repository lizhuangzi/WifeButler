//
//  CardPocklistModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/12.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"

@interface CardPocklistModel : WifeButlerCommonBaseModel

@property (nonatomic,copy , readonly)NSString * cardNum;

@property (nonatomic,copy)NSString * bank_card1;

@property (nonatomic,copy)NSString * bankname;

@property (nonatomic,copy)NSString * type;
@end
