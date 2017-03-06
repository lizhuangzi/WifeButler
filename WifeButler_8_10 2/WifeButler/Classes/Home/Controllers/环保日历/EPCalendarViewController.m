//
//  EPCalendarViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "EPCalendarViewController.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"
#import "WifeButlerNetWorking.h"
#import "NetWorkPort.h"
#import "EPCalendarModel.h"

@interface EPCalendarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) CustomCalendarViewController * calendarView;
@property (nonatomic,strong) NSDateFormatter * dateFormatter;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,weak) UITableView * tableView;

@end

@implementation EPCalendarViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"环保日历";
    
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    [self createTable];
    [self initCalendarView];

    
}

- (void)createTable
{
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;
    table.allowsSelection = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tableView  = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}

- (void)initCalendarView
{
    self.calendarView = [[CustomCalendarViewController alloc]init];
    WEAKSELF
    [self.calendarView setSwipCalenderBlock:^(NSDate * date) {
        
        weakSelf.dateFormatter.dateFormat = @"yyyy-MM";
        NSString * dfStr = [weakSelf.dateFormatter stringFromDate:date];
        [weakSelf RequestOneMonthDataWithFormatDate:dfStr isRequestAllMonth:YES];
    }];
    
    [self.calendarView setSelectDayblock:^(NSDate * date,NSInteger day) {
        
        if (day == 0)   return ;
        weakSelf.dateFormatter.dateFormat = @"yyyy-MM";
        NSString * dfStr = [weakSelf.dateFormatter stringFromDate:date];
        NSString * finStr = [NSString stringWithFormat:@"%@-%.2zd",dfStr,day];
        [weakSelf RequestOneMonthDataWithFormatDate:finStr isRequestAllMonth:NO];
    }];
    
    [self.view addSubview:self.calendarView.view];
    [self.calendarView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.height.mas_equalTo(210);
    }];
}

- (void)RequestOneMonthDataWithFormatDate:(NSString *)dfStr isRequestAllMonth:(BOOL)isAllMonth
{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    WifeButlerUserParty * party = [WifeButlerAccount sharedAccount].userParty;
    parm[@"userid"] = party.Id;
    parm[@"nowdate"] = dfStr;
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KEPCalenderRequest parameter:parm success:^(NSArray * resultCode) {
        
        if (isAllMonth) {
            ZJLog(@"%@",resultCode);
            for (NSDictionary * dict in resultCode) {
                EPCalendarModel * model = [EPCalendarModel calendarModelWithDictionary:dict];
                self.calendarView.currentRedday = model.day;
            }
        }else{
            for (NSDictionary * dict in resultCode) {
                EPCalendarModel * model = [EPCalendarModel calendarModelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }
        
    } failure:^(NSError *error) {
        
        SVDCommonErrorDeal
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
