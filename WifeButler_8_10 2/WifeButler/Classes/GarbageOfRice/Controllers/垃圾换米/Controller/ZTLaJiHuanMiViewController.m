//
//  ZTLaJiHuanMiViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLaJiHuanMiViewController.h"
#import "ZTZhiHuanTiJiaoViewController.h"
#import "RCRNetWorkPort.h"
#import "PhotosScrollView.h"
#import "PhotoBrowserGetter.h"
#import "WifeButlerNetWorking.h"
#import "ExchangeDetailTableViewCell.h"
#import "Masonry.h"
#import "NetWorkPort.h"

@interface ZTLaJiHuanMiViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) PhotoBrowserGetter * browserGetter;

@property (nonatomic,strong) NSMutableDictionary * dataDict;
@property (nonatomic, strong)NSMutableArray*imgAry;
@property (nonatomic,assign) BOOL Flag;
@property (nonatomic,assign) CGFloat webCellH;
@end

@implementation ZTLaJiHuanMiViewController

- (NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

-(NSMutableArray*)imgAry
{
    if (!_imgAry) {
        _imgAry=[[NSMutableArray alloc]init];
    }
    return _imgAry;
}

#pragma mark - 置换

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"兑换详情";
    self.tableView.allowsSelection = NO;
    self.webCellH = 0;
    self.Flag = NO;
    [self createFooterView];
    [self requestHttpData];
}
- (void)requestHttpData
{
    NSDictionary * parm = @{@"goods_id":self.good_id};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KexchangeDetail parameter:parm success:^(NSDictionary * resultCode) {
        
        self.dataDict.dictionary = resultCode;
        NSString *imgStr = [self.dataDict objectForKey:@"gallery"];
        NSArray *array = [imgStr componentsSeparatedByString:@","];
        for (int i = 0; i < [array count]; i ++) {
            
            NSString *str = [NSString stringWithFormat:@"%@%@",KImageUrl,[array objectAtIndex:i]];
            [self.imgAry addObject:str];
        }
        [self createScorllViewWuWang:self.imgAry];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createFooterView
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 55)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = WifeButlerCommonRedColor;
    [btn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(zhiHuanClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(20);
        make.right.mas_equalTo(backView.mas_right).offset(-20);
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.height.mas_equalTo(44);
    }];
    
    self.tableView.tableFooterView = backView;
}

//设置头部滚动视图
- (void)createScorllViewWuWang:(NSArray *)imageArr
{
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight*0.5)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight*0.5 +1)];
    [headerView addSubview:view];
    self.tableView.tableHeaderView = headerView;
    //顶部滑动浏览视图
    PhotosScrollView * photoScro = [[PhotosScrollView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view addSubview:photoScro];
    photoScro.imageUrlStrings = imageArr;
    
    WEAKSELF
    [photoScro setTapImageBlock:^(NSUInteger   currentIndex, NSArray * imageUrls) {
        weakSelf.browserGetter = [PhotoBrowserGetter browserGetter];
        UIViewController * vc = [weakSelf.browserGetter getBrowserWithCurrentIndex:currentIndex andimageURLStrings:imageUrls];
        
        if (weakSelf.navigationController) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else
            [weakSelf.parentViewController.navigationController  pushViewController:vc animated:YES];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ExchangeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeDetailTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ExchangeDetailTableViewCell" owner:nil options:nil].lastObject;
        }
        cell.title.text = self.dataDict[@"title"];
        cell.exchangeCountLabel.text = [NSString stringWithFormat:@" %@次兑换",self.dataDict[@"sales"]];
        cell.orginnalLabel.text = [NSString stringWithFormat:@"原价：¥%@",self.dataDict[@"oldprice"]];
        cell.nowMoneylabel.text = [NSString stringWithFormat:@"%@/%@",self.dataDict[@"scale"],self.dataDict[@"danwei"]];
        return cell;
    }else if(indexPath.row == 1){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"abc"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
            UIWebView * web = [[UIWebView alloc]init];
            web.delegate = self;
            [cell.contentView addSubview:web];
            [web setBackgroundColor:[UIColor whiteColor]];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@?goods_id=%@",HTTP_BaseURL,KGoodDetailWebViewURL,self.good_id];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [web loadRequest:request];
            
            web.frame = CGRectMake(0, 0, iphoneWidth, 30);
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 110;
    }else{
        if (self.webCellH == 0) {
            return 1;
        }
        return self.webCellH;
    }
}

#pragma mark - webViewDatelate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    webView.contentScaleFactor
    CGSize size = webView.scrollView.contentSize;
    
    // ZJLog(@"%@", size);
    webView.size = size;
    
    
    if (self.Flag == NO) {
        
        self.Flag = YES;
        
        self.webCellH = size.height;
        
        [self.tableView reloadData];
        
    }

        
    // [webView layoutIfNeeded];
    
}


- (IBAction)zhiHuanClick:(id)sender {
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGarbageOfRice" bundle:nil];
    ZTZhiHuanTiJiaoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTZhiHuanTiJiaoViewController"];
    vc.good_id = self.good_id;
    //  vc.pname = _model.title;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
