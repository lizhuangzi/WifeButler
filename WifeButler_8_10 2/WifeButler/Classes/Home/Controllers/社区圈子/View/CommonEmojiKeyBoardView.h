//
//  CommonEmojiKeyBoardView.h
//  CjSummary
//
//  Created by paopao on 16/8/16.
//  Copyright © 2016年 cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonEmojiKeyBoardView : UIView
// 点击删除
@property (nonatomic, copy) void (^didDeleteClick)();
// 点击表情
@property (nonatomic, copy) void (^didEmojiClick)(NSString *emojiStr);
// 点击发送
@property (nonatomic, copy) void (^didSendClick)();

@end
