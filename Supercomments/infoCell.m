//
//  infoCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "infoCell.h"

@implementation infoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftimg];
        [self.contentView addSubview:self.textlab];
        [self.contentView addSubview:self.rightimg];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.leftimg.frame = CGRectMake(14*WIDTH_SCALE, 20*HEIGHT_SCALE, 20*WIDTH_SCALE, 22*WIDTH_SCALE);
    self.textlab.frame = CGRectMake(60*WIDTH_SCALE, 20*HEIGHT_SCALE, 100*WIDTH_SCALE, 20*HEIGHT_SCALE);
    self.numlab.frame = CGRectMake(DEVICE_WIDTH-60, 20, 20, 20);
    self.rightimg.frame = CGRectMake(DEVICE_WIDTH-30, 22.5, 10, 15);
    
}

#pragma mark - getters


-(UIImageView *)leftimg
{
    if(!_leftimg)
    {
        _leftimg = [[UIImageView alloc] init];
        
    }
    return _leftimg;
}

-(UILabel *)textlab
{
    if(!_textlab)
    {
        _textlab = [[UILabel alloc] init];
        
    }
    return _textlab;
}

-(UILabel *)numlab
{
    if(!_numlab)
    {
        _numlab = [[UILabel alloc] init];
        _numlab.backgroundColor = [UIColor redColor];
        _numlab.layer.masksToBounds = YES;
        _numlab.layer.cornerRadius = 10;
        _numlab.textColor = [UIColor whiteColor];
        _numlab.alpha = 0;
        _numlab.font = [UIFont systemFontOfSize:10];
        _numlab.textAlignment = NSTextAlignmentCenter;
    }
    return _numlab;
}

-(UIImageView *)rightimg
{
    if(!_rightimg)
    {
        _rightimg = [[UIImageView alloc] init];
        _rightimg.image = [UIImage imageNamed:@"矩形-38-拷贝"];
    }
    return _rightimg;
}




@end
