//
//  ZTShenPiDianPuViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTShenPiDianPuViewController.h"

@interface ZTShenPiDianPuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *shenQinTime;


@end

@implementation ZTShenPiDianPuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn1.selected = YES;
    self.btn2.selected = YES;
    self.btn3.selected = YES;
    
    self.title = @"我的开店";
    
    self.shenQinTime.text = [NSString stringWithFormat:@"开店申请时间:%@", self.apply_time];
}





- (NSString *)apply_time
{
    NSDate * createdDate =[NSDate dateWithTimeIntervalSince1970:[_apply_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return  [formatter stringFromDate:createdDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
