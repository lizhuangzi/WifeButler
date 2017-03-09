//
//  ZTSheQuFuWuViewController.h
//  WifeButler
//
//  Created by ZT on 16/6/6.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZTSheQuFuWuViewController : UICollectionViewController

- (void)requestDataWithServiceID:(NSString *)Id;

- (void)pushServiceListViewWithServiceID:(NSString *)Id IndexPath:(NSIndexPath *)indexPath;

@end
