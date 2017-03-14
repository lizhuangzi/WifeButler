//
//  LoveDonateDetailViewCell.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoveDonateListSectionView.h"

@interface LoveDonateDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LoveDonateListSectionView *Cellheader;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
