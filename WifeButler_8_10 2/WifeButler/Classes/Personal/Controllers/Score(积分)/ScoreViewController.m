//
//  ScoreViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/13.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ScoreViewController.h"
#import "EPCalendarViewController.h"

@interface ScoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentScore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightCon;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分";
    //750  553
    
    self.imageHeightCon.constant = iphoneWidth*553/750;
    
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:@"当前积分："];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attStr.string.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attStr.string.length)];
    NSAttributedString * s = [[NSAttributedString alloc]initWithString:self.scoreTxt];
    [attStr appendAttributedString:s];
    [attStr addAttribute:NSForegroundColorAttributeName value:WifeButlerCommonRedColor range:NSMakeRange(5, s.length)];
    NSAttributedString * fen = [[NSAttributedString alloc]initWithString:@"分"];

    [attStr appendAttributedString:fen];
    self.currentScore.attributedText = attStr;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"环保日历" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
}

- (void)rightItemClick
{
    EPCalendarViewController * calendar = [[EPCalendarViewController alloc]init];
    [self.navigationController pushViewController:calendar animated:YES];
}

@end
