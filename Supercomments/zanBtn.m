//
//  zanBtn.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "zanBtn.h"

@interface zanBtn()
@property (nonatomic,strong) UIImageView *zanimg;
@end

@implementation zanBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.zanimg];
        [self addSubview:self.zanlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.zanimg.frame = CGRectMake(5*WIDTH_SCALE, 2*HEIGHT_SCALE, 18*WIDTH_SCALE, 18*WIDTH_SCALE);
    self.zanlab.frame = CGRectMake(25*WIDTH_SCALE, 2*HEIGHT_SCALE, 20*WIDTH_SCALE, 20*HEIGHT_SCALE);
}

#pragma mark - getters

-(UIImageView *)zanimg
{
    if(!_zanimg)
    {
        _zanimg = [[UIImageView alloc]init];
        _zanimg.image = [UIImage imageNamed:@"点赞-"];
    }
    return _zanimg;
}

-(UILabel *)zanlab
{
    if(!_zanlab)
    {
        _zanlab = [[UILabel alloc] init];
        _zanlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _zanlab.textAlignment = NSTextAlignmentRight;
        _zanlab.font = [UIFont systemFontOfSize:13];
        _zanlab.text = @"20";
    }
    return _zanlab;
}
@end
