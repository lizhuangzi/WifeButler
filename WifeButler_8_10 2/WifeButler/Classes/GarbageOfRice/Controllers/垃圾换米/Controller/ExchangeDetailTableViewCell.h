//
//  ExchangeDetailTableViewCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/12.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeDetailTableViewCell : UITableViewCell
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**交换次数*/
@property (weak, nonatomic) IBOutlet UILabel *exchangeCountLabel;
/**现在的价格*/
@property (weak, nonatomic) IBOutlet UILabel *nowMoneylabel;
/**以前的价格*/
@property (weak, nonatomic) IBOutlet UILabel *orginnalLabel;
/**预约送 label*/
@property (weak, nonatomic) IBOutlet UILabel *orderSend;
@end
