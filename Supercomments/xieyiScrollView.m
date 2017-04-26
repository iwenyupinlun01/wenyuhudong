//
//  xieyiScrollView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/26.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "xieyiScrollView.h"

@implementation xieyiScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.xieyiimg];
    }
    return self;
}

#pragma mark - getters

-(UIImageView *)xieyiimg
{
    if(!_xieyiimg)
    {
        _xieyiimg = [[UIImageView alloc] init];
        _xieyiimg.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+1000);
        _xieyiimg.image = [UIImage imageNamed:@"牛评用户协议.jpg"];
        _xieyiimg.contentMode = UIViewContentModeRedraw;
    }
    return _xieyiimg;
}




@end
