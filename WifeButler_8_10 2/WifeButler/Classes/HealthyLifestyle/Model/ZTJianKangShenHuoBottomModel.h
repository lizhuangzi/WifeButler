//
//  ZTJianKangShenHuoBottomModel.h
//  WifeButler
//
//  Created by ZT on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTJianKangShenHuoBottomModel : NSObject

@property (nonatomic, copy) NSString * alt;
@property (nonatomic, copy) NSString * file;
@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * readnum;

@property (nonatomic,strong) NSMutableArray * imageURLStrs;
/**用于记录cell高度*/
@property (nonatomic,assign) CGFloat cellHeigh;

@end
