//
//  CommunityRealEstateController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CommunityRealEstateController.h"
#import "ZTSheQuFuWuCollectionViewCellModel.h"
#import "ServiceListViewController.h"

@interface CommunityRealEstateController ()



@end

@implementation CommunityRealEstateController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)requestDataWithServiceID:(NSString *)Id
{
    Id = @"3";
    [super requestDataWithServiceID:Id];
}

- (void)pushServiceListViewWithServiceID:(NSString *)Id IndexPath:(NSIndexPath *)indexPath
{
    Id = @"3";
    [super pushServiceListViewWithServiceID:Id IndexPath:indexPath];
}
@end
