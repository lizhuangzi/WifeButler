//
//  ZJShopClassVC.h
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJShopClassVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,copy)NSString*classId;

@property (nonatomic,copy)NSString * keyBoard;

@property (nonatomic,assign)NSInteger type;
//type  为1时 点击跳转过来的   ，  为2时 搜索过来的

@property (nonatomic, copy) NSString * titleName;

// 1:是社区购物   2:是社区服务    3:是社区物业
@property (nonatomic, copy) NSString * serve_idType;

@end
