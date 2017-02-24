//
//  EPCalendarViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "EPCalendarViewController.h"
#import "Masonry.h"
@interface EPCalendarViewController ()

@property (nonatomic,strong) CustomCalendarViewController * calendarView;

@end

@implementation EPCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"环保日历";
    
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    
    self.calendarView = [[CustomCalendarViewController alloc]init];
    [self.view addSubview:self.calendarView.view];
    [self.calendarView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
