//
//  ZJProcessorDetailTableCell4.h
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    typeShopJianJie,   // 简介
    typeShopCanShu,    // 参数
    typeShopPingJia    // 评价
    
}typeShop;

@interface ZJProcessorDetailTableCell4 : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) typeShop typeShop;

@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView1;

/**
 *  传值
 */
@property (nonatomic, copy) NSString * goodId;

-(void)setSegmentView;


@property (nonatomic, copy) void (^ShangPinBlack)(int a, CGFloat heightFloat);

// 简介数据数组
@property (nonatomic, strong) NSMutableArray *dataSource1;

// 参数数据数组
@property (nonatomic, strong) NSMutableArray *dataSource2;

// 评价数据数组
@property (nonatomic, strong) NSMutableArray *dataSource3;

@end
