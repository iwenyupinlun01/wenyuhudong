//
//  myinfoCell0.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "myinfoCell0.h"

@implementation myinfoCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.infoimage];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftlab.frame = CGRectMake(14*WIDTH_SCALE, 15*HEIGHT_SCALE, 80*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.infoimage.frame = CGRectMake(DEVICE_WIDTH-28*WIDTH_SCALE-36*WIDTH_SCALE, 30*HEIGHT_SCALE-18*HEIGHT_SCALE, 36*WIDTH_SCALE, 36*WIDTH_SCALE);
}

#pragma mark - getters

-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.text = @"头像";
        _leftlab.textColor = [UIColor wjColorFloat:@"5D5E5F"];
    }
    return _leftlab;
}

-(UIImageView *)infoimage
{
    if(!_infoimage)
    {
        _infoimage = [[UIImageView alloc] init];
        _infoimage.layer.masksToBounds = YES;
        _infoimage.layer.cornerRadius = 18*WIDTH_SCALE;
       // _infoimage.backgroundColor = [UIColor orangeColor];
    }
    return _infoimage;
}

@end
