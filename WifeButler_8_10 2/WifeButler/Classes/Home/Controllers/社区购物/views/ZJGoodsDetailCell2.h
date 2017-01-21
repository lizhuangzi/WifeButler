//
//  ZJGoodsDetailCell2.h
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJBuyGoodsNumDelegate <NSObject>

- (void)changeGoodsNumWithCurrentNum:(int)num;

@end
@interface ZJGoodsDetailCell2 : UITableViewCell
@property (nonatomic,weak) id<ZJBuyGoodsNumDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *remainLabel;
@property (nonatomic,assign) int goodsNum;
- (IBAction)addNumClick:(id)sender;
- (IBAction)delNumClick:(id)sender;


@end
