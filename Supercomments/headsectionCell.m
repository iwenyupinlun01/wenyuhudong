//
//  headsectionCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/18.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "headsectionCell.h"
#import "headViewModel.h"

@interface headsectionCell()
@property (nonatomic,strong) headViewModel *headmodel;
@end

@implementation headsectionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.fromlab];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.numberlab];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.dianzanbtn];
        [self.contentView addSubview:self.combtn];
        [self.contentView addSubview:self.sharebtn];
        [self.contentView addSubview:self.headimg];
        [self.contentView addSubview:self.thumlabel];
        [self.contentView addSubview:self.lineview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE, 16*HEIGHT_SCALE, DEVICE_WIDTH/2, 14*HEIGHT_SCALE);
    self.fromlab.frame = CGRectMake(DEVICE_WIDTH-200*WIDTH_SCALE, 18*WIDTH_SCALE, 185*WIDTH_SCALE, 12*HEIGHT_SCALE);
    self.numberlab.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-14*HEIGHT_SCALE-8*HEIGHT_SCALE, 100*WIDTH_SCALE, 14*HEIGHT_SCALE);
    _lineview.frame = CGRectMake(14, self.frame.size.height-1, DEVICE_WIDTH-28, 1);
    
}

-(void)setdata:(headViewModel *)model
{
    self.headmodel = model;
    self.namelab.text = model.namestr;
    
    
}

#pragma mark - getters

-(UIView *)lineview
{
    if(!_lineview)
    {
        _lineview = [[UIView alloc] init];
        _lineview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _lineview;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.textColor = [UIColor wjColorFloat:@"666666"];
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
        _timelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _timelab.font = [UIFont systemFontOfSize:13*FX];
    }
    return _timelab;
}

-(zanBtn *)dianzanbtn
{
    if(!_dianzanbtn)
    {
        _dianzanbtn =  [[zanBtn alloc] init];
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
        _thumlabel.textColor = [UIColor wjColorFloat:@"576b95"];
    }
    return _thumlabel;
}

-(UIImageView *)headimg
{
    if(!_headimg)
    {
        _headimg = [[UIImageView alloc] init];
        _headimg.userInteractionEnabled = YES;
    }
    return _headimg;
}

@end
