//
//  SelectCardViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "SelectCardViewController.h"

@interface SelectCardViewController ()

@end

@implementation SelectCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardPocklistModel * model = self.dataArray[indexPath.row];
    !self.returnBlock?:self.returnBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
