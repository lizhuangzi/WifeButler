//
//  ZTJieSuan11TableViewCell.h
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTJieSuan11TableViewCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dianPuNameLab;
@property (weak, nonatomic) IBOutlet UILabel *youHuiJuanLab;
@property (weak, nonatomic) IBOutlet UILabel *yunFeiLab;
@property (weak, nonatomic) IBOutlet UILabel *heJiMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *shopNumLab;
@property (nonatomic,assign)NSInteger temp;

@property (nonatomic, copy) void (^youHuijuanBlack)(void);


- (void)setTableViewTempWithAry:(NSMutableArray*)Ary;


@end
