//
//  ZTJianPanView.h
//  WifeButler
//
//  Created by ZT on 16/6/15.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTJianPanView : UIView


@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, copy) void (^faSongBlack)(NSString *str);

@end
