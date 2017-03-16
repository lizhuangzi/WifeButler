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
#import "PersonalPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "ZTBianjiModel.h"

@interface ZTBianJiDiZhiTableViewController ()<  UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *queRenBtn;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;

/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextF;

/**
 *  地址2
 */
@property (weak, nonatomic) IBOutlet UITextView *address2TextV;

/**
 *  默认地址
 */
@property (weak, nonatomic) IBOutlet UISwitch *isMoRenAddress;

@property (weak, nonatomic) IBOutlet UIButton *sirBtn;
@property (weak, nonatomic) IBOutlet UIButton *ladyBtn;

@property (nonatomic,weak) UIButton * currentSelectSexBtn;


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


@property (nonatomic,strong) ZTBianjiModel * dataModel;
@end

@implementation ZTBianJiDiZhiTableViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self isBianJiAddress];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.queRenBtn.layer.cornerRadius = 5;
    
    [self setPram];
}
- (IBAction)sureClick {
    
     [self downLoadInfo];
}

- (void)setPram
{
    self.nameTextF.delegate = self;
    self.iphoneTextF.delegate = self;
    [self.nameTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}


#pragma mark - 点击小区
- (IBAction)xiaoQuClick:(UIButton *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiShouHuoDiZhi" bundle:nil];
    ZTXiaoQuXuanZeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTXiaoQuXuanZeViewController"];
    vc.address_id = self.qu_id;
    [vc setAddressBlack:^(ZTXiaoQuXuanZe *model) {
       
        self.xiaoQuLab.text =  model.village;
        self.xiaoQu_id = model.id;

    }];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)isBianJiAddress
{
    if (self.isAddAddress == YES) {
        
        self.title = @"添加收货地址";
    }
    else
    {
        self.title = @"编辑收货地址";
        [self downLoadInfoXiangQin];
    }
}

#pragma mark - 地址详情
- (void)downLoadInfoXiangQin
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.address_id forKey:@"id"];
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KShenShiQuAddressOne parameter:dic success:^(NSDictionary * resultCode) {
        
        self.dataModel = [ZTBianjiModel modelWithDictionary:resultCode];
        
        self.nameTextF.text = self.dataModel.realname;
        self.iphoneTextF.text = self.dataModel.phone;
        self.isMoRenAddress.on = [self.dataModel.defaults isEqualToString:@"2"];
        if ([self.dataModel.sex isEqualToString:@"女"]) {
            [self genderBtnClick:self.ladyBtn];
        }else{
            [self genderBtnClick:self.sirBtn];
        }
        self.address2TextV.text = self.dataModel.address;
        self.xiaoQuLab.text = self.dataModel.village_name;
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
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
    
    if ([self.address2TextV.text length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"详细地址不能为空哦!"];
        return;
    }
    if ([self.xiaoQu_id length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"小区不能为空哦!"];
        return;
    }
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.nameTextF.text forKey:@"realname"];
    [dic setObject:self.iphoneTextF.text forKey:@"phone"];
    [dic setObject:self.qu_id forKey:@"qu"]; //village
    //address -> postion;
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
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KAddShouHuoAddress parameter:dic success:^(id resultCode) {
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        if (self.relshBlack) {
            
            self.relshBlack();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        SVDCommonErrorDeal;
    }];
}


#pragma mark -编辑收货地址
- (void)editingTheAddress{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.nameTextF.text forKey:@"realname"];
    [dic setObject:self.iphoneTextF.text forKey:@"phone"];
    [dic setObject:self.qu_id forKey:@"qu"]; //village
    //address -> postion;
    [dic setObject:self.address2TextV.text forKey:@"address"];
    [dic setObject:self.xiaoQu_id forKey:@"village"];
    [dic setObject:self.address_id forKey:@"id"];
    // 是默认地址
    if (_isMoRenAddress.on == YES) {
        
        [dic setObject:@"2" forKey:@"defaults"];
    }
    else// 不是默认地址
    {
        [dic setObject:@"1" forKey:@"defaults"];
    }

    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KBianJiShouHuoAddress parameter:dic success:^(id resultCode) {
        
    } failure:^(NSError *error) {
        
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
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

- (IBAction)genderBtnClick:(UIButton *)sender {
    
    self.currentSelectSexBtn.selected = NO;
    sender.selected = YES;
    self.currentSelectSexBtn = sender;
}


@end
