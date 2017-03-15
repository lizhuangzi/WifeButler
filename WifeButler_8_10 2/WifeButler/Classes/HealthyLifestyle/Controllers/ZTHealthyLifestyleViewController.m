
//
//  ZTHealthyLifestyleViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTHealthyLifestyleViewController.h"
#import "masonry.h"
#import "XMGSocialViewController.h"
#import "WifeButlerNetWorking.h"
#import "InformationPort.h"

#import "WifeButlerDefine.h"

#import "ZTJianKangShenHuoTopModel.h"
#import "MJExtension.h"

@interface ZTHealthyLifestyleViewController ()
@property (nonatomic,assign) BOOL isLoadSuccess;
@property (nonatomic,strong) NSMutableArray * TopModelArray;

@end

@implementation ZTHealthyLifestyleViewController

- (NSMutableArray *)TopModelArray
{
    if (!_TopModelArray) {
        _TopModelArray = [NSMutableArray array];
    }
    return _TopModelArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isLoadSuccess = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WEAKSELF
    if (!self.isLoadSuccess) {
        [self requestSliderDataAndSuccessBlock:^{
            
            [weakSelf setupChildVcWithArray:weakSelf.TopModelArray];
            
            [weakSelf config];
        }];
    }
}

/**请求顶部模块数据*/
- (void)requestSliderDataAndSuccessBlock:(void(^)())block
{
    
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KinformationType parameter:nil success:^(id resultCode) {
        self.isLoadSuccess = YES;
        NSDictionary *result = resultCode;
        NSArray * cats = result[@"cats"];
       
        self.TopModelArray = [ZTJianKangShenHuoTopModel mj_objectArrayWithKeyValuesArray:cats];
        
        if (block) {
            block();
        }
    
    } failure:^(NSError *error) {
        self.isLoadSuccess = NO;
    }];
}

- (void)setupChildVcWithArray:(NSArray *)array {
    
    for (int i = 0; i<array.count; i++) {
        
        ZTJianKangShenHuoTopModel * model = array[i];
        XMGSocialViewController *social = [[XMGSocialViewController alloc] init];
        social.title = model.name;
        social.controllerId = model.Id;
        [self addChildViewController:social];
    }
}

@end
