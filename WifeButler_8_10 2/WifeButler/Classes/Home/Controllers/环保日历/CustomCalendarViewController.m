//
//  CustomCalendarViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CustomCalendarViewController.h"

@interface CustomCalendarViewController ()
//存放日期的view
@property (nonatomic,weak) UIView * dateBackView;
//用于进行交替的view
@property (nonatomic,strong) NSDate * currentShowingDate;
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
    
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor redColor];
        label.frame = CGRectMake(itemW * i, 0, itemW, itemH);
        label.textAlignment = NSTextAlignmentCenter;
        [weekBg addSubview:label];
    }

    
    UIView * dateView = [[UIView alloc]init];
    [self.view addSubview:dateView];
    dateView.frame = CGRectMake(0, weekBg.height, self.view.width, 210);
    dateView.backgroundColor = [UIColor whiteColor];
    self.dateBackView = dateView;
    
    NSDate * date = [NSDate date];
    self.currentShowingDate = date;
    [self createDateButtonWithDate:date];
    
    !self.swipCalenderBlock?:self.swipCalenderBlock(date);
    
    UISwipeGestureRecognizer * swip1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panCalender:)];
    [swip1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.dateBackView addGestureRecognizer:swip1];
    
    UISwipeGestureRecognizer * swip2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panCalender:)];
    [swip2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.dateBackView addGestureRecognizer:swip2];
    
    
}

- (void)panCalender:(UISwipeGestureRecognizer *)swip
{
    
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        
        CATransition * ani = [CATransition animation];
        ani.duration = 0.75;
        ani.type = @"pageUnCurl";
        [self.dateBackView.layer addAnimation:ani forKey:nil];
        
        self.currentShowingDate = [self lastMonth:self.currentShowingDate];
        [self createDateButtonWithDate:self.currentShowingDate];
        
    }else if (swip.direction == UISwipeGestureRecognizerDirectionLeft){
        
        CATransition * ani = [CATransition animation];
        ani.duration = 0.75;
        ani.type = @"pageCurl";
        [self.dateBackView.layer addAnimation:ani forKey:nil];

        self.currentShowingDate = [self nextMonth:self.currentShowingDate];
        [self createDateButtonWithDate:self.currentShowingDate];
    }
    !self.swipCalenderBlock?:self.swipCalenderBlock(self.currentShowingDate);
}

- (void)createDateButtonWithDate:(NSDate *)date
{
    BOOL needCreate = YES;
    if (self.dateBackView.subviews.count>0) {
        needCreate = NO;
    }
    CGFloat marginH = 5;
    CGFloat itemH = 30;
    CGFloat itemW = self.view.width/7;
    // 1.分析这个月的第一天是第一周的星期几
    NSInteger firstWeekday = [self firstWeekdayInThisMotnth:date];
    
    // 2.分析这个月有多少天
    NSInteger dayInThisMonth = [self totaldaysInMonth:date];
    
    for (int i = 0; i < 42; i ++) {
        CustomredPointButton *button = nil;
        if (needCreate) {
            
            button = [[CustomredPointButton alloc] init];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            int x = (i % 7) * itemW ;
            int y = marginH + (i / 7) * (itemH + marginH) ;
            
            button.frame = CGRectMake(x, y, itemW, itemH);

            [self.dateBackView addSubview:button];
        }else{
            button = self.dateBackView.subviews[i];
            button.showRedPoint = NO;
            button.day = 0;
            [button setTitle:@"" forState:UIControlStateNormal];
            [button removeTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            //            day = dayInLastMonth - firstWeekday + i + 1;
            continue;
        }else if (i > firstWeekday + dayInThisMonth - 1){
            //            day = i + 1 - firstWeekday - dayInThisMonth;
            continue;
        }else{
            day = i - firstWeekday + 1;
            button.day = day;
        }
        
        [button setTitle:[NSString stringWithFormat:@"%d",(int)day] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)setCurrentRedday:(NSUInteger)currentRedday
{
    _currentRedday = currentRedday;
    CustomredPointButton * btn = [self getButtonByDay:currentRedday];
    btn.showRedPoint = YES;
}
- (void)dateBtnClick:(CustomredPointButton *)button
{
    !self.selectDayblock?:self.selectDayblock(self.currentShowingDate,button.day);
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


- (NSDate *)nextMonth:(NSDate *)date
{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.month = 1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;

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

/**根据当前的日获取对应UI按钮*/
- (CustomredPointButton *)getButtonByDay:(NSUInteger)day{
    
    NSInteger firstWeekday = [self firstWeekdayInThisMotnth:self.currentShowingDate];
    CustomredPointButton * btn = self.dateBackView.subviews[firstWeekday + day - 1];
    return btn;
}

@end

@interface CustomredPointButton ()

@property (nonatomic,weak) CALayer * redLayer;

@end

@implementation CustomredPointButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CALayer * redLayer = [CALayer layer];
        redLayer.backgroundColor = WifeButlerCommonRedColor.CGColor;
        redLayer.bounds = CGRectMake(0, 0, 5, 5);
        redLayer.cornerRadius = 2.5;
        redLayer.hidden = YES;
        [self.layer addSublayer:redLayer];
        self.redLayer = redLayer;
        self.day = 0;
    }
    return self;
}

- (void)setShowRedPoint:(BOOL)showRedPoint
{
    _showRedPoint = showRedPoint;
    if (_showRedPoint) {
        self.redLayer.hidden = NO;
        self.redLayer.position = CGPointMake(self.width-8, 4);
    }else{
        self.redLayer.hidden = YES;
    }
}

@end

