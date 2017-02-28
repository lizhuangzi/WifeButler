//
//  UIWindow+existion.h
//  QF微博
//
//  Created by MS on 15-9-10.
//  Copyright (c) 2015年 QF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (existion)

- (BOOL)isFirstLaunch;

- (void)switchRootViewController;

- (void)switchGuidViewController;
@end
