//
//  CommonEmojiManager.h
//  CjSummary
//
//  Created by paopao on 16/8/17.
//  Copyright © 2016年 cj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonEmojiManager : NSObject

/**  选中页表情 */
+ (NSArray *)emotionsWithKey:(NSString *)key ;

/** 总页数 */
+ (NSInteger)emotionPageWithKey:(NSString *)key;

/** 总页数 */
+ (NSInteger)emotionPage;

/** 所有的表情数据 */
+ (NSArray *)emotionsData;

/** 每组表情个数合集 */
+ (NSArray *)emotionsItemPageArray;

/**
 *  指定页码，返回当前页的表情
 *
 *  @param page 页码
 *
 *  @return 当前页的标签
 */
+ (NSArray *)emotionsOfPage:(NSInteger)page andKey:(NSString *)key;

@end
