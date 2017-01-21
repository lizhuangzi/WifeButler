//
//  ZJCommunityShopHeaderView.h
//  YouHu
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJLabelClickDelegate <NSObject>

- (void)labelClickWithType:(NSString *)type;

@end
@interface ZJCommunityShopHeaderView : UICollectionReusableView
@property(nonatomic,weak)id<ZJLabelClickDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView  *viewLunBo;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

-(void)setLabel;

@end
