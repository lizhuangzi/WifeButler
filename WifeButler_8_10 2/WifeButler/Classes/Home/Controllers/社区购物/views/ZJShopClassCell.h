//
//  ZJShopClassCell.h
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJAddBusDelegate <NSObject>

- (void)addBusWithPath:(NSIndexPath*)path;

@end
@interface ZJShopClassCell : UICollectionViewCell
@property(nonatomic,weak)id<ZJAddBusDelegate>delegate;
@property (nonatomic,strong)NSIndexPath*path;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (IBAction)addBusClick:(id)sender;

//@property (nonatomic, copy) NSString ;


@end
