//
//  detailsheadView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "detailsheadView.h"
#import "headModel.h"
@interface detailsheadView()
@property (nonatomic,strong) headModel *hmodel;
@end

@implementation detailsheadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.namelab];
        [self addSubview:self.contentlab];
        [self addSubview:self.fromlab];
        [self addSubview:self.numberlab];
        [self addSubview:self.title];
        [self addSubview:self.timelab];
        [self addSubview:self.dianzanbtn];
        [self addSubview:self.combtn];
        [self addSubview:self.sharebtn];
        [self addSubview:self.thumlabel];
        [self addSubview:self.headimg];
        [self addSubview:self.thumlabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE, 16*HEIGHT_SCALE, DEVICE_WIDTH/2, 14*HEIGHT_SCALE);
    self.fromlab.frame = CGRectMake(DEVICE_WIDTH-200*WIDTH_SCALE, 18*WIDTH_SCALE, 185*WIDTH_SCALE, 12*HEIGHT_SCALE);
    self.numberlab.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-18*HEIGHT_SCALE-14*HEIGHT_SCALE, 100*WIDTH_SCALE, 14*HEIGHT_SCALE);
}

#pragma mark - getters

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _namelab.font = [UIFont systemFontOfSize:14*FX];
    }
    return _namelab;
}

-(UILabel *)fromlab
{
    if(!_fromlab)
    {
        _fromlab = [[UILabel alloc] init];
        _fromlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _fromlab.font = [UIFont systemFontOfSize:12*FX];
        _fromlab.text = @"来自网易老司机的评论";
        _fromlab.textAlignment = NSTextAlignmentRight;
    }
    return _fromlab;
}

-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.textColor = [UIColor wjColorFloat:@"333333"];
    }
    return _contentlab;
}

-(UILabel *)numberlab
{
    if(!_numberlab)
    {
        _numberlab = [[UILabel alloc] init];
        _numberlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _numberlab.font = [UIFont systemFontOfSize:14*FX];
        _numberlab.text = @"2人评论";
    }
    return _numberlab;
}

-(titleView *)title
{
    if(!_title)
    {
        _title = [[titleView alloc] init];
    }
    return _title;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        //_timelab.text = @"三分钟前";
        _timelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _timelab.font = [UIFont systemFontOfSize:13*FX];
    }
    return _timelab;
}

-(zanBtn *)dianzanbtn
{
    if(!_dianzanbtn)
    {
        _dianzanbtn =  [zanBtn buttonWithType:UIButtonTypeCustom];;
    }
    return _dianzanbtn;
}


-(commentsBtn *)combtn
{
    if(!_combtn)
    {
        _combtn = [[commentsBtn alloc] init];
        
    }
    return _combtn;
}

-(UIButton *)sharebtn
{
    if(!_sharebtn)
    {
        _sharebtn = [[UIButton alloc] init];
        [_sharebtn setImage:[UIImage imageNamed:@"分享"] forState:normal];
    }
    return _sharebtn;
}


-(UILabel *)thumlabel
{
    if(!_thumlabel)
    {
        _thumlabel = [[UILabel alloc] init];
        _thumlabel.textColor = [UIColor wjColorFloat:@"C7C7CD"];
    }
    return _thumlabel;
}

-(UIImageView *)headimg
{
    if(!_headimg)
    {
        _headimg = [[UIImageView alloc] init];
        _headimg.backgroundColor = [UIColor greenColor];
    }
    return _headimg;
}

@end
