//
//  CommonEmojiPageCell.h
//  CjSummary
//
//  Created by paopao on 16/8/17.
//  Copyright © 2016年 cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonEmojiPageCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *emotions;

@property (nonatomic, copy) void (^didDelegateClick)();

@property (nonatomic, copy) void (^didEmojiClick)(NSString *emojiStr);
@end
