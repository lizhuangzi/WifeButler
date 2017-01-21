//
//  UIImageView+Del.m
//  ConstructionSite
//
//  Created by zjtdmac2 on 15/7/29.
//  Copyright (c) 2015年 zjtdmac2. All rights reserved.
//

#import "UIImageView+Del.h"

@implementation UIImageView (Del)

id<UIImageViewDelDelegate> _delDelegate;

-(instancetype)initDelWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        
        UIButton * del =[UIButton buttonWithType:UIButtonTypeCustom];
        
//        UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        
//        contentEdgeInsets
        
//        del.contentEdgeInsets = UIEdgeInsetsMake(15, 15, <#CGFloat bottom#>, <#CGFloat right#>)
        
        del.frame=CGRectMake(self.frame.size.width-10,-5, 15, 15);
        [del setImage:[UIImage imageNamed:@"delete-circular"] forState:UIControlStateNormal];
        [self addSubview:del];
        [del addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)del:(UIButton *)button
{
    [self.delDelegate imageViewDel:self];
}
- (void)setDelDelegate:(id<UIImageViewDelDelegate>)delDelegate
{
    _delDelegate = delDelegate;
}

-(id<UIImageViewDelDelegate>)delDelegate
{
    return _delDelegate;
}
@end
