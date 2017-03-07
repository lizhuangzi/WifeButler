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
#import "EPCalenderTableViewCell.h"

@interface EPCalendarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) CustomCalendarViewController * calendarView;
@property (nonatomic,strong) NSDateFormatter * dateFormatter;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,weak) UITableView * tableView;

@property (nonatomic,strong) EPCalendarNoDataView * noDataView;

@end

@implementation EPCalendarViewController

- (EPCalendarNoDataView *)noDataView
{
    if (!_noDataView) {
        
        _noDataView = [[NSBundle mainBundle]loadNibNamed:@"EPCalendarNoDataView" owner:nil options:nil].firstObject;
        [_noDataView setClickBlock:^{
            
        }];
    }
    return _noDataView;
}

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
    [self showNoDataView];
}

- (void)createTable
{
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
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
        weakSelf.title = dfStr;
        [weakSelf hideNoDataView];
        [weakSelf RequestOneMonthDataWithFormatDate:dfStr isRequestAllMonth:YES];
    }];
    
    [self.calendarView setSelectDayblock:^(NSDate * date,NSInteger day) {
        
        if (day == 0)   return ;
        weakSelf.dateFormatter.dateFormat = @"yyyy-MM";
        NSString * dfStr = [weakSelf.dateFormatter stringFromDate:date];
        NSString * finStr = [NSString stringWithFormat:@"%@-%.2zd",dfStr,day];
        [weakSelf RequestOneMonthDataWithFormatDate:finStr isRequestAllMonth:NO];
    }];
    
   
    UIView * calendarbackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 240)];
    [calendarbackView addSubview: self.calendarView.view];
    [self.calendarView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(calendarbackView);
    }];
    self.tableView.tableHeaderView = calendarbackView;
}

- (void)RequestOneMonthDataWithFormatDate:(NSString *)dfStr isRequestAllMonth:(BOOL)isAllMonth
{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    WifeButlerUserParty * party = [WifeButlerAccount sharedAccount].userParty;
    parm[@"userid"] = party.Id;
    parm[@"nowdate"] = dfStr;
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KEPCalenderRequest parameter:parm success:^(NSArray * resultCode) {
        
        [self.dataArray removeAllObjects];
        if (isAllMonth) {
            ZJLog(@"%@",resultCode);
            for (NSDictionary * dict in resultCode) {
                EPCalendarModel * model = [EPCalendarModel calendarModelWithDictionary:dict];
                self.calendarView.currentRedday = model.day;
            }
            [self.tableView reloadData];
            [self showNoDataView];
        }else{
            
            for (NSDictionary * dict in resultCode) {
                EPCalendarModel * model = [EPCalendarModel calendarModelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            
            if (self.dataArray.count>0) {
                [self hideNoDataView];
            }else{
                [self showNoDataView];
            }
        }
        
    } failure:^(NSError *error) {
        
        SVDCommonErrorDeal
    }];
}

- (void)showNoDataView
{
    [self.view addSubview:self.noDataView];
    self.noDataView.width = 179;
    self.noDataView.height = 158;
    self.noDataView.y = iphoneHeight - 114 - 158;
    self.noDataView.x = iphoneWidth/2 - self.noDataView.width/2;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(270);
    }];
}

- (void)hideNoDataView
{
    [self.noDataView removeFromSuperview];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 45)];
    view.backgroundColor = WifeButlerTableBackGaryColor;
    
    CALayer * RedLayer = [CALayer layer];
    RedLayer.backgroundColor = WifeButlerCommonRedColor.CGColor;
    RedLayer.bounds = CGRectMake(0, 0, 8, 8);
    RedLayer.cornerRadius = 4;
    [view.layer addSublayer:RedLayer];
    RedLayer.position = CGPointMake(view.width - 20, 20);
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.font = [UIFont systemFontOfSize:14];
    label2.frame = CGRectMake(RedLayer.position.x - 75, 12, 70, 16);
    label2.text = @"兑换记录";
    [view addSubview:label2];
    
   
    CALayer * greenLayer = [CALayer layer];
    greenLayer.backgroundColor = HexCOLOR(@"#328d3d").CGColor;
    greenLayer.cornerRadius = 4;
    greenLayer.bounds = CGRectMake(0, 0, 8, 8);
    greenLayer.position = CGPointMake(label2.x - 20, 20);
    [view.layer addSublayer:greenLayer];
    
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.font = [UIFont systemFontOfSize:14];
    label1.frame = CGRectMake(greenLayer.position.x - 75, 12, 70, 16);
    label1.text = @"环保记录";
    [view addSubview:label1];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPCalenderTableViewCell * cell = [EPCalenderTableViewCell calenderTableViewCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

@end


@interface EPCalendarNoDataView ()

@end

@implementation EPCalendarNoDataView

- (IBAction)HowToClassify {
    
    !self.clickBlock?:self.clickBlock();
}


@end
