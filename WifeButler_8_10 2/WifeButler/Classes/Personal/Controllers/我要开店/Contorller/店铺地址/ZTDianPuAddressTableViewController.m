//
//  ZTDianPuAddressTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDianPuAddressTableViewController.h"
#import "ZTAddressPickView.h"
#import "ZTXiaoQuXuanZeViewController.h"

@interface ZTDianPuAddressTableViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

// 控件
@property (nonatomic, strong) ZTAddressPickView * addressPV;
@property (nonatomic, assign) int component0;
@property (nonatomic, assign) int component1;
@property (nonatomic, assign) int component2;
@property (nonatomic, strong) NSMutableArray * addressArray;

// 省市区
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
// 小区地址
@property (weak, nonatomic) IBOutlet UILabel *xiaoQuLab;
// 详细地址
@property (weak, nonatomic) IBOutlet UITextView *xiangQiAddressTV;




/**
 *  省id
 */
@property (nonatomic, copy) NSString * sheng_id;

/**
 *  市id
 */
@property (nonatomic, copy) NSString * shi_id;

/**
 *  区id
 */
@property (nonatomic, copy) NSString * qu_id;

/**
 *  小区id
 */
@property (nonatomic, copy) NSString * xiaoQu_id;




@end

@implementation ZTDianPuAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的开店";
    
    self.addressArray = [NSMutableArray array];
    
    [self downLoadInfoDiQu];
}

#pragma mark - 省市区点击
- (IBAction)shenShiQuCLick:(id)sender {

    
    if (_addressArray.count == 0) {
        
        
        [SVProgressHUD showSuccessWithStatus:@"省市区数据正在请求中,请稍后..."];
        return;
    }
    
    [self getCityPicker];
}


- (ZTAddressPickView *)addressPV
{
    if (!_addressPV) {
        
        _addressPV = [[[NSBundle mainBundle] loadNibNamed:@"ZTAddressPickView" owner:self options:nil] firstObject];
        
        _addressPV.frame = CGRectMake(0, iphoneHeight, iphoneWidth, 200);
    }
    
    return _addressPV;
}

// 设置cityPicker的代理
- (void)getCityPicker
{
    
    self.addressPV.ZTPickView.showsSelectionIndicator = YES;
    self.addressPV.ZTPickView.delegate = self;
    self.addressPV.ZTPickView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    
    // 完成
    [self.addressPV setDoneBlack:^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.addressPV.frame = CGRectMake(0, iphoneHeight, iphoneWidth, 200);
        }];
        
    }];
    
    [self.tableView.superview addSubview:self.addressPV];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.addressPV.frame =  CGRectMake(0, iphoneHeight - 200, iphoneWidth, 200);
    }];
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        
        return _addressArray.count;
        
    }else if (component==1){
        
        return [[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] count];
        
    }else{
        
        return [[[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:_component1] objectForKey:@"list_b"] count];
    }
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component==0) {
        
        return [[_addressArray objectAtIndex:row] objectForKey:@"name"];
        
    }else if (component==1){
        
        return [[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:row] objectForKey:@"name"];
        
    }else{
        
        return [[[[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:_component1] objectForKey:@"list_b"] objectAtIndex:row] objectForKey:@"name"];
    }
}

// 监听pickerView选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        
        _component0 = (int)row;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        _component1 = 0;
        [pickerView selectRow:0 inComponent:2 animated:YES];
        _component2 = 0;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
    }else if (component==1){
        
        _component1 = (int)row;
        [pickerView selectRow:0 inComponent:2 animated:YES];
        _component2 = 0;
        [pickerView reloadComponent:2];
        
    }else if (component == 2){
        
        _component2 = (int)row;
        
    }
    
    NSString * province = [[_addressArray objectAtIndex:_component0] objectForKey:@"name"];
    
    NSString * city = [[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:_component1] objectForKey:@"name"];
    
    NSString * area = [[[[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:_component1] objectForKey:@"list_b"] objectAtIndex:_component2] objectForKey:@"name"];
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    
    self.sheng_id = [[_addressArray objectAtIndex:_component0] objectForKey:@"id"];
    self.shi_id = [[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:_component1] objectForKey:@"id"];
    self.qu_id = [[[[[[_addressArray objectAtIndex:_component0] objectForKey:@"list_a"] objectAtIndex:_component1] objectForKey:@"list_b"] objectAtIndex:_component2] objectForKey:@"id"];

    self.addressTF.text = address;
}


#pragma mark - 数据省市区
- (void)downLoadInfoDiQu
{
    
    if (NSGetUserDefaults(@"ztCC") != nil) {
        
        _addressArray = [NSKeyedUnarchiver unarchiveObjectWithData:NSGetUserDefaults(@"ztCC")];;
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KShenShiQuAddress];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _addressArray = responseObject[@"resultCode"];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_addressArray];
            
            NSSaveUserDefaults(data, @"ztCC");
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
    
}

- (IBAction)xiaoQuXuanZheClick:(id)sender {
    
    if (self.qu_id.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先选择省市区哦!"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiShouHuoDiZhi" bundle:nil];
    ZTXiaoQuXuanZeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTXiaoQuXuanZeViewController"];
    vc.address_id = self.qu_id;
    
    __weak typeof(self) weakSelf = self;
    
    [vc setAddressBlack:^(ZTXiaoQuXuanZe *model) {
        
        weakSelf.xiaoQuLab.text = model.village;
        weakSelf.xiaoQu_id = model.id;
        
        if (self.xiaoQuBlack) {
            
            self.xiaoQuBlack(model.village);
        }
    
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据提交
- (void)netWorking
{
    if (self.xiaoQu_id.length == 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"小区地址不能为空哦!"];
        return;
    }
    
    if (self.xiangQiAddressTV.text.length == 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"详细地址不能为空哦!"];
        return;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
//    [dic setObject:KToken forKey:@"token"];
    [dic setObject:NSGetUserDefaults(@"ZTserve_id") forKey:@"id"];
    [dic setObject:self.xiaoQu_id forKey:@"village_id"];
    [dic setObject:self.xiangQiAddressTV.text forKey:@"address"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KWoDeDianPuAddress];;
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            
            NSSaveUserDefaults(@"1", @"ZTAddressZT");
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;

                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
            }
            

        }
    
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
 
    }];
    
}

- (IBAction)saveClick:(id)sender {
    
    [self netWorking];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
