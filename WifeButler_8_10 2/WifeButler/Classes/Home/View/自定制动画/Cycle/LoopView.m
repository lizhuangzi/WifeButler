//
//  LoopView.m
//  LoopScrollDemo
//
//  Created by white on 16/5/18.
//  Copyright © 2016年 white. All rights reserved.
//

#import "LoopView.h"
#import "LoopButtonManager.h"

#define KButtonWidth button.frame.size.width
#define KButtonHeight button.frame.size.height

@interface LoopView ()

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray * iconArr;

@end

@implementation LoopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.loopButtons = [NSMutableArray arrayWithCapacity:5];
         [self addRoundButtons];
         [self addGesture]; //添加手势
    }
    return self;
}

# pragma - mark 添加Button
- (void)addRoundButtons {
    LoopButton *currentButton = nil;
    
    for (int i = 0; i <= 4; i++) {
        LoopButton *button = nil;
        
        if (i == 0) {
            button = [LoopButtonManager buttonWithLoopButtonType:KLoopButtonTypeSmall];
        } else if (i == 4) {
            button = [LoopButtonManager buttonWithLoopButtonType:KLoopButtonTypeSmall];
            button.frame = CGRectMake(currentButton.frame.origin.x+currentButton.frame.size.width-12, 0, KButtonWidth, KButtonHeight);
        } else if (i == 1) {
            button = [LoopButtonManager buttonWithLoopButtonType:KLoopButtonTypeMiddle];
            button.frame = CGRectMake(currentButton.frame.origin.x+currentButton.frame.size.width-12, 30, KButtonWidth, KButtonHeight);
        } else if (i == 3) {
            button = [LoopButtonManager buttonWithLoopButtonType:KLoopButtonTypeMiddle];
            button.frame = CGRectMake(currentButton.frame.origin.x+currentButton.frame.size.width, 30, KButtonWidth, KButtonHeight);
        } else {
            button = [LoopButtonManager buttonWithLoopButtonType:KLoopBUttonTypeLarge];
            button.frame = CGRectMake(currentButton.frame.origin.x+currentButton.frame.size.width, 35, KButtonWidth, KButtonHeight);
        }
    
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor]];
        button.tag = 10000 + i;
//        [button setImage:[UIImage imageNamed:self.iconArr[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:self.iconArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOperation:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.loopButtons addObject:button];
        currentButton = button;
    }
}

#pragma - mark 添加手势
- (void)addGesture {
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:recognizer];
    [self addGestureRecognizer:recognizerLeft];
}

# pragma - mark 转换方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGesture {
    
    if(swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        //交换每个button的frame （0 变成 4 4 变成 3 3 变成 2 2 变成 1 1 变成 0 ）
        LoopButton *tempButtonFirst = self.loopButtons[0];
        LoopButton *tempButtonSecond = self.loopButtons[1];
        LoopButton *tempButtonthird = self.loopButtons[2];
        LoopButton *tempButtonFourth = self.loopButtons[3];
        LoopButton *tempButtonFifth = self.loopButtons[4];
        
        CGRect firstFrame = tempButtonFirst.frame;
        CGRect secondFrame = tempButtonSecond.frame;
        CGRect thirdFrame = tempButtonthird.frame;
        CGRect fourthFrame = tempButtonFourth.frame;
        CGRect fifthFrame = tempButtonFifth.frame;
        
        [self animationWithLoopButton:tempButtonFirst toFrame:fifthFrame];
        [self animationWithLoopButton:tempButtonSecond toFrame:firstFrame];
        [self animationWithLoopButton:tempButtonthird toFrame:secondFrame];
        [self animationWithLoopButton:tempButtonFourth toFrame:thirdFrame];
        [self animationWithLoopButton:tempButtonFifth toFrame:fourthFrame];
        
        [UIView animateWithDuration:0.5 animations:^{
            tempButtonFirst.frame = fifthFrame;
            tempButtonSecond.frame = firstFrame;
            tempButtonthird.frame = secondFrame;
            tempButtonFourth.frame = thirdFrame;
            tempButtonFifth.frame = fourthFrame;
        } completion:^(BOOL finished) {

        }];
        
    }
    
    if(swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        //交换每个button的frame （0 变成 1 1 变成 2 2 变成 3 3 变成 4 4 变成 0 ）
        LoopButton *tempButtonFirst = self.loopButtons[0];
        LoopButton *tempButtonSecond = self.loopButtons[1];
        LoopButton *tempButtonthird = self.loopButtons[2];
        LoopButton *tempButtonFourth = self.loopButtons[3];
        LoopButton *tempButtonFifth = self.loopButtons[4];
        
        CGRect firstFrame = tempButtonFirst.frame;
        CGRect secondFrame = tempButtonSecond.frame;
        CGRect thirdFrame = tempButtonthird.frame;
        CGRect fourthFrame = tempButtonFourth.frame;
        CGRect fifthFrame = tempButtonFifth.frame;
        
        [self animationWithLoopButton:tempButtonFirst toFrame:secondFrame];
        [self animationWithLoopButton:tempButtonSecond toFrame:thirdFrame];
        [self animationWithLoopButton:tempButtonthird toFrame:fourthFrame];
        [self animationWithLoopButton:tempButtonFourth toFrame:fifthFrame];
        [self animationWithLoopButton:tempButtonFifth toFrame:firstFrame];
        
        [UIView animateWithDuration:0.5 animations:^{
            tempButtonFirst.frame = secondFrame;
            tempButtonSecond.frame = thirdFrame;
            tempButtonthird.frame = fourthFrame;
            tempButtonFourth.frame = fifthFrame;
            tempButtonFifth.frame = firstFrame;
        } completion:^(BOOL finished) {
            
//            [tempButtonFirst setAnimiTion];
//            [tempButtonSecond setAnimiTion];
//            [tempButtonthird setAnimiTion];
//            [tempButtonFourth setAnimiTion];
//            [tempButtonFifth setAnimiTion];
        }];
    }
    
}


#pragma -mark animationCorberRadius
- (void)animationWithLoopButton:(LoopButton *)loopButton toFrame:(CGRect)frame {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:loopButton.frame.size.width/2];
    animation.toValue = [NSNumber numberWithFloat:frame.size.width/2];
    animation.duration = 0.3;
    [loopButton.layer setCornerRadius:frame.size.width/2];
    [loopButton.layer addAnimation:animation forKey:@"cornerRadius"];
}

#pragma mark -mark   点击button触犯方法
- (void)clickOperation:(LoopButton *)loopButton {
    
    NSLog(@"%@", loopButton.titleLabel.text);
    
    if (self.dianJiBlack) {
        
        self.dianJiBlack(loopButton);
    }
    
    
    
}

- (NSArray *)titles {
    if (!_titles) {
        
        _titles = @[@"社区服务",@"社区物业",@"社区购物",@"社区圈子",@"社区政务"];
    }
    return _titles;
}


- (NSArray *)iconArr
{
    if (!_iconArr) {
    
        _iconArr = @[@"ZT1", @"ZT2", @"ZT3", @"ZT4", @"ZT5"];
    }
    
    return _iconArr;
}

@end
