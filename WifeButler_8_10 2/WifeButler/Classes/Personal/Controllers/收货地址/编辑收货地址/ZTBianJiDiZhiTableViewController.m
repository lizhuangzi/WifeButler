//
//  ZTBianJiDiZhiTableViewController.m
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTBianJiDiZhiTableViewController.h"
#import "ZTAddressPickView.h"
#import "ZTXiaoQuXuanZeViewController.h"
#import "ZTXiaoQuXuanZe.h"
#import "NSString+ZJMyJudgeString.h"
#import "ZJLoginController.h"


@interface ZTBianJiDiZhiTableViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *queRenBtn;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;


// 地址
@property (nonatomic, strong) NSArray * addressArray;
@property (nonatomic, strong) ZTAddressPickView * addressPV;
@property (nonatomic, assign) int component0;
@property (nonatomic, assign) int component1;
@property (nonatomic, assign) int component2;

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

// 小区地址
@property (weak, nonatomic) IBOutlet UILabel *xiaoQuLab;


@end

@implementation ZTBianJiDiZhiTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self isBianJiAddress];
    
    self.queRenBtn.layer.cornerRadius = 5;
    
    self.addressArray = [NSMutableArray array];
    
//    NSString *str = [[NSBundle mainBundle] pathForResource:@"citydata.plist" ofType:nil];
//    _addressArray = [NSArray arrayWithContentsOfFile:str];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(queRenBtn1)];
    
    [self setPram];
    
    [self downLoadInfoDiQu];
}

- (void)setPram
{
    self.nameTextF.delegate = self;
    self.iphoneTextF.delegate = self;
    self.youBianTextF.delegate = self;
    
    [self.nameTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}


- (IBAction)xiaoQuClick:(UIButton *)sender {
    
    if (self.qu_id.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先选择省市区哦!"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiShouHuoDiZhi" bundle:nil];
    ZTXiaoQuXuanZeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTXiaoQuXuanZeViewController"];
    vc.address_id = self.qu_id;
    [vc setAddressBlack:^(ZTXiaoQuXuanZe *model) {
       
        self.xiaoQuLab.text = model.village;
        self.xiaoQu_id = model.id;
        NSSaveUserDefaults(model.longitude, @"jing");
        NSSaveUserDefaults(model.latitude, @"wei");
        NSSaveUserDefaults(model.village, @"xiaoQu");
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)queRenBtn1
{
    [self downLoadInfo];
}

- (void)isBianJiAddress
{
    if (self.isAddAddress == YES) {
        
        self.title = @"添加收货地址";
    }
    else
    {
        self.title = @"编辑收货地址";
    }
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


#pragma mark - 数据
- (void)downLoadInfo
{
    
    if ([NSString isShouHuoRen:self.nameTextF.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"收货人格式不正确"];
        return;
    }
    
    if ([NSString validateMobile:self.iphoneTextF.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if ([self.sheng_id length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"省市区不能为空哦!"];
        return;
    }
    if ([self.address2TextV.text length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"详细地址不能为空哦!"];
        return;
    }
    if ([self.xiaoQu_id length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"小区不能为空哦!"];
        return;
    }
    
    if ([NSString isValidZipcode:self.youBianTextF.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"邮编格式错误"];
        return;
    }
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.nameTextF.text forKey:@"realname"];
    [dic setObject:self.iphoneTextF.text forKey:@"phone"];
    [dic setObject:self.sheng_id forKey:@"pro"];
    [dic setObject:self.shi_id forKey:@"city"];
    [dic setObject:self.qu_id forKey:@"qu"];
    [dic setObject:self.youBianTextF.text forKey:@"post"];
    [dic setObject:self.address2TextV.text forKey:@"address"];
    [dic setObject:self.xiaoQu_id forKey:@"village"];
    
    // 是默认地址
    if (_isMoRenAddress.on == YES) {
        
        [dic setObject:@"2" forKey:@"defaults"];
    }
    else// 不是默认地址
    {
        [dic setObject:@"1" forKey:@"defaults"];
    }
   
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KAddShouHuoAddress];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            
            if (self.relshBlack) {
                
                self.relshBlack();
            }
            
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

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
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
    self.xiaoQuLab.text = @"";
    self.xiaoQu_id = @"";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)shenShiQuBtn:(id)sender {
    
    if (_addressArray.count == 0) {
        
        
        [SVProgressHUD showSuccessWithStatus:@"省市区数据正在请求中,请稍后..."];
        return;
    }
    
    [self getCityPicker];
}

// 限制密码的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.iphoneTextF) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 11) {
            
            return NO;
        }
    }
    
    if (textField == self.youBianTextF) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 6) {
            
            return NO;
        }
    }

    return YES;
}

- (void)textFieldDidChange:(id)sender
{
    if (self.nameTextF.text.length > 9)  // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.nameTextF.text = [self.nameTextF.text substringToIndex:9];
    }
}



@end
