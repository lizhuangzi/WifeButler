//
//  ZTLeiXinShangPinViewController.h
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTLeiXinShangPinViewController : UIViewController

// 所属版块  // 1:是社区购物   2:是社区服务    3:是社区物业
@property (nonatomic, copy) NSString * serve_idType;

// 分类id
@property (nonatomic, copy) NSString * classId;

//type  为1时 点击跳转过来的   ，  为2时 搜索过来的
@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString * titleName;

@property (nonatomic,copy) NSString * keyBoard;

@end
