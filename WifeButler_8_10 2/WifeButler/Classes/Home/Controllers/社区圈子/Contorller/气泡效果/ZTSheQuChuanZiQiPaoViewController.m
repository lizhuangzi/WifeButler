//
//  ZTSheQuChuanZiQiPaoViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/7.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuChuanZiQiPaoViewController.h"
#import "ZTQiPaoCellTableViewCell.h"

@interface ZTSheQuChuanZiQiPaoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *colorArray;
@property (strong, nonatomic) NSMutableArray *imageVArray;


@end

@implementation ZTSheQuChuanZiQiPaoViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.451 alpha:1.000];
    
    self.colorArray = [[NSMutableArray alloc] initWithObjects:@"我的动态",@"发布动态", nil];
    
    self.imageVArray = [[NSMutableArray alloc] initWithObjects:@"ZTQuanZi11",@"ZTQuanZi22", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.colorArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"ZTQiPaoCellTableViewCell";
    
    ZTQiPaoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZTQiPaoCellTableViewCell" owner:nil options:nil] firstObject];
    }

    cell.titleLab.text = [NSString stringWithFormat:@"%@", self.colorArray[indexPath.row]];
    
    cell.iconImageView.image = [UIImage imageNamed:self.imageVArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.typeBlack) {
        
        int a = (int)indexPath.row;
        
        self.typeBlack(a);
    }
}

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    
    if (self.presentingViewController && self.tableView != nil) {
        
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 100;
        
        CGSize size = [self.tableView sizeThatFits:tempSize];  //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        return size;
    }
    else
    {
        return [super preferredContentSize];
    }
    
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    
    super.preferredContentSize = preferredContentSize;
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
