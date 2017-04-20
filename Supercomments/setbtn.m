//
//  setbtn.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "setbtn.h"

@interface setbtn()
@property (nonatomic,strong) UILabel *leftlab;
@property (nonatomic,strong) UIImageView *rightimg;
@end


@implementation setbtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftlab];
        [self addSubview:self.rightimg];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftlab.frame = CGRectMake(0, 0, self.frame.size.width/3*2, self.frame.size.height);
    self.rightimg.frame = CGRectMake(self.frame.size.width/3*2, 0, self.frame.size.width/3, self.frame.size.height);
}

#pragma mark - getters

-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.text = @"回复";
        _leftlab.textAlignment = NSTextAlignmentCenter;
        _leftlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _leftlab.font = [UIFont systemFontOfSize:10];
    }
    return _leftlab;
}

-(UIImageView *)rightimg
{
    if(!_rightimg)
    {
        _rightimg = [[UIImageView alloc] init];
        _rightimg.image = [UIImage imageNamed:@"评"];
    }
    return _rightimg;
}


@end
