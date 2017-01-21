//
//  ZJProcessorDetailTableCell3.h
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJBuyGoodsNumDelegate <NSObject>

- (void)changeGoodsNumWithCurrentNum:(int)num;

@end

@interface ZJProcessorDetailTableCell3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;


@property (nonatomic,weak) id<ZJBuyGoodsNumDelegate>delegate;
- (IBAction)delBtnClick:(id)sender;
- (IBAction)addBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;
@property (nonatomic,assign) int goodsNum;

@end
