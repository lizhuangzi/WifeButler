//
//  LoopView.h
//  LoopScrollDemo
//
//  Created by white on 16/5/18.
//  Copyright © 2016年 white. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopButton.h"

@interface LoopView : UIView

@property (nonatomic,strong) NSMutableArray *loopButtons;

@property (nonatomic, copy) void (^dianJiBlack)(LoopButton *LoopBtn);

@end
