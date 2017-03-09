//
//  ServiceListViewController.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerLoadingTableViewController.h"

@interface ServiceListViewController : WifeButlerLoadingTableViewController

- (instancetype)initWithServiceId:(NSString *)serviceId;

/**分类id*/
@property (nonatomic,copy)NSString * catId;

@end
