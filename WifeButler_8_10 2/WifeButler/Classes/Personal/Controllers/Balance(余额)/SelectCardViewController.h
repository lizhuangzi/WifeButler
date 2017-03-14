//
//  SelectCardViewController.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketListViewController.h"

@interface SelectCardViewController : CardPocketListViewController

@property (nonatomic,copy)void(^returnBlock)(CardPocklistModel * model);

@end
