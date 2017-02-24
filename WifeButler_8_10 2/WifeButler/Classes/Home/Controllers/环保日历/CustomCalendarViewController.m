//
//  CustomCalendarViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CustomCalendarViewController.h"

@interface CustomCalendarViewController ()
@property (nonatomic,weak) UIView * dateBackView;
@end

@implementation CustomCalendarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray *array = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    UIView *weekBg = [[UIView alloc]init];
    CGFloat itemH = 30;
    CGFloat itemW = self.view.width/7;
    weekBg.frame = CGRectMake(0, 0, self.view.frame.size.width, itemH);
    [self.view addSubview:weekBg];
    
    UIView * dateView = [[UIView alloc]init];
    [self.view addSubview:dateView];
    dateView.frame = CGRectMake(0, weekBg.height, self.view.width, 200);
    dateView.backgroundColor = [UIColor whiteColor];
    self.dateBackView = dateView;
    
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor redColor];
        label.frame = CGRectMake(itemW * i, 0, itemW, itemH);
        label.textAlignment = NSTextAlignmentCenter;
        [weekBg addSubview:label];
    }
    
    NSDate * date = [NSDate date];
    // 1.分析这个月的第一天是第一周的星期几
    NSInteger firstWeekday = [self firstWeekdayInThisMotnth:date];
    
    // 2.分析这个月有多少天
    NSInteger dayInThisMonth = [self totaldaysInMonth:date];
    
    for (int i = 0; i < 42; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dateView addSubview:button];
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH ;
        
        button.frame = CGRectMake(x, y, itemW, itemH);
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            //            day = dayInLastMonth - firstWeekday + i + 1;
            continue;
        }else if (i > firstWeekday + dayInThisMonth - 1){
            //            day = i + 1 - firstWeekday - dayInThisMonth;
            continue;
        }else{
            day = i - firstWeekday + 1;
        }
        
        [button setTitle:[NSString stringWithFormat:@"%d",(int)day] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    
   
}

- (void)dateBtnClick:(UIButton *)button
{
    
}

- (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar]; // 取得当前用户的逻辑日历(logical calendar)
    
    [calendar setFirstWeekday:1]; //  设定每周的第一天从星期几开始，比如:. 如需设定从星期日开始，则value传入1 ，如需设定从星期一开始，则value传入2 ，以此类推
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comp setDay:1]; // 设置为这个月的第一天
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate]; // 这个月第一天在当前日历的顺序
    // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的顺序
    return firstWeekday - 1;
}


- (NSInteger)totaldaysInMonth:(NSDate *)date{
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]; // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    
    return daysInOfMonth.length;
}


// 日历的上一个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

// 获取日历的年份
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

// 获取日历的月份
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

// 获取日历的为第几天
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

@end
