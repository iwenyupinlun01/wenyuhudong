//
//  titleView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "titleView.h"

@interface titleView()
@property (nonatomic,strong) UIImageView *sanjiaoxin;
@end

@implementation titleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sanjiaoxin];
        [self addSubview:self.titlelab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.sanjiaoxin.frame = CGRectMake(25*WIDTH_SCALE, 0, 10*WIDTH_SCALE, 8*HEIGHT_SCALE);
    self.titlelab.frame = CGRectMake(0, 8*HEIGHT_SCALE, self.frame.size.width, 20*HEIGHT_SCALE);
}

#pragma mark - getters

-(UIImageView *)sanjiaoxin
{
    if(!_sanjiaoxin)
    {
        _sanjiaoxin = [[UIImageView alloc] init];
        _sanjiaoxin.image = [UIImage imageNamed:@"矩形-30-拷贝"];
    }
    return _sanjiaoxin;
}

-(UILabel *)titlelab
{
    if(!_titlelab)
    {
        _titlelab = [[UILabel alloc] init];
        _titlelab.textColor = [UIColor wjColorFloat:@"576B95"];
        //_titlelab.textColor = [UIColor redColor];
        _titlelab.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
        _titlelab.font = [UIFont systemFontOfSize:13*FX];
        //_titlelab.numberOfLines = 0;
    }
    return _titlelab;
}

@end
