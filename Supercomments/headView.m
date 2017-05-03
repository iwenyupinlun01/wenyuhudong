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
        [self addSubview:self.namelab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.infoimg.frame = CGRectMake(DEVICE_WIDTH/2-35*WIDTH_SCALE, self.frame.size.height/2-50*WIDTH_SCALE, 70*WIDTH_SCALE, 70*WIDTH_SCALE);
    self.namelab.frame = CGRectMake(0, (140+52+14)/2, DEVICE_WIDTH, 14);
    
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

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.textColor = [UIColor wjColorFloat:@"333333"];
        _namelab.textAlignment = NSTextAlignmentCenter;
        _namelab.font = [UIFont systemFontOfSize:14];
        _namelab.text = @"激动激动激动就";
    }
    return _namelab;
}




@end
