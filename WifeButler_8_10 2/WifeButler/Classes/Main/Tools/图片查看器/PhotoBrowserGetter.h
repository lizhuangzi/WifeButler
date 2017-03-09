//
//  PhotoBrowserGetter.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoBrowserGetter : NSObject

+ (instancetype)browserGetter;

- (UIViewController *)getBrowserWithCurrentIndex:(NSUInteger)index andimageURLStrings:(NSArray *)photoImageUrls;

@end
