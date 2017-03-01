//
//  CommonEmojiManager.m
//  CjSummary
//
//  Created by paopao on 16/8/17.
//  Copyright © 2016年 cj. All rights reserved.
//

#import "CommonEmojiManager.h"

static NSInteger adaptiveHeight(CGFloat i6_h,CGFloat i6p_h,CGFloat h) {
    NSInteger height;
    static NSInteger screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    });
    if (screenHeight == 667) {
        height = i6_h;
    }else if (screenHeight == 736) {
        height = i6p_h;
    }else {
        height = h;
    }
    return height;
};

#define AdaptiveHeight(i6,i6p,i)  adaptiveHeight(i6,i6p,i)
// 每页多少个
#define emojiCountOfPage   AdaptiveHeight(23,23,20)


#define EmotionPath [[NSBundle mainBundle] pathForResource:@"EmojisList.plist" ofType:nil]

@implementation CommonEmojiManager

/** 选中页表情 */
+ (NSArray *)emotionsWithKey:(NSString *)key
{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:EmotionPath];
    return [dic objectForKey:key];
}
// 总页数
+ (NSInteger)emotionPageWithKey:(NSString *)key
{
    NSInteger emojiCount = [self emotionsWithKey:key].count;
    NSInteger page = emojiCount/emojiCountOfPage;
    page = emojiCount%emojiCountOfPage > 0 ? page + 1 : page;
    return  page;
}

/** 总页数 */
+ (NSInteger)emotionPage
{
    NSArray *keysArray = @[@"People",@"Places",@"Objects",@"Nature"];
    NSInteger sumPage = 0;
    for (NSString *key in keysArray) {
        sumPage += [self emotionPageWithKey:key];
    }
    return sumPage;
}

/** 所有的表情数据 */
+ (NSArray *)emotionsData
{
    NSArray *keysArray = @[@"People",@"Places",@"Objects",@"Nature"];
    NSMutableArray *sumArray = [NSMutableArray array];
    for (NSString *key in keysArray) {
        NSInteger count = [self emotionPageWithKey:key];
        for (int i = 0; i < count; i ++ ) {
            [sumArray addObject:[self emotionsOfPage:i andKey:key]];
        }
    }
    return sumArray;
}

/** 每组表情个数合集 */
+ (NSArray *)emotionsItemPageArray
{
    NSArray *keysArray = @[@"People",@"Places",@"Objects",@"Nature"];
    NSMutableArray *sumArray = [NSMutableArray array];
    NSInteger loc = 0;
    for (NSString *key in keysArray) {
        NSInteger count = [self emotionPageWithKey:key];
        [sumArray addObject:NSStringFromRange(NSMakeRange(loc, count))];
        loc += count;
    }
    return sumArray;
}

/**
 *  指定页码，返回当前页的表情
 *
 *  @param page 页码
 *
 *  @return 当前页的标签
 */
+ (NSArray *)emotionsOfPage:(NSInteger)page andKey:(NSString *)key
{
    NSArray *emojiArray = [self emotionsWithKey:key];
    
    // 角标
    NSInteger loc = page *emojiCountOfPage;
    
    // 长度
    NSInteger length = emojiCountOfPage;
    
    // 总页数
    NSInteger emojiPage = [self emotionPageWithKey:key];
    
    if (page < 0 || page == emojiPage) {
        NSLog(@"超出页码或者页码不对");
        return nil;
    }
    
    if (page == emojiPage - 1) { // 最后一页数据
        length = (emojiArray.count - (emojiPage - 1) *emojiCountOfPage);
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, length)];
    
    NSArray *emotions = [emojiArray objectsAtIndexes:indexSet];
    
    return emotions;
    
}

@end
