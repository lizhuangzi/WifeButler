//
//  ZTDianPuXinXiTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDianPuXinXiTableViewController.h"
#import "ZTAddressPickView.h"
#import "ZTShenPiDianPuViewController.h"
#import "NSString+ZJMyJudgeString.h"
#import "ZTDianPuAddressTableViewController.h"


@interface ZTDianPuXinXiTableViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic, strong) NSMutableArray *dataSource;

//后台返回的店铺id    全局变量
@property (nonatomic, copy) NSString * type_id;

// 相机
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *imageIcon;


@property (nonatomic, strong) NSArray * YinYeTimeArr;

@property (nonatomic, strong) ZTAddressPickView * timePV;


@property (weak, nonatomic) IBOutlet UITextField *yinYeShiJianTF;

@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) int  component4;
@property (nonatomic, assign) int  component5;

// 小区名称
@property (weak, nonatomic) IBOutlet UILabel *xiaoquNameLab;


@end

@implementation ZTDianPuXinXiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPram];
    
    [self netWorking];
}

- (void)setPram
{
    self.btn1.selected = YES;
    self.btn2.selected = YES;
    
    self.title = @"我的开店";
    
    self.YinYeTimeArr = @[@"0点", @"1点", @"2点", @"3点", @"4点", @"5点", @"6点", @"7点", @"8点", @"9点", @"10点", @"11点", @"12点", @"13点", @"14点", @"15点", @"16点", @"17点", @"18点", @"19点", @"20点", @"21点", @"22点", @"23点"];
    

    self.iphoneTF.delegate = self;
    
    [self.shopNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (ZTAddressPickView *)timePV
{
    if (!_timePV) {
        
        _timePV = [[[NSBundle mainBundle] loadNibNamed:@"ZTAddressPickView" owner:self options:nil] firstObject];
        
        _timePV.frame = CGRectMake(0, iphoneHeight, iphoneWidth, 200);
    }
    
    return _timePV;
}

#pragma mark - 营业时间
- (IBAction)yingYeTime:(id)sender {
    
    [self createPickView];
}


#pragma mark - 时间选择
- (void)createPickView
{
    self.timePV.ZTPickView.showsSelectionIndicator = YES;
    self.timePV.titleLab.text = @"营业时间";
    self.timePV.ZTPickView.delegate = self;
    self.timePV.ZTPickView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    
    // 完成
    [self.timePV setDoneBlack:^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.timePV.frame = CGRectMake(0, iphoneHeight, iphoneWidth, 200);
        }];
        
        //        ZJLog(@"%ld", self.timePV.ZTPickView.numberOfComponents);
        
        weakSelf.yinYeShiJianTF.text = weakSelf.timeStr;
    }];
    
    [self.tableView.superview addSubview:self.timePV];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.timePV.frame =  CGRectMake(0, iphoneHeight - 200, iphoneWidth, 200);
    }];
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return _YinYeTimeArr.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    

    return _YinYeTimeArr[row];
    
    
}

// 监听pickerView选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component == 0) {
        
        self.component4 = (int)row;
    }
    else
    {
        
        self.component5 = (int)row;
    }
    
    self.timeStr = [NSString stringWithFormat:@"%@-%@", _YinYeTimeArr[self.component4], _YinYeTimeArr[self.component5]];
    
}




#pragma mark - 头像
- (IBAction)touXiangClick:(id)sender {
    
    [self backgroundView_Clicked];
}


#pragma mark - 类型
- (IBAction)typeClick:(id)sender {
    
    if (self.dataSource.count == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"数据正在请求,请稍后!"];
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"请选择类型" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < self.dataSource.count; i++) {
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:weakSelf.dataSource[i][@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            weakSelf.typeLab.text = weakSelf.dataSource[i][@"name"];
            
            weakSelf.type_id = weakSelf.dataSource[i][@"id"];
        }];
        
        [vc addAction:otherAction];
    }
    
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


#pragma mark - 商品类型请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    [dic setObject:NSGetUserDefaults(@"Shop_type") forKey:@"serve_id"];

    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KWoDeDianPuType];

    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
        
            self.dataSource = responseObject[@"resultCode"];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
     
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    
        
    }];
    
}


// 头像上传
- (void)backgroundView_Clicked
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Choose" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAC = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self imageToCamera];
        
    }];
    UIAlertAction *alertAC1 = [UIAlertAction actionWithTitle:@"选取相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self imageToPhoto];
    }];
    UIAlertAction *alertAC2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:alertAC];
    [alertVC addAction:alertAC1];
    [alertVC addAction:alertAC2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//  选择相册
- (void)imageToPhoto
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

/*选择相机*/
-(void)imageToCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.imagePicker.allowsEditing =YES;
        
        //设置拍照后的图片可被编辑
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = sourceType;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"暂时不能打开相机需真机");
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _imageIcon = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.iconImageView setImage:_imageIcon];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 申请开店
- (void)netWorkingShenQin
{
    if (self.shopNameTF.text.length < 1  || self.shopNameTF.text.length > 15) {
        
        [SVProgressHUD showErrorWithStatus:@"店铺名称不合理哦!"];
        return;
    }
    
    if ([NSString validateMobile:self.iphoneTF.text] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确!"];
        return;
    }
    
    if (self.timeTF.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"营业时间不能够为空哦!"];
        return;
    }
    
    if (self.imageIcon == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"图片不能为空哦!"];
        return;
    }
    
    if ([NSGetUserDefaults(@"ZTAddressZT") intValue] != 1) {
        
        [SVProgressHUD showErrorWithStatus:@"开店地址没有填写哦!"];
        return;
    }
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:NSGetUserDefaults(@"ZTserve_id") forKey:@"id"];
    [dic setObject:NSGetUserDefaults(@"Shop_type") forKey:@"serve_id"];
    [dic setObject:self.shopNameTF.text forKey:@"shop_name"];
    [dic setObject:self.iphoneTF.text forKey:@"mobile"];
    [dic setObject:KToken forKey:@"token"];
    
    NSArray *timeArr = [self.timeTF.text componentsSeparatedByString:@"-"];
    
    [dic setObject:timeArr[0] forKey:@"start_time"];
    [dic setObject:timeArr[1] forKey:@"end_time"];
    [dic setObject:self.type_id forKey:@"type"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KWoDeDianPuXinXi];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (self.imageIcon != nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(self.imageIcon, .5);
            
            [formData appendPartWithFileData:imageData name:@"shop_pic" fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
            
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"信息提交成功, 等待审核"];
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
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

- (IBAction)shenQinClick:(id)sender {
    
    [self netWorkingShenQin];
}

#pragma mark - 店铺地址
- (IBAction)dianPuAddressClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
    ZTDianPuAddressTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTDianPuAddressTableViewController"];
    
    __weak typeof(self) weakSelf = self;
    
    // 显示小区名称
    [vc setXiaoQuBlack:^(NSString *xiaoQu) {
        
        weakSelf.xiaoquNameLab.text = xiaoQu;
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 限制密码的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.iphoneTF) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 11) {
            
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidChange:(id)sender
{
    if (self.shopNameTF.text.length > 9)  // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.shopNameTF.text = [self.shopNameTF.text substringToIndex:9];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
