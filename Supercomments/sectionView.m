//
//  sectionView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/11.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "sectionView.h"

@implementation sectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.picimg];
        [self addSubview:self.namelab];
        [self addSubview:self.timelab];
        [self addSubview:self.contentlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.picimg.frame = CGRectMake(14*WIDTH_SCALE, 14*HEIGHT_SCALE, 32*WIDTH_SCALE, 32*WIDTH_SCALE);
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE+32*WIDTH_SCALE+14*WIDTH_SCALE, 14*HEIGHT_SCALE, 80*WIDTH_SCALE, 14*HEIGHT_SCALE);
    self.timelab.frame = CGRectMake(14*WIDTH_SCALE+32*WIDTH_SCALE+14*WIDTH_SCALE, 14*HEIGHT_SCALE+20*HEIGHT_SCALE, 80*WIDTH_SCALE, 11*HEIGHT_SCALE);
    
}


#pragma mark - getters


-(UIImageView *)picimg
{
    if(!_picimg)
    {
        _picimg = [[UIImageView alloc] init];
        _picimg.backgroundColor = [UIColor orangeColor];
        _picimg.layer.masksToBounds = YES;
        _picimg.layer.cornerRadius = 16*WIDTH_SCALE;
    }
    return _picimg;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.text = @"姓名姓名";
        _namelab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
        _namelab.font = [UIFont systemFontOfSize:14*FX];
    }
    return _namelab;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.text = @"12:00";
        _timelab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
        _timelab.font = [UIFont systemFontOfSize:11*FX];
    }
    return _timelab;
}

-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.numberOfLines = 0;
        _contentlab.textColor = [UIColor wjColorFloat:@"333333"];
        _contentlab.font = [UIFont systemFontOfSize:16*FX];
        _contentlab.text = @"赵客缦胡缨，吴钩霜雪明。银鞍照白马，飒沓如流星。十步杀一人，千里不留行。事了拂衣去，深藏身与名。";
        CGSize textSize = [_contentlab setText:_contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 94*WIDTH_SCALE-14*WIDTH_SCALE,MAXFLOAT)];
        
        self.contentlab.frame = CGRectMake(14*WIDTH_SCALE+32*WIDTH_SCALE+14*WIDTH_SCALE,  60*HEIGHT_SCALE, textSize.width, textSize.height);
        
        _hei = textSize.height;
    }
    return _contentlab;
}


@end
