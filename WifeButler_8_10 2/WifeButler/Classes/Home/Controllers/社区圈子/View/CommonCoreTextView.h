//
//  CommonCoreTextView.h
//  docClient
//
//  Created by paopao on 16/8/2.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCoreTextView : UIView
// 点击高亮字体
@property (nonatomic, copy) void (^didHighlightTextWithIndexClick)(NSInteger count);

// 点击其他区域
@property (nonatomic, copy) void (^didOtherTextClick)();

// 点击超出区域是否接收手势事件，默认为 YES
@property (nonatomic, assign) BOOL overrangShouldReceiveTouch;

// attributeStr显示的文字 selectRangeArray需要有点击事件的区域
-(void)binWithAttributeStr:(NSAttributedString *)attributeStr selectRangeArray:(NSArray *)selectRangeArray;

// 文字高度
+(CGFloat)getArrtibutedStrHeightWith:(NSAttributedString *)attributeStr coreTextViewWidth:(CGFloat)width;

// 计算绘制的区域大小
+ (CGSize)getAttributedStringRectWithString:(NSAttributedString *)string  WidthValue:(int)width;

-(BOOL)shouldReceiveTouch:(UITouch *)touch;

@end
