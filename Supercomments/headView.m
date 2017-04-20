//
//  headView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "headView.h"

@implementation headView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.infoimg];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.infoimg.frame = CGRectMake(DEVICE_WIDTH/2-35*WIDTH_SCALE, self.frame.size.height/2-50*WIDTH_SCALE, 70*WIDTH_SCALE, 70*WIDTH_SCALE);
}

#pragma mark - getters

-(UIImageView *)infoimg
{
    if(!_infoimg)
    {
        _infoimg = [[UIImageView alloc] init];
        _infoimg.layer.masksToBounds = YES;
        _infoimg.layer.cornerRadius = 35*WIDTH_SCALE;
        _infoimg.backgroundColor = [UIColor orangeColor];
        _infoimg.userInteractionEnabled = YES;
    }
    return _infoimg;
}



@end
